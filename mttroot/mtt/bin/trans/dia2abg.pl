#!/usr/bin/perl -w

#----------------------------------------------------------------------------
# dia2abg.pl
# Copyright (C) 2002; David Hoover.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
# 
# The GNU General Public License should be found in the file license.txt.
# For more information about free software, visit http://www.fsf.org/
#----------------------------------------------------------------------------

#############################################################################
# Given a DIA diagram, and a mtt label file, this script writes an
# acausal bond graph in octave/matlab (.m) form, suitable for input to
# mtt, the model transformation tools.
#
# This script does not manage half-causal strokes.
#
# The dia arrow code is not quite adapted to bond graphs yet.  A
# half-head arrow exists to indicate power flow.  Nothing appropriate
# for causal strokes is implemented, however.  The closest
# approximations are:
#	'slashed cross' = arrow with half head and causal stroke.
#	'cross' = arrow with causal stroke.
#############################################################################

#----------------------------------------------------------------------------
# Dia uses a unique id for each object.
# get_component_data and get_bond_data read the xml file and collect
# important information about component and bond id's, component
# names, and bond connectivity.  These data structures are described here:

# The %component_id_tag hash provides component names and types:
#
# key=component_id
# value=component type:name

# 'start' ALWAYS refers to dia's interpretation of start.  This means,
# when you draw a line or an arrow, 'start' is the point where you
# initally press down the mouse button.  'end' is the point where you
# release the mouse button.  'start' and 'end' have nothing to do with
# a bond's direction.  A half arrow could be on a dia 'start' or 'end'
# point.

# The %bond_id_start_id and %bond_id_end_id hashes provides
# connectivity info for line start points and end points:
#
# key=bond_id
# value=component_id

# The %bond_id_start_arrow and %bond_id_end_arrow hashes provide arrow
# ending info.
#
# key=bond_id
# value=dia arrow number

# %mtt_bond_id_index provides a unique positive integer index for each
# Dia bond ID.  The index is written to the abg.m file for mtt.

# The %component_label_data hash is a hash of arrays.

# key=column 1 of label file
# value=list(order in label file, col1 of lbl file, col2 of lbl file, ...)
#----------------------------------------------------------------------------

#----------------------------MAIN PROGRAM------------------------------------
use strict;
use Getopt::Long;
use XML::DOM;

my (%component_id_tag, %bond_id_start_id, %bond_id_end_id,
    %component_label_data, $objects, %mtt_bond_id_index,
    %bond_id_start_arrow, %bond_id_end_arrow);

# Parse user options:
my $diagram_name = '';
my $dia_file = '';
my $label_file = '';
my $component_list_file = '';
my $debug = 0;
my $create_component_list = 0;
my $create_abg = 0;
GetOptions ('diagram_name=s' => \$diagram_name,
	    'dia_file=s' => \$dia_file,
	    'label_file=s' => \$label_file,
	    'component_list_file=s' => \$component_list_file,
	    'debug' => \$debug,
	    'create_component_list' => \$create_component_list,
	    'create_abg' => \$create_abg,
	    );

die usage() if $diagram_name eq '';

# Use defaults if necessary:
$dia_file = $diagram_name . "_abg.dia" if ($dia_file eq '');
$label_file = $diagram_name . "_lbl.txt" if ($label_file eq '');
$component_list_file = $diagram_name . "_cmp.txt" if ($component_list_file eq '');

# Start Parsing XML, and creating files:
my $dom = new XML::DOM::Parser;
my ($doc);

$doc = $dom->parsefile($dia_file);
$objects = get_objects_node($doc,"Bond Graph");

get_component_data($objects);
get_bond_data($objects);

create_component_list() if ($create_component_list);
if ($create_abg) {
    # Don't update the label file unless we are creating component list and abg simultaneously...
    if ($create_component_list) {
	#system("abg2lbl_fig2txt -c $component_list_file $diagram_name") &&
	system("abg2lbl_fig2txt -x $diagram_name") &&
	    die "abg2lbl_fig2txt failed.";
    }

    get_label_data();
    output_abg();
    output_bond_causality();
    parse_aliases();
    print "endfunction\n";
}


#print $doc->toString;

exit 0;


#----------------------------SUBROUTINES-------------------------------------
sub create_component_list {
    my ($name,@line,$i);

    print_debug("CREATING unique_raw_list...\n");
    open (RAW,">$component_list_file") ||
	die "Cannot open $component_list_file for writing.\n";

    foreach (values(%component_id_tag)) {
	id_cleaner();
	print RAW $_ . "\n" if (/:/);
    }
    close(RAW);
}


sub get_label_data {
    my ($name,@line,$i);

    print_debug("READING DATA FROM $label_file...\n");
    open (LBL,$label_file) || die "Cannot open label file: $label_file\n";

    $i=0;
    while (<LBL>) {
      chomp;
      # Get rid of commented lines:
      next if (/^(\s)*[%\#]/);
      # Get rid of empty or whitespace-only lines:
      next if (/^(\s)*$/);
      # Get rid of leading/trailing whitespace:
      s/^\s*(\S.+\S)\s*$/$1/;

      print_debug("label: $_ \n");      

      @line = split(/\s+/);
      die "Label file entries must have at least 3 columns!\n" unless
	  @line >= 3;
      $name = shift(@line);

      $component_label_data{$name} = [ ($i++,@line) ];
  }
    close(LBL);
}

sub parse_aliases {
    my ($name,@line,$alias);

    print "# Aliases\n";
    print "# A double underscore __ represents a comma\n";

    open (LBL,$label_file) || die "Cannot open label file: $label_file\n";

    while (<LBL>) {
      chomp;
      # Get rid of everything except ALIAS lines:
      next unless (s/^[%\#]ALIAS(.*)$/$1/);
      # Get rid of leading/trailing whitespace:
      s/^\s*(\S.+\S)\s*$/$1/;

      @line = split(/\s+/);
      die "Label file ALIAS entries must have 2 columns!\n" unless
	  @line == 2;

      print "$diagram_name.alias.$line[1] = \"$line[0]\";\n";
  }
    close(LBL);
    print "## Port domain and units\n";
    print "## Explicit variable declarations\n";
}

sub get_objects_node {
    my ( $doc_node, $layer_name )= @_;
    my ($root,$layer_node,$objects);

    $root = get_first_element_subnode($doc_node);
    die "could not find top-level element dia_diagram.\n"
	unless $root->getTagName eq 'dia:diagram';
    
    $layer_node = get_first_subnode_by_nodename_attribute(0,$root,"dia:layer","name",$layer_name);
    die "I found no dia:layer named $layer_name.  Are you sure the diagram has one?\n" unless
	$layer_node->getTagName eq 'dia:layer' &&
	$layer_node->getAttributeNode("name")->getValue eq $layer_name;
    
    $objects = $layer_node->getElementsByTagName('dia:object');

    return $objects;
}

# Return 1 if a half-stroke is on bond 'end', -1 on bond 'start', 0 otherwise.
sub get_sign_of_power {
    my ( $bond_id )= @_;
    my ($on_start,$on_end);

    $on_end = $bond_id_end_arrow{$bond_id}==6 || $bond_id_end_arrow{$bond_id}==7;
    $on_start = $bond_id_start_arrow{$bond_id}==6 || $bond_id_start_arrow{$bond_id}==7;

    die "On bond $bond_id, power flows in both directions!\n"
	if ($on_start && $on_end);

    return 1 if $on_end;
    return -1 if $on_start;

    die "No power direction on bond $bond_id\n";
    return 0;
}

# Return 1 if a causal-stroke is on bond 'end', -1 on bond 'start', 0 otherwise.
sub get_sign_of_causality {
    my ( $bond_id )= @_;

    my ($on_start,$on_end);

    $on_end = $bond_id_end_arrow{$bond_id}==7 || $bond_id_end_arrow{$bond_id}==21;
    $on_start = $bond_id_start_arrow{$bond_id}==7 || $bond_id_start_arrow{$bond_id}==21;

    die "On bond $bond_id, causality is defined in both directions!\n"
	if ($on_start && $on_end);

    return 1 if $on_end;
    return -1 if $on_start;
    return 0;
}

sub output_abg_header {
    my ($date);
    $date = `date`; chomp($date);

    print <<"EOF";
function [${diagram_name}] =  ${diagram_name}_abg
# This function is the acausal bond graph representation of $diagram_name
# Generated by dia2abg.pl on $date
# The file is in Octave format

# Subsystems and Ports

EOF
}

sub output_component {
    my ($NM,$type,$cr,$arg,$rep,$stat,$connections) = @_;

	print <<"EOF";
# Component $NM
  $diagram_name.subsystems.$NM.type = "$type";
  $diagram_name.subsystems.$NM.cr = "$cr";
  $diagram_name.subsystems.$NM.arg = "$arg";
  $diagram_name.subsystems.$NM.repetitions = $rep;
  $diagram_name.subsystems.$NM.status = $stat;
  $diagram_name.subsystems.$NM.connections = [$connections];
    
EOF
}

# This sort function allows components to be sorted in same order as
# label file, and alphabetically for components not in label file.
sub by_label_file {
    my ($a_index,$b_index);

    $a_index = $component_label_data{id_to_name($a)}[0];
    $b_index = $component_label_data{id_to_name($b)}[0];
    $a_index = 1e9 unless defined($a_index);
    $b_index = 1e9 unless defined($b_index);

    return ($a_index <=> $b_index) || ($a_index cmp $b_index);
}

sub output_abg {
    my ($cr,$rep,$stat,$NM,$type,$arg,$bond_id,$start,$end,@clist,$connections,$strlength);

    print_debug("WRITING OUTPUT TO STDIO...\n");
    $rep = "1";
    $stat = "-1";

    output_abg_header();
    
    foreach my $id (keys(%component_id_tag)) {
	$NM = id_to_name($id);
	$type = id_to_type($id);

	$cr = "" unless defined($cr = $component_label_data{$NM}[1]);
	$arg = "" unless defined($arg = $component_label_data{$NM}[2]);

	@clist = ();
	while (($bond_id,$start) = each(%bond_id_start_id)) {
	    push(@clist, -get_sign_of_power($bond_id) * $mtt_bond_id_index{$bond_id})
		if $start eq $id;
	}
	while (($bond_id,$end) = each(%bond_id_end_id)) {
	    
	    push(@clist, get_sign_of_power($bond_id) * $mtt_bond_id_index{$bond_id})
		if $end eq $id;

	}
	$connections = join(" ",@clist);

	output_component($NM,$type,$cr,$arg,$rep,$stat,$connections);
    }
    
    print "# Ordered list of subsystem names\n";
    # order component id's so that entries found in _lbl.txt file are
    # in _lbl file order, and other entries follow.
    my (@id_list);
    @id_list = keys(%component_id_tag);
    @id_list = sort by_label_file @id_list;

    # calculate string length of longest component name (for octave):
    $strlength=0;
    foreach my $compname (@id_list) {
	my $name = id_to_name($compname);
	$strlength = length($name) if length($name) > $strlength;
    };

    my $i=1;
    foreach my $id (@id_list) {
	my $name = id_to_name($id);
	print "  " . $diagram_name . ".subsystemlist($i,:)" . ' = "'
	    . $name . " " x ($strlength - length($name)) . '";' . "\n";
	$i++;
    }
    print "\n";
}

sub output_bond_causality {
    my ($mtt_bond_id,$dia_bond_id,$mtt_causality,%reverse_mtt_bond_id_index);

    print "# Bonds\n";
    print "  $diagram_name.bonds = [\n";

    %reverse_mtt_bond_id_index = reverse(%mtt_bond_id_index);

    while (($mtt_bond_id,$dia_bond_id) = each(%reverse_mtt_bond_id_index)) {

	#print "mtt: $mtt_bond_id\n";
	#print "dia: $dia_bond_id\n";

	$mtt_causality =
	    get_sign_of_power($dia_bond_id) * get_sign_of_causality($dia_bond_id);

	print "      $mtt_causality $mtt_causality\n";
    }
    print "      ];\n\n";
}

sub get_component_data {
    my ( $objects_node )= @_;
    my($obj,$id,$attr,$comp,$strattr,$str_elem,$string);

    print_debug("READING COMPONENTS FROM $dia_file...\n");
    for my $i (0..$objects_node->getLength-1) {
      $obj = $objects_node->item($i);
      next if ($obj->getAttributeNode("type")->getValue ne "Flowchart - Box");
      
      $id = $obj->getAttributeNode("id")->getValue;
      print_debug($id . "\n");
      
      $attr = get_first_subnode_by_nodename_attribute(0,$obj,"dia:attribute","name","text");
      $comp = get_first_subnode_by_nodename_attribute(0,$attr,"dia:composite","type","text");
      $strattr = get_first_subnode_by_nodename_attribute(0,$comp,"dia:attribute","name","string");
      $str_elem = get_first_element_subnode($strattr);
      $string = get_first_text_subnode($str_elem);
      $component_id_tag{$id} = $string->getData;
  }
    die "There are no components!\n" unless keys(%component_id_tag) > 0;
}

# Dia stores its attributes in a strange way, not using typical xml attributes.
sub get_dia_attribute_value {
    my ( $attribute_node )= @_;
    my ($subnode);
    $subnode = get_first_subnode_by_nodename_attribute(0,$attribute_node,"dia:enum");

    return $subnode->getAttributeNode("val")->getValue;
}

sub check_arrow_values {
    my ($arrow_number) = @_;
    
    die "Lines can have the following endings: none, half-head (power),
	cross (causality), slashed-cross (power+causality).\n" if
	    ($arrow_number != 0 &&
	     $arrow_number != 6 &&
	     $arrow_number != 7 &&
	     $arrow_number != 21);
}

sub get_arrow_info {
    my ( $object_node, $id )= @_;
    my($attribute,$attributes);
    
    $attribute = get_first_subnode_by_nodename_attribute(1,$object_node, "dia:attribute", "name", "end_arrow");
    $bond_id_end_arrow{$id} = defined($attribute) ? get_dia_attribute_value($attribute) : 0;

    $attribute = get_first_subnode_by_nodename_attribute(1,$object_node, "dia:attribute", "name", "start_arrow");
    $bond_id_start_arrow{$id} = defined($attribute) ? get_dia_attribute_value($attribute) : 0;

    check_arrow_values($bond_id_start_arrow{$id});
    check_arrow_values($bond_id_end_arrow{$id});
}

sub get_bond_data {
    my ( $objects_node )= @_;
    my ($id_index, $obj, $id, $connections, $connection, $to, $handle,
	$connections_att);

    print_debug("READING BONDS FROM $dia_file...\n");
    $id_index = 0;
    for my $i (0..$objects_node->getLength-1) {
      $obj = $objects_node->item($i);
      next if ($obj->getAttributeNode("type")->getValue ne "Standard - Line");
      
      $id = $obj->getAttributeNode("id")->getValue;
      
      print_debug("Bond " . $id . ":\n");
      $mtt_bond_id_index{$id} = ++$id_index;
      
      get_arrow_info($obj,$id);
      print_debug("Start arrow:" . $bond_id_start_arrow{$id} . "\n");
      print_debug("End arrow:" . $bond_id_end_arrow{$id} . "\n");

      # get connection info
      $connections_att = $obj->getElementsByTagName('dia:connections');
      die "A bond without connections exists!\n"
	  unless $connections_att->getLength > 0;

      $connections = $connections_att->item(0)->getElementsByTagName('dia:connection');
      die "Bond $id does not have two connections!\n" unless
	  $connections->getLength == 2;

      for my $j (0..$connections->getLength-1) {
	  
	  $connection = $connections->item($j);
	  $handle = $connection->getAttributeNode("handle")->getValue;
	  $to = $connection->getAttributeNode("to")->getValue;
	  
	  print_debug("handle " . $handle . "\n");
	  print_debug("to " . $to . "\n");
	  
	  if ($handle eq "0") {
	      $bond_id_start_id{$id} = $to;
	  } else {
	      $bond_id_end_id{$id} = $to;
	  }
      }
  }
    die "There are no bonds!\n" unless keys(%mtt_bond_id_index) > 0;
}

# if($relax), then this routine will return 'undef' instead of dying, if valid node not found.
sub get_first_subnode_by_nodename_attribute {
    my ( $relax, $node, $nodename, $key, $value)= @_;
    my ($subnodes,$subnode);

    $subnodes = $node->getChildNodes;
    
    for my $k (0..$subnodes->getLength-1) {
      next if ($subnodes->item($k)->getNodeType != ELEMENT_NODE);
      next if ($subnodes->item($k)->getNodeName ne $nodename);
      $subnode = $subnodes->item($k);
      next if defined($value) && defined($key) &&
	  ($subnode->getAttributeNode($key)->getValue ne $value);
      
      return $subnode;
  }
    if($relax) {
	return undef;
    } else {
	die "I found no subnode of " . $node->getNodeName .
	    " named $nodename with key/value pair: ($key,$value).\n" unless
	    $subnode->getTagName eq $nodename &&
	    $subnode->getAttributeNode($key)->getValue eq $value;
    }
}

sub get_first_element_subnode {
    my ( $node )= @_;
    my ($subnodes,$subnode);

    $subnodes = $node->getChildNodes;
    
    for my $k (0..$subnodes->getLength-1) {
      next if ($subnodes->item($k)->getNodeType != ELEMENT_NODE);
      $subnode = $subnodes->item($k);

      return $subnode;
  }
    die " I found no element subnode of " . $node->getNodeName . "." unless
	$subnode->getNodeType == ELEMENT_NODE;
}

sub get_first_text_subnode {
    my ( $node )= @_;
    my ($subnodes,$subnode);

    $subnodes = $node->getChildNodes;
    
    for my $k (0..$subnodes->getLength-1) {
      next if ($subnodes->item($k)->getNodeType != TEXT_NODE);
      $subnode = $subnodes->item($k);

      return $subnode;
  }
    die " I found no text subnode of " . $node->getNodeName . "." unless
	$subnode->getNodeType == TEXT_NODE;
}

sub id_cleaner {
    s/#?([^#]*)#?/$1/;
}

sub id_to_type {
    my ( $id )= @_;
    my($type,$name);

    $_ = $component_id_tag{$id};
    id_cleaner();
    ($type, $name) = split(/:/);

    return $type;
}

sub id_to_name {
    my ( $id )= @_;
    my($type,$name);

    $_ = $component_id_tag{$id};
    id_cleaner();
    ($type, $name) = split(/:/);

    if(!defined($name)) { $name = $id };

    return $name;
}

sub print_debug {
    print STDERR $_[0] if ($debug);
}

sub usage {
    print STDERR "\n";
    print STDERR "Usage: dia2abg.pl --diagram_name <diagram_name> [options]\n";
    print STDERR "Options:\n";
    print STDERR "\t--dia_file <dia_file>\n";
    print STDERR "\t--label_file <label_file>\n";
    print STDERR "\t--component_list_file\n";
    print STDERR "\t--create_component_list\n";
    print STDERR "\t--create_abg\n";
    print STDERR "\t--debug\n";
    print STDERR "\n";
}