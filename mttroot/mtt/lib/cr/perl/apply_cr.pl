#! /usr/bin/perl -w
#
#     apply_cr.pl - apply specified CRs to text on standard input
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
#
#-------------------------------------------------------------------------------

use strict;
use Getopt::Long;

my $cr_name='';
#-------------------------------------------------------------------------------
# arguments and options
#-------------------------------------------------------------------------------
my $crlist	= '';
my $debug	= 0;
my $help	= 0;

GetOptions ('debug'	=> \$debug,
	    'help'	=> \$help);

#-------------------------------------------------------------------------------
# globals
#-------------------------------------------------------------------------------

my @expressions;
my @prefixes;

my $expression;
my $i = 0;

#-------------------------------------------------------------------------------
# subroutine declarations
#-------------------------------------------------------------------------------
sub substitute_subexpressions();
sub process_expression();
sub display_subexpressions();
sub reassemble_expression();
sub usage();

#-------------------------------------------------------------------------------
# main
#-------------------------------------------------------------------------------

if ($help) {
    usage();
    exit 1;
}

while (<STDIN>) {
    $expression = $_;
    print STDERR "Start Expression -> $expression\n" if $debug;

    $i = 0;
    @expressions = ();
    @prefixes = ();

    substitute_subexpressions();
    display_subexpressions () if ($debug);
    
    for ($i = 0; $i <= $#expressions; $i++) {
	process_expression ();
    }
    
    display_subexpressions () if ($debug);
    reassemble_expression ();
    print STDOUT "$expression";
}

#-------------------------------------------------------------------------------
# subroutines
#-------------------------------------------------------------------------------
sub substitute_subexpressions() {
    
    while ($expression =~ /\(.*\)/) {
	$_ = $expression;
	# get a matched pair of brackets
	s/ (.*) ( \({1} [^\(\)]* \){1} ) (.*) /$1 : $2 : $3/x;
	
	my $extracted;
	my $remainder;
	my $skipped;
	($skipped, $extracted, $remainder) = split (/ : /);
	
	$expressions[$i] = $extracted if $extracted;
	
	$_ = $skipped;
	s/(\s)//g;			# strip whitespace
	s/ (.*?) (\w*)$ /$2/x;	# get function name (if any)
	$prefixes[$i] = $_;
	$skipped =~ s/(.*)$prefixes[$i]$/$1/;
	
	$expression = "$skipped\{$i\}$remainder";
	
	$i++;
    }
    $expressions[$i] = $expression;
#    $prefixes[$i] = "";
}
#-------------------------------------------------------------------------------
sub process_expression() {

    my $cr = '';
    foreach my $cr_name (@ARGV) {	
	if ($prefixes[$i]) {
	    if ($prefixes[$i] eq $cr_name) {
		$cr = $cr_name;
	    }
	}
    }
    if ($cr eq '') {
	return;
    }

    # call cr(arg1,arg2,...) User-defined CR in the model directory
    if (-e "$cr.pm") {
	my $expr = $expressions[$i];
	eval "require $cr";
	$cr->import (@_[1 .. $#_]);    
	no strict 'refs';		# allow symbolic references
	my $substitution = &$cr ($expr);
	use strict 'refs';
	if ($substitution) {
	    $prefixes[$i] = "";
	    $expressions[$i] = "$substitution";
	}
    }
    # call cr(arg1,arg2,...) Standard CR in the mtt namespace
    if (-e "mtt/$cr.pm") {
	my $expr = $expressions[$i];
	my $mttcr = "mtt::$cr";
	eval "require 'mtt/$cr.pm'";
	$mttcr->import (@_[1 .. $#_]);
	no strict 'refs';		# allow symbolic references
	my $substitution = &$cr ($expr);
	use strict 'refs';
	if ($substitution) {
	    $prefixes[$i] = "";
	    $expressions[$i] = "$substitution";
	}
    }
}
#-------------------------------------------------------------------------------
sub display_subexpressions() {

    for ($i = 0; $i <= $#expressions; $i++) {
	my $prefix = " ";
	$prefix = $prefixes[$i] if ($prefixes[$i]); 
	print STDERR "$i\t($prefix)\t$expressions[$i]\n\n";
    }    
}
#-------------------------------------------------------------------------------
sub reassemble_expression () {

    $expression = $expressions[$#expressions];

    for ($i = $#expressions; $i >= 0; $i--) {
	print STDERR "{$i}: $expressions[$i]\n" if $debug;
	$expression =~ s/\{$i\}/$prefixes[$i]$expressions[$i]/g;
    }
    print STDERR "Final expression -> $expression\n" if $debug;
}
#-------------------------------------------------------------------------------
sub usage() {
    
    print STDOUT
	"\nUsage: $0 [options] crname1 crname2 ..\n" .
	"\n" .
	"\toptions:\n" .
	"\t--debug\n" .
	"\t--help\n" .
	"\n";
}
