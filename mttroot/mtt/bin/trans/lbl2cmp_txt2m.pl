#! /usr/bin/perl -w

### lbl2cmp_txt2m
## Creates _cmp.m from _lbl.txt
## Copyright (C) 2004 by Geraint Paul Bevan

  ###################################### 
  ##### Model Transformation Tools #####
  ######################################

use strict;
use diagnostics;
use Getopt::Long;

sub usage;
sub read_cmp_file;
sub read_cmp_line;
sub name_anonymous_component;
sub port_or_component_or_junction;
sub read_lbl_file;
sub read_lbl_line;
sub write_header;
sub write_body;
sub strip_rubbish;

## fields to write to cmp.m
my (@component_name,
    %component_type,    
    %component_cr,
    %component_arg,
    %component_rep);

my $sys = '';

GetOptions ('sys=s' => \$sys);

die usage() if ($sys eq '');

## files to read/write
my $lbl = "${sys}_lbl.txt";
my $cmp = "${sys}_cmp.txt";
my $out = "${sys}_cmp.m";

## other global variables
my (%anonymous_component_type_index);

my $debug = 1;

read_cmp_file();
read_lbl_file();

write_header();
write_body();


sub usage() {
    return "Usage: lbl2cmp_txt2m --sys=<sys>\n";
}

sub read_cmp_file() {
    my ($line, $name, $type, $class, $rep, $i);

    my (@c_name, %c_type, %c_rep, $i_c);
    my (@j_name, %j_type, %j_rep, $i_j);
    my (@p_name, %p_type, %p_rep, $i_p);

    $i_c = 0;			# component counter
    $i_j = 0;			# junction counter
    $i_p = 0;			# port counter

    open (CMP, $cmp) or die ("MTT: lbl2cmp_txt2m, cannot open $cmp");
    
    while (<CMP>) {
	
	chomp;
	# skip blank lines
	next if (/^(\s)*$/);
	# skip comments
	next if (/^(\s)*[%\#]/);
	# remove leading and trailing whitespace
	s/^\s*(\S.*\S)\s*$/$1/;
	
	$line = $_;
	print "read_cmp_file: line='${line}'\n" if defined ($debug);

	($type, $name, $rep) = read_cmp_line($line);
	$name = name_anonymous_component($type) if ($name eq '');
	
	$class = port_or_component_or_junction ($type, $name);
	if ($class eq "port") {
	    $i_p++;
	    $p_name[$i_p]  = $name;
	    $p_type{$name} = $type;
	    $p_rep{$name}  = $rep;
	} elsif ($class eq "component") {
	    $i_c++;
	    $c_name[$i_c]  = $name;
	    $c_type{$name} = $type;
	    $c_rep {$name} = $rep;
	} elsif ($class eq "junction") {
	    $i_j++;
	    $j_name[$i_j]  = $name;
	    $j_type{$name} = $type;
	    $j_rep {$name} = $rep;
	} else {
	    die "MTT: lbl2cmp_txt2m.pl, read_cmp_file: unclassified component";
	}
    }
    close (CMP);

    $i = 0;
 
    # assign ports (SS:[])
   my $offset = 0;
    while ($i < ($offset + $i_p)) {
	$i++;
	$name = $p_name[$i];
	$component_name[$i] = $name;
	$component_type{$name} = $p_type{$name};
	$component_rep {$name} = $p_rep{$name};
	$component_cr  {$name} = '';
	$component_arg {$name} = '';
    }

    # then assign components (including SS)
    $offset = $i_p;
    while ($i < ($offset + $i_c)) {
	$i++;
	$name = $c_name[${i}-${offset}];
	$component_name[$i] = $name;
	$component_type{$name} = $c_type{$name};
	$component_rep {$name} = $c_rep{$name};
	$component_cr  {$name} = '';
	$component_arg {$name} = '';
    }

    # then assign junctions
    $offset = $i_p + $i_c;
    while ($i < ($offset + $i_j)) {
	$i++;
	$name = $j_name[${i}-${offset}];
	$component_name[$i] = $name;
	$component_type{$name} = $j_type{$name};
	$component_rep {$name} = $j_rep{$name};
	$component_cr  {$name} = '';
	$component_arg {$name} = '';
    }
}

sub read_cmp_line() {
    my $line = $_;
    my ($type, $name, $rep, $misc);
    
    ($type, $misc) = split (/:/, $line);
    $type = $line unless defined ($type);

    if (defined ($misc)) {
	($name, $rep) = split (/\*/, $misc);
	$name = $misc unless defined ($name);
    }

    $name = '' unless defined $name;
    $rep  = 1  unless defined $rep;
    
    print "read_cmp_line: type='$type', name='$name', rep='$rep'\n" if defined ($debug);
    return ($type, $name, $rep);
}

sub name_anonymous_component() {
    my $type = @_;
    my ($name, $num);
    if (defined ($anonymous_component_type_index{$type})) {
	$anonymous_component_type_index{$type}++;
    } else {
	$anonymous_component_type_index{$type} = 0;
    }
    $num  = $anonymous_component_type_index{$type};
    $name = "mtt${type}_${num}";
    print "name_anonymous_component: type='${type}', name='${name}'\n" if defined ($debug);
    return ($name);
}

sub port_or_component_or_junction() {
    my ($type, $name) = @_;
    my $retval;
    if ($type eq "SS") {
	$_ = $name;
	if (/\[.+\]/) {
	    $retval = "port";
	} else {
	    $retval = "component";
	}
    } elsif (($type eq "0") or ($type eq "1")) {
	$retval = "junction";
    } else {
	$retval = "component";
    }
    print "port_or_component_or_junction: type='$type', name='$name' class='$retval'\n" if defined ($debug);
    return ($retval);
}

sub read_lbl_file() {
    my (@line, $name, $type, $cr, $arg, $i);
    
    open (LBL, $lbl) or die ("MTT: lbl2cmp_txt2m, cannot open $lbl");
    
    while (<LBL>) {
	
	chomp;
	# skip blank lines
	next if (/^(\s)*$/);
	# skip comments
	next if (/^(\s)*[%\#]/);
	# remove leading and trailing whitespace
	s/^\s*(\S.*\S)\s*$/$1/;
	
	($name, $cr, $arg) = read_lbl_line (@line);
	
	$component_cr{$name}  = $cr;
	$component_arg{$name} = $arg;
    }

    close (LBL);
}

sub read_lbl_line() {
    my @line = @_;
    my ($name, $cr, $arg);

    @line = split (/\s+/);
    $name = shift (@line);

    # strip repetitions (if any)
    $name =~ s/([^\*]*)\*.*/$1/;

    $cr  = shift (@line);
    $arg = shift (@line);

    $cr   = '' unless defined ($cr);
    $arg  = '' unless defined ($arg);
    
    print "read_lbl_line: name='$name' cr='$cr' arg='$arg'\n" if defined ($debug);
    return ($name, $cr, $arg);
}

sub write_header() {
    my $date = `date`;
    chomp ($date);

    open (OUT, ">$out") or
	die "MTT: cannot open $out for writing.\n";
    
    print OUT << "EOF";
## $out -*-octave-*-
## Generated by MTT on $date
    
function [comp_type, name, cr, arg, repetitions] = ${sys}_cmp(i)

EOF

    close (OUT);
}

sub write_body() {
    my ($name, $i);

    open (OUT, ">>$out") or
	die "MTT: cannot open $out for writing.\n";

    $i = 0;
    foreach $name (@component_name) {
	if (defined ($name)) {
	    $i++;
	    print OUT
		"if (i == $i)\n" .
		"\tcomp_type   = '$component_type{$name}';\n" .
		"\tname        = '$name'\n" .
		"\tcr          = '$component_cr{$name}';\n" .
		"\targ         = '$component_arg{$name}';\n" .
		"\trepetitions =  $component_rep{$name} ;\n" .
		"end\n";
	}
    }

    close (OUT);
}
