#! /usr/bin/perl -w
#
#     ese_txt2make.pl - sorts equations using Make
#     Copyright (C) 2004  Geraint Paul Bevan
#
#     This program is free software; you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation; either version 2 of the License, or
#     (at your option) any later version.
#
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with this program; if not, write to the Free Software
#     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
#		--------------------------
#		Model Transformation Tools
#		--------------------------
#
# Creates a makefile from the elementary system equations
# Executing the makefile causes make to sort the equations
#
#-------------------------------------------------------------------------------

use strict;
use Getopt::Long;

my %dependencies;		# left-values right-dependencies
my %expressions;		# left-values right-expression

my $sys		= '';
my $debug	=  0;
my $infile	= '';
my $outfile	= '';

GetOptions ('sys=s'	=> \$sys,
	    'debug'	=> \$debug,
	    'infile=s'	=> \$infile,
	    'outfile=s'	=> \$outfile);

# default file names
$infile	 = "${sys}_ese.txt"	if ($infile  eq '');
$outfile = "${sys}_ese.make"	if ($outfile eq '');

#-------------------------------------------------------------------------------
# main
#-------------------------------------------------------------------------------

if ($debug) {
    my $logfile = "ese_txt2make_${sys}.log";
    open (LOG, ">$logfile") or die ("MTT: ese_txt2make, cannot open $logfile");
}

# First the elementary system equations are read
# and placed in the "expressions" hash.
read_ese_txt ();

# Then the occurence of any lvalue in the expression
# of any other is sought. 
get_dependencies ();

# Finally the expressions are written to a makefile
# where the targets are the left hand values and the
# pre-requisites are the dependencies
write_make ($sys);

close (LOG) if ($debug);

#-------------------------------------------------------------------------------
# subroutines
#-------------------------------------------------------------------------------
sub read_ese_txt {

    open (ESE, $infile)
	or die ("MTT Error:\nese_txt2make, cannot open $infile\n");

    while (<ESE>) {

	chomp;

	# separate the left and right side of equations
	# and assign them to the expressions hash
	my ($lvar,$expr) = split (/:=/);
	$expressions{$lvar} = $expr;

	print LOG "$lvar\t= $expressions{$lvar}\n" if $debug;
    }
    
    close (ESE);
}
#-------------------------------------------------------------------------------
sub get_dependencies {

    # compare the pattern to each expression
    foreach my $lvar (keys %expressions) {
	$dependencies{$lvar} = "";
	$_ = $expressions{$lvar};
	for my $lvar2 (keys %expressions) {
	    if ($expressions{$lvar} =~ /$lvar2/) {
		# a left value has been found in the expression
		# add it to the dependencies for this lvar
		$dependencies{$lvar} = "$dependencies{$lvar} $lvar2";
	    }
	}
	print LOG "$lvar:\t$dependencies{$lvar}\n" if $debug;
    }
}
#-------------------------------------------------------------------------------
sub write_make {
    
    # create lists of rates, states and tmpvars so that
    # separate rules can be created in the makefile
    my @list_of_rates;
    my @list_of_outputs;
    my @list_of_unknown;
    my @list_of_nonstates;
    my @list_of_tmpvars;

    for my $lvar (sort (keys %expressions)) {
	if ($lvar =~ /^MTTdX\(/) {
	    @list_of_rates = (@list_of_rates, $lvar) ;
	} elsif ($lvar =~ /^MTTy\(/) {
	    @list_of_outputs = (@list_of_outputs, $lvar);
	} elsif ($lvar =~ /^MTTyz/) {
	    @list_of_unknown = (@list_of_unknown, $lvar);
	} elsif ($lvar =~ /^MTTz/) {
	    @list_of_nonstates = (@list_of_nonstates, $lvar);
	} elsif ($lvar =~ /^${sys}_/) {
	    @list_of_tmpvars = (@list_of_tmpvars, $lvar);
	} else {
	    die "MTT Error:\nese_txt2make, unclassified variable: $lvar\n";
	}
    }
    my @sorted_rates     = sort (@list_of_rates);
    my @sorted_outputs   = sort (@list_of_outputs);
    my @sorted_unknown   = sort (@list_of_unknown);
    my @sorted_nonstates = sort (@list_of_nonstates);
    my @sorted_tmpvars   = sort (@list_of_tmpvars);


    # write the header
    open (ESE, ">$outfile") or
	die ("MTT Error:\nese_txt2make, cannot open $outfile\n");

    my $date = localtime;

    print ESE
	"# $outfile\t-*-makefile-*-\n" .
	"#\n";

    print ESE
	"#\t\t--------------------------\n" .
	"#\t\tModel Transformation Tools\n" .
	"#\t\t--------------------------\n" .
        "#\n" .
	"# Created by MTT: $date\n\n";    

    # write the rules that external programs use
    print ESE
        "all: declare_tmpvars MTTdX MTTy\n\n" .
	"MTTdX: @sorted_rates\n\n" .
	"MTTy:  @sorted_outputs\n\n" .
	"MTTyz: @sorted_unknown\n\n" .
	"MTTz:  @sorted_nonstates\n\n";
    
    # set the default output format:
    # double tmpvar;
    # lvalue := expression;
    print ESE
	"# default output format\n" .
	"ifeq (\"\$(assignment)\",\"\")\n" .
	"assignment=:=\n" .
	"endif\n\n" .
	"ifeq (\"\$(declaration)\",\"\")\n" .
	"declaration=double\n" .
	"endif\n\n" .
	"ifeq (\"\$(terminator)\",\"\")\n" .
	"terminator=;\n" .
	"endif\n\n";

    # write a rule to declare the temporary variables
    print ESE
	"# declare temporary variables\n" .
	"declare_tmpvars:\n";
    for my $var (@sorted_tmpvars) {
	print ESE "\t\@echo \"\$(declaration) $var \$(terminator)\"\n";
    }
    print ESE "\n";

    # write the equations
    print ESE "# the equations\n";
    for my $lvar (sort (keys %expressions)) {
	print ESE "$lvar: $dependencies{$lvar}\n";
	print ESE "\t\@echo \"$lvar \$(assignment) " .
	    "$expressions{$lvar} \$(terminator)\"\n\n";
    }
    print ESE "\n";

    close (ESE);
}
#-------------------------------------------------------------------------------
