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
# Given a DIA diagram, the script has functions that perform the following
# MTT (model transformation tools) functions:
# 1. Write a _cmp.txt file containing component types:names
# 2. Write a _abg.m file containing an acausal bond graph suitable for input
#    to Octave.
# 3. Modify a diagram by changing causality as desired.
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

# The %bond_id_arrow_on_start hash is a boolean that indicates whether
# the power arrow (half head) is on the dia line start point.
#
# key=bond_id
# value=boolean arrow_on_start

# The %bond_id_effort_causality hash is a boolean that provides the
# effort arrow-oriented causality.
#
# key=bond_id
# value=arrow-oriented effort causality.

# The %bond_id_flow_causality hash is a boolean that provides the
# flow arrow-oriented causality.
#
# key=bond_id
# value=arrow-oriented flow causality.

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
    %bond_id_arrow_on_start, %bond_id_flow_causality, %bond_id_effort_causality,
    %bond_id_start_label,%bond_id_end_label);

# Parse user options:
my $diagram_name = '';
my $dia_input_file = '';
my $dia_output_file = '';
my $label_file = '';
my $component_list_file = '';
my $debug = 0;
my $create_component_list = 0;
my $create_abg = 0;
my $create_ibg = 1;
my $abg_file = '';
my $ibg_file = '';
my $change_flow_causality = '';
my $change_effort_causality = '';
GetOptions ('diagram_name=s' => \$diagram_name,
	    'dia_input_file=s' => \$dia_input_file,
	    'dia_output_file=s' => \$dia_output_file,
	    'label_file=s' => \$label_file,
	    'component_list_file=s' => \$component_list_file,
	    'debug' => \$debug,
	    'create_component_list' => \$create_component_list,
	    'create_abg' => \$create_abg,
	    'abg_file=s' => \$abg_file,
	    'ibg_file=s' => \$ibg_file,
	    'change_flow_causality=s' => \$change_flow_causality,
	    'change_effort_causality=s' => \$change_effort_causality,
	    );

die usage() if $diagram_name eq '';

# Use defaults if necessary:
$dia_input_file = $diagram_name . "_abg.dia" if ($dia_input_file eq '');
$dia_output_file = $diagram_name . "_cbg.dia" if ($dia_output_file eq '');
$label_file = $diagram_name . "_lbl.txt" if ($label_file eq '');
$abg_file = $diagram_name . "_abg.m" if ($abg_file eq '');
$ibg_file = $diagram_name . "_ibg.m" if ($ibg_file eq '');
$component_list_file = $diagram_name . "_cmp.txt" if ($component_list_file eq '');

# Start Parsing XML, and creating files:
my $dom = new XML::DOM::Parser;
my ($doc);

$doc = $dom->parsefile($dia_input_file);
$objects = get_objects_node($doc,"Bond Graph");

get_component_data($objects);
get_bond_data($objects);

create_component_list() if ($create_component_list);
if ($create_abg) {
    open (OUT,">$abg_file") ||
	die "Cannot open $abg_file for writing.\n";

    # Don't update the label file unless we are creating component list and abg simultaneously...
    if ($create_component_list) {
	print STDERR "WARNING: Label file may be stale.\n" 
	#system("abg2lbl_fig2txt -c $component_list_file $diagram_name") &&
	#system("abg2lbl_fig2txt -x $diagram_name") && die "abg2lbl_fig2txt failed.";
    }

    get_label_data();
    output_abg();
    output_bond_causality();
    parse_aliases();
    print OUT "endfunction\n";
}

if ($create_ibg) {
    open (OUT,">$ibg_file") ||
	die "Cannot open $ibg_file for writing.\n";
    # don't bother about creating cmp.m simultaneously
    # don't need getting label data
    output_ibg();
    
}   

if ($change_flow_causality ne '' || $change_effort_causality ne '') {
    open (DIA_OUT,">$dia_output_file") ||
	die "Cannot open $dia_output_file for writing.\n";
    print DIA_OUT $doc->toString;
    close DIA_OUT;
}

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
      $name = shift(@line);

      $component_label_data{$name} = [ ($i++,@line) ];
  }
    close(LBL);
}

sub parse_aliases {
    my ($name,@line,$alias);

    print OUT "# Aliases\n";
    print OUT "# A double underscore __ represents a comma\n";

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

      print OUT "$diagram_name.alias.$line[1] = \"$line[0]\";\n";
  }
    close(LBL);
    print OUT "## Port domain and units\n";
    print OUT "## Explicit variable declarations\n";
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

sub output_abg_header {
    my ($date);
    $date = `date`; chomp($date);

    print OUT <<"EOF";
function [${diagram_name}] =  ${diagram_name}_abg
# This function is the acausal bond graph representation of $diagram_name
# Generated by dia2abg.pl on $date
# The file is in Octave format

# Subsystems and Ports

EOF
}

sub output_ibg_header {
    my ($date);
    $date = `date`; chomp($date);

    print OUT <<"EOF";
## -*-octave-*- put Emacs into Octave mode

function [${diagram_name}] =  ${diagram_name}_ibg

  ## Intermediate bond graph representation of $diagram_name
  ## Generated by MTT on $date

  ## head refers to the harpoon end of a bond
  ## tail refers to the other end of a bond
  ## causality.? is the end at which ? is imposed


EOF
}

sub output_ibg_footer {
    print OUT <<"EOF";
endfunction
EOF
}

sub output_component {
    my ($NM,$type,$cr,$arg,$rep,$stat,$connections,$subsys_or_port) = @_;

    $_=$NM; remove_brackets(); $NM = $_;

    my $pretty_name = ($subsys_or_port eq "ports") ? "Port" : "Component";

	print OUT <<"EOF";
# $pretty_name $NM
  ${diagram_name}.${subsys_or_port}.${NM}.type = "$type";
  ${diagram_name}.${subsys_or_port}.${NM}.cr = "$cr";
  ${diagram_name}.${subsys_or_port}.${NM}.arg = "$arg";
  ${diagram_name}.${subsys_or_port}.${NM}.repetitions = $rep;
  ${diagram_name}.${subsys_or_port}.${NM}.status = $stat;
  ${diagram_name}.${subsys_or_port}.${NM}.connections = [$connections];
    
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
    my ($cr,$rep,$stat,$NM,$type,$arg,$bond_id,$start,$end,@clist,$connections,
	$strlength,$subsys_or_port);

    print_debug("WRITING OUTPUT TO STDIO...\n");
    $rep = "1";
    $stat = "-1";

    output_abg_header();
    
    foreach my $id (keys(%component_id_tag)) {
	($subsys_or_port,$_) = id_to_name($id);
	remove_brackets(); $NM = $_;

	$type = id_to_type($id);

	$cr = "" unless defined($cr = $component_label_data{$NM}[1]);
	$arg = "" unless defined($arg = $component_label_data{$NM}[2]);

	@clist = ();
	while (($bond_id,$start) = each(%bond_id_start_id)) {
	    push(@clist, ($bond_id_arrow_on_start{$bond_id} ? -1 : 1) *
		 $mtt_bond_id_index{$bond_id}) if $start eq $id;
	}
	while (($bond_id,$end) = each(%bond_id_end_id)) {
	    
	    push(@clist, ($bond_id_arrow_on_start{$bond_id} ? 1 : -1) *
		 $mtt_bond_id_index{$bond_id}) if $end eq $id;
	}
	$connections = join(" ",@clist);

	output_component($NM,$type,$cr,$arg,$rep,$stat,$connections,$subsys_or_port);
    }
    
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

    print OUT "# Ordered list of Port names\n";
    my $i=1;
    foreach my $id (@id_list) {
	my ($subsys_or_port,$name) = id_to_name($id);
	if ($subsys_or_port eq "ports") {
	    $_ = $name; remove_brackets(); $name = $_;
	    print OUT "  " . $diagram_name . ".portlist($i,:)" . ' = "'
		. $name . " " x ($strlength - length($name)) . '";' . "\n";
	    $i++;
	}
    }
    print OUT "\n";

    print OUT "# Ordered list of subsystem names\n";
    $i=1;
    foreach my $id (@id_list) {
	my ($subsys_or_port,$name) = id_to_name($id);
	if ($subsys_or_port eq "subsystems") {
	    print OUT "  " . $diagram_name . ".subsystemlist($i,:)" . ' = "'
		. $name . " " x ($strlength - length($name)) . '";' . "\n";
	    $i++;
	}
    }
    print OUT "\n";
}

sub output_ibg {
    my (%components,$key,$component,$type,$name,
	%reverse_mtt_bond_id_index,$mtt_bond_id,$dia_bond_id,
	@bonds,
	$bond_id,$start,$end,$id,
	$head,$head_component,$head_type,$head_name,
	$tail,$tail_component,$tail_type,$tail_name,
	$start_label,$end_label,
	$head_label,$tail_label,
	$effort_causality,$flow_causality,
	$anon_id);

    # copy component_id_tag and assign names to anonymous components
    %components = %component_id_tag;

    $anon_id = 0;
    while (($id, $component) = each(%components)) {
	$component =~ s/\#//g;
	($type, $name) = split (/:/, $component);
	if (! $name) {
	    $component = "${component}:mtt${component}_${anon_id}";
	}
	$anon_id++;
	$components{$id} = $component;
    }

    output_ibg_header();

    %reverse_mtt_bond_id_index = reverse (%mtt_bond_id_index);

#    while (($mtt_bond_id, $dia_bond_id) = each(%reverse_mtt_bond_id_index)) {
    @bonds = (sort keys (%reverse_mtt_bond_id_index));
    foreach $mtt_bond_id (@bonds) {
 
	$dia_bond_id = $reverse_mtt_bond_id_index{$mtt_bond_id};

	$start = $bond_id_start_id{$dia_bond_id};
	$end   = $bond_id_end_id  {$dia_bond_id};

	if ($bond_id_arrow_on_start{$dia_bond_id}) {
	    $head = $end;
	    $tail = $start;
	} else {
	    $head = $start;
	    $tail = $end;
	}

	$start_label = $bond_id_start_label{$dia_bond_id};
	$end_label   = $bond_id_end_label  {$dia_bond_id};

	# treat label as a comment if not enclosed by [ ]
	if ($start_label !~  /\[.*\]/) {
	    $start_label = "[]";
	}
	if ($end_label !~ /\[.*\]/) {
	    $end_label = "[]";
	}

	# ignore label if it is not enclosed by []
#	$start_label =~ s/[^[]*\[\([^]]*\)\]/[$1]/;
#	$end_label   =~ s/[^[]*\[\([^]]*\)\]/[$1]/;

	if ($bond_id_arrow_on_start{$dia_bond_id}) {
	    $head_label = $end_label;
	    $tail_label = $start_label;
	} else {
	    $head_label = $start_label;
	    $tail_label = $end_label;
	}

	$head_component = $components{$head};
	$tail_component = $components{$tail};

	$effort_causality = $bond_id_effort_causality{$dia_bond_id};
	$flow_causality   = $bond_id_flow_causality  {$dia_bond_id};

	for ($effort_causality) {
	    if (/-1/) { $effort_causality = "tail";}
	    if (/0/) { $effort_causality = "none";}
	    if (/1/) { $effort_causality = "head";}
	}
	for ($flow_causality) {
	    if (/-1/) { $flow_causality = "tail";}
	    if (/0/) { $flow_causality = "none";}
	    if (/1/) { $flow_causality = "head";}
	}
		       
	print OUT
	    "  ## bond $mtt_bond_id \n" .
	    "  ${diagram_name}.bonds.bond${mtt_bond_id_index{$dia_bond_id}}." .
	    "head.component = \"${head_component}\";\n" .
	    "  ${diagram_name}.bonds.bond${mtt_bond_id_index{$dia_bond_id}}." .
	    "tail.component = \"${tail_component}\";\n";

	print OUT
	    "  ${diagram_name}.bonds.bond${mtt_bond_id_index{$dia_bond_id}}." .
	    "head.ports = \"$head_label\";\n" .
	    "  ${diagram_name}.bonds.bond${mtt_bond_id_index{$dia_bond_id}}." .
	    "tail.ports = \"$tail_label\";\n";

	print OUT
	    "  ${diagram_name}.bonds.bond${mtt_bond_id_index{$dia_bond_id}}." .
	    "causality.effort = \"$effort_causality\";\n" .
	    "  ${diagram_name}.bonds.bond${mtt_bond_id_index{$dia_bond_id}}." .
	    "causality.flow = \"$flow_causality\";\n\n";
    }
    
    output_ibg_footer();
}

sub output_bond_causality {
    my ($mtt_bond_id,$dia_bond_id,$mtt_flow_causality,$mtt_effort_causality,
	%reverse_mtt_bond_id_index);

    print OUT "# Bonds\n";
    print OUT "  $diagram_name.bonds = [\n";

    %reverse_mtt_bond_id_index = reverse(%mtt_bond_id_index);

    while (($mtt_bond_id,$dia_bond_id) = each(%reverse_mtt_bond_id_index)) {
	$mtt_flow_causality = $bond_id_flow_causality{$dia_bond_id};
	$mtt_effort_causality = $bond_id_effort_causality{$dia_bond_id};

	print OUT "      $mtt_effort_causality $mtt_flow_causality\n";
    }
    print OUT "      ];\n\n";
}

sub get_component_data {
    my ( $objects_node )= @_;
    my($obj,$id,$attr,$comp,$strattr,$str_elem,$string);

    print_debug("READING COMPONENTS FROM $dia_input_file...\n");
    for my $i (0..$objects_node->getLength-1) {
      $obj = $objects_node->item($i);
      next if ($obj->getAttributeNode("type")->getValue ne "BondGraph - MTT port");
      
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
    my ($type, $attribute_node )= @_;
    my ($subnode);
    $subnode = get_first_subnode_by_nodename_attribute(0,$attribute_node,$type);

    return $subnode->getAttributeNode("val")->getValue;
}

# Dia stores its attributes in a strange way, not using typical xml attributes.
sub set_dia_attribute_value {
    my ($type, $attribute_node, $new_value )= @_;
    my ($subnode);
    $subnode = get_first_subnode_by_nodename_attribute(0,$attribute_node,$type);

    $subnode->setAttribute(val => $new_value);
#    return $subnode->getAttributeNode("val")->getValue;
}

sub get_dia_attribute_string {
    my ($attribute) = @_;
    my ($str_elem, $string);
    $str_elem = get_first_element_subnode($attribute);
    $string = get_first_text_subnode($str_elem)->getData;
    $string =~ s/\#//g;
    return $string;
}

sub get_arrow_info {
    my ( $object_node, $id, $id_index )= @_;
    my($attribute,$attributes);

    $attribute = get_first_subnode_by_nodename_attribute(1,$object_node, "dia:attribute", "name", "arrow_on_start");
    $bond_id_arrow_on_start{$id} = defined($attribute) ? get_dia_attribute_value("dia:boolean",$attribute) : 0;

    $attribute = get_first_subnode_by_nodename_attribute(1,$object_node, "dia:attribute", "name", "effort_causality");
    change_causality($id_index, $attribute, $change_effort_causality);
    $bond_id_effort_causality{$id} = defined($attribute) ? get_dia_attribute_value("dia:enum",$attribute)-1 : 1;

    $attribute = get_first_subnode_by_nodename_attribute(1,$object_node, "dia:attribute", "name", "flow_causality");
    change_causality($id_index, $attribute, $change_flow_causality);
    $bond_id_flow_causality{$id} = defined($attribute) ? get_dia_attribute_value("dia:enum",$attribute)-1 : 1;

    $attribute = get_first_subnode_by_nodename_attribute(1,$object_node, "dia:attribute", "name", "start_label");
    $bond_id_start_label{$id} = defined($attribute) ? get_dia_attribute_string($attribute) : "[]";

    $attribute = get_first_subnode_by_nodename_attribute(1,$object_node, "dia:attribute", "name", "end_label");
    $bond_id_end_label{$id} = defined($attribute) ? get_dia_attribute_string($attribute) : "[]";
}

sub change_causality() {
    my ($id_index, $attribute_node, $causality_change_string)=@_;
    my ($mtt_id, $arrow_oriented_causality);

    foreach my $id_causality (split(/;/,$causality_change_string)) {
	($mtt_id, $arrow_oriented_causality) = split(/:/,$id_causality);
	if ($mtt_id eq "all" || $id_index == $mtt_id) {
	    set_dia_attribute_value("dia:enum",$attribute_node,$arrow_oriented_causality + 1);
	}
    }
}

sub get_bond_data {
    my ( $objects_node )= @_;
    my ($id_index, $obj, $id, $connections, $connection, $to, $handle,
	$connections_att);

    print_debug("READING BONDS FROM $dia_input_file...\n");
    $id_index = 0;
    for my $i (0..$objects_node->getLength-1) {
      $obj = $objects_node->item($i);
      next if ($obj->getAttributeNode("type")->getValue ne "BondGraph - MTT bond");
      
      $id = $obj->getAttributeNode("id")->getValue;
      
      print_debug("Bond " . $id . ":\n");
      $mtt_bond_id_index{$id} = ++$id_index;
      
      get_arrow_info($obj,$id,$id_index);
      print_debug("Flow causality ($id):" . $bond_id_flow_causality{$id} . "\n");
      print_debug("Effort causality ($id):" . $bond_id_effort_causality{$id} . "\n");
      print_debug("Arrow on start ($id):" . $bond_id_arrow_on_start{$id} . "\n");

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

sub remove_brackets {
    s/^\[([^\]]*)\]$/$1/;
}

sub id_to_type {
    my ( $id )= @_;
    my($type,$name);

    $_ = $component_id_tag{$id};
    id_cleaner();
    ($type, $name) = split(/:/);

    return $type;
}

# If 1 LHS argument is used, it returns component name.  If 2 are used, it return
# "subsystem" or "port" depending on whether brackets are found in the name.
sub id_to_name {
    my ( $id )= @_;
    my($type,$name);

    $_ = $component_id_tag{$id};
    id_cleaner();
    ($type, $name) = split(/:/);

    if(!defined($name)) { $name = $id };

    return ( ($name =~ /^\[[^\]]*\]$/ ? "ports" : "subsystems" ),$name);
}

sub print_debug {
    print STDERR $_[0] if ($debug);
}

sub usage {
    return 
	"\n" .
	"Usage: dia2abg.pl --diagram_name <diagram_name> [options]\n" .
	"Options:\n" .
	"\t--dia_input_file <dia_input_file>\n" .
	"\t--label_file <label_file>\n" .
	"\t--component_list_file\n" .
	"\t--create_component_list\n" .
	"\t--create_abg\n" .
	"\t--debug\n" .
	"\t--abg_file <abg_file>\n" .
	"\t--change_flow_causality <bond causality spec>\n" .
	"\t--change_effort_causality <bond causality spec>\n" .
	"\n" .
	"\t\tBond causality spec:\n" .
	"\t\t 'bond:causality;bond:causality;...'\n" .
	"\t\tbond:\n" .
	"\t\t [mtt_bond_id|all]\n" .
	"\t\tcausality:\n" .
	"\t\t [-1|0|1]\n" .
	"\n" .
	"\t\tCausality is arrow-oriented-causality.\n" .
	"\t\tAny causality changes are made BEFORE further processing.\n" .
	"\n"
}

