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
sub sort_components;
sub write_header;
sub write_body;
sub write_component;

my $debug = 0;

## fields to write to cmp.m
my (@component_name,
    %component_type,    
    %component_cr,
    %component_arg,
    %component_rep);

my (@component_name_lbl_index,
    %sorted_component_list,
    %component_class,
    %anonymous_component_type_index);

## files to read/write
my ($cmp, $lbl, $out);

my $sys = '';

GetOptions ('sys=s' => \$sys);

die usage() if ($sys eq '');

$cmp = "${sys}_cmp.txt";
$lbl = "${sys}_lbl.txt";
$out = "${sys}_cmp.m";

read_cmp_file();
read_lbl_file();
sort_components();
write_header();
write_body();


sub usage() {
    return "Usage: lbl2cmp_txt2m --sys=<sys>\n";
}

sub read_cmp_file() {
    my ($line, $name, $type, $class, $rep, $i);

    open (CMP, $cmp) or die ("MTT: lbl2cmp_txt2m, cannot open $cmp");

    $i = 0;
    while (<CMP>) {
	
	chomp;
	# skip blank lines
	next if (/^(\s)*$/);
	# skip comments
	next if (/^(\s)*[%\#]/);
	# remove leading and trailing whitespace
	s/^\s*(\S.*\S)\s*$/$1/;
	
	$line = $_;
	print "read_cmp_file: line='${line}'\n" if ($debug);

	# cmp provides type, name and repetition information
	# class is inferred from type and name
	# (cr and args are placeholders)

	($type, $name, $rep) = read_cmp_line($line);
	$name = name_anonymous_component($type) if ($name eq '');	
	$class = port_or_component_or_junction ($type, $name);

	$component_name  [++$i]   = $name;
	$component_type  {$name}  = $type;
	$component_rep   {$name}  = $rep;
	$component_cr    {$name}  = '';
	$component_arg   {$name}  = '';
	$component_class {$name}  = $class;
    }
    close (CMP);
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
    
    print "read_cmp_line: type='$type', name='$name', rep='$rep'\n" if ($debug);
    return ($type, $name, $rep);
}

sub name_anonymous_component() {
    my $type = @_;
    my ($name, $num);
    if (defined ($anonymous_component_type_index{$type})) {
	$num = ++$anonymous_component_type_index{$type};
	$name = "mtt${type}_${num}";
    } else {
	$anonymous_component_type_index{$type} = 1;
	$name = "mtt${type}";
    }
    print "name_anonymous_component: type='${type}', name='${name}'\n" if ($debug);
    return ($name);
}

sub port_or_component_or_junction() {

    # ports are internal SS components (SS:[...])
    # junctions are '0' and '1' types
    # everything else is a component, including external SS types.

    my ($type, $name) = @_;
    my $retval;
    if ($type eq "SS") {
	$_ = $name;
	if (/\[.+\]/) {
	    $retval = "port";
	} else {
	    $retval = "component";
	}
    } elsif ($type eq "0") {
	$retval = "0junction";
    } elsif ($type eq "1") {
	$retval = "1junction";
    } else {
	$retval = "component";
    }
    print "port_or_component_or_junction: type='$type', name='$name' class='$retval'\n" if ($debug);
    return ($retval);
}

sub read_lbl_file() {
    my (@line, $name, $type, $cr, $arg, $i);
    
    open (LBL, $lbl) or die ("MTT: lbl2cmp_txt2m, cannot open $lbl");
    
    $i = 0;
    while (<LBL>) {
	
	chomp;
	# skip blank lines
	next if (/^(\s)*$/);
	# skip comments
	next if (/^(\s)*[%\#]/);
	# remove leading and trailing whitespace
	s/^\s*(\S.*\S)\s*$/$1/;
	
	# lbl provides name, cr and arg information

	($name, $cr, $arg) = read_lbl_line (@line);
	
	$component_cr{$name}  = $cr;
	$component_arg{$name} = $arg;

	$component_name_lbl_index[++$i] = $name;
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
    
    print "read_lbl_line: name='$name' cr='$cr' arg='$arg'\n" if ($debug);
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

sub sort_components ()
{
    # sorts components into the order in which they are found in the label
    # file within the classes: ports, components then junctions.

    my ($name, $class, $i, $j, $target);

    $i = 0;
    foreach $target ("port", "component", "1junction", "0junction") {
	# get targets in lbl
	for ($j = 1; $j < scalar @component_name_lbl_index; $j++) {
	    $name  = $component_name_lbl_index[$j];
	    $class = $component_class{$name};
	    if ($class eq $target) {
		$sorted_component_list{$name} = ++$i;
		print "sorted: '$name' '$i'\n" if ($debug); 
	    }
	}
	# get targets not in lbl
	for ($j = 1; $j < scalar @component_name; $j++) {
	    $name  = $component_name[$j];
	    $class = $component_class{$name};
	    if ($class eq $target) {
		if (! defined ($sorted_component_list{$name})) {
		    $sorted_component_list{$name} = ++$i;
		    print "sorted: '$name' '$i'\n" if ($debug); 
		}
	    }
	}
    }
}
    
sub write_body() {
    my (%reverse_sorted_component_list, $name);
    
    %reverse_sorted_component_list = reverse (%sorted_component_list);
    for (my $key = 1; $key < scalar @component_name; $key++) {
	$name = $reverse_sorted_component_list{$key};
	write_component ($name);
    }
}

sub write_component() {
    my ($name) = @_;

    my $i = $sorted_component_list{$name};

    open (OUT, ">>$out") or
	die "MTT: cannot open $out for writing.\n";

    print OUT
	"if (i == $i)\n" .
	"\tcomp_type   = '$component_type{$name}';\n" .
	"\tname        = '$name'\n" .
	"\tcr          = '$component_cr{$name}';\n" .
	"\targ         = '$component_arg{$name}';\n" .
	"\trepetitions =  $component_rep{$name} ;\n" .
	"end\n";

    close (OUT);
}
