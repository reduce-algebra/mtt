###################################### 
##### Model Transformation Tools #####
######################################

# gawk script: rbg_fig2m.awk
# Raw  bond-graph conversion from fig to matlab
# P.J.Gawthrop June 1996
# Copyright (c) P.J.Gawthrop, 1996.

###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
## Revision 1.7  1996/08/05 18:44:56  peter
## Now writes out a _cbg file without ----- symbol.
##
## Revision 1.6  1996/08/05 12:17:37  peter
## n_ports now appear in the _abg file instead.
##
## Revision 1.5  1996/08/05 12:01:28  peter
## The _cmp function now returns the number of ports.
##
## Revision 1.4  1996/08/05 10:14:46  peter
## Made ports appear, in order, at top of component lists
##
## Revision 1.3  1996/08/04 20:32:28  peter
## Stopped complaint about missing lbl entry for port components
##
## Revision 1.2  1996/08/04 20:05:25  peter
## Included port components - eg SS:[1]
##
## Revision 1.1  1996/08/04 20:01:58  peter
## Initial revision
##
###############################################################


##############################################################
# This (g)awk script reads a fig file in fig 3.1 format.
# It interprets the picture as: bonds, arrows and components
# as follows:
#
# Bonds are firm (not dashed etc) polylines with 2 line segments - 
#  fig represents this by  a firstline record where
#    field 1 = 2 (always 2)
#    field 2 = 1 (polyline)
#    field 3 = 0 (style is a firm line)
#    field 14 = 0 (no forward arrow)
#    field 15 = 0 (backward arrow) 
#  a data field starting with a tab followed by 3 (x,y) cordinates
#
# Arrows are polylines with 1 line segment and an arrow 
#  fig represents this by  a firstline record where
#    field 1 = 2 (always 2)
#    field 2 = 1 (polyline)
#    field 3 = 0 (style is a firm line)
#    field 14 = 1 for a forward arrow  
#    field 15 = 1 for a backward arrow 
#  an additional data files
#  a data field starting with a tab followed by 2(x,y) cordinates
#
#
# Strokes are polylines with 1 line segment and and no arrow 
#  fig represents this by  a firstline record where
#    field 1 = 2 (always 2)
#    field 2 = 1 (polyline)
#    field 3 = 0 (style is a firm line)
#    field 14 = 0 (no forward arrow)
#    field 15 = 0 (backward arrow) 
#  a data field starting with a tab followed by 2(x,y) cordinates
#
# Components appear in two files -- the fig file and the lbl file
# these two files are concatenated with the lbl file first
#  	The lbl file represents components by 3 fields
#		field  1 is the name
#		field  2 is the CR name
#		field  3 is the CR arguments
#  	The fig file represents components by 14 fields
#             field 1 = 4
#		fields 12 and 13 are the coordinates
#		field 14 is the type:name string terminated by \001
# To prevent text being confused with components, components consist
# of alphanumeric characters and : and _ only.
# The lbl file is used to sort the components.
##############################################################

function exact_match(name1, name2) {
  return ((match(name1,name2)>0)&&(length(name1)==length(name2)))
    }

function process_lbl() {
# This puts the components in the lable file at the top of the list
# and saves up the corresponding CR and arguments
# note that there may be more than one component per label
  if ((match($1,"%")==0)&&(NF>0))
    { 
      i_label++;
      name = $1;
      CR   = $2;
      args = $3;
      label[i_label,1] = name; 
      label[i_label,2] = CR;
      label[i_label,3] = args
	}
}

function fig_info() {
# Grabs the fig-file information for a component
  return(sprintf("%s %s %s %s %s %s %s %s %s %s %s ", \
		 $1, $2, $3, $4, $5, $6, $7, \
		 $8, $9, $10, $11))
	 }

function process_text() {
# The text string is field 14 onwards
  str = $14; 
  for (i=15; i<=NF; i++) {
    str = sprintf("%s %s", str, $i)
      }
# It is terminated by /001 - so delete this termination
  str = substr(str,1,length(str)-4);

# A component string contain only alphanumeric  _ and :
  isa_plain_component = match(str, component_regexp)==0;

# A port is an integer within []
  isa_port = exact_match(str, port_regexp)>0;

# A port component is SS followed by : followed by a port string
  isa_port_component = 0;
  if (match(str, delimiter)) {
    split(str,a,delimiter);
    isa_port_component = (exact_match(a[1], "SS"))&&
      (match(a[2], port_regexp)>0)
      }
    
# A component is a plain or a port component
  isa_component = isa_plain_component||isa_port_component;

# Coordinates in fields 12 & 13
  x_coord = $12;
  y_coord = $13;

# Do the port components
  if (isa_port_component) {
    i_port_component++;
    # Port number is the bit between the []
    port_number  = substr(a[2],2,length(a[2])-2);
    x_port[port_number] = x_coord;
    y_port[port_number] = y_coord;
    info_port[port_number] = fig_info();
  }

# Do the plain components
  if (isa_plain_component) {
    i_text++;

    named_component = (match(str,delimiter) > 0);
    if (named_component) {
      split(str,a,delimiter);
      type = a[1];
      name = a[2];

# Check  if name is in label file and if used already
      found = 0; name_used = 0;
      for (i=1; i<=i_label; i++) {
	lname = label[i,1];
	if ( exact_match(name,lname) ) {
	  found = 1;
	  if (name in used) {
	    name_used = 1;
	    CR = label[i,2];
	    args = label[i,3];
	  }
	  else {
	    used[name] = 1
	      }
	  break
	    }
      }

	if (!found) {
	  if (isa_plain_component) {
	    printf(warning_f, name)
	  }
	  i_label++;
	  CR = default_cr;
	  args = "";
	  label[i_label,1] = name; 
	  label[i_label,2] = CR;
	  label[i_label,3] = args
	    }

# Give it a new entry if already used
      if (name_used) {
	i_label++;
	i_name++;
	name = sprintf("%1.0f", i_name);
	label[i_label,1] = name; 
	label[i_label,2] = CR;
	label[i_label,3] = args
	  }
    }

# Unnamed component
    if (named_component==0) {
      i_name++;
      name = sprintf("%1.0f", i_name);
      type = str;
      i_label++;
      label[i_label,1] = name;
      label[i_label,2] = default_cr;
      label[i_label,3] = default_args
	}

# Save in associative arrays by name	
    comp_type[name] = type;
    x[name] = x_coord;
    y[name] = y_coord;
    info[name] =  fig_info();
  }

  if (isa_port) {
    i_port++;
    port_index = substr(str,2,length(str)-2);
    ports[i_port] = sprintf("%s %s %s", x_coord, y_coord, port_index);
  }
}

function process_bond() {

  arg_count++;
  if ( (arg_count-arrow)==1 ) 
    {

#Save up bond coords
      if (NF == (2*bond_coords+1) ) {
	i_bond++;
	bonds[i_bond] = sprintf("%s %s %s %s %s %s", \
				$2, $3, $4, $5, $6, $7);
      }
      
#Save up arrow coords
      if ( (arrow)&&(NF==(2*arrow_coords+1)) ) {
	i_arrow++;
	arrows[i_arrow] = sprintf("%s %s %s %s",  $2, $3, $4, $5);
      }
      
#Save up stroke coords
      if ( (!arrow)&&(NF==(2*stroke_coords+1)) ) {
	i_stroke++;
	strokes[i_stroke] = sprintf("%s %s %s %s",  $2, $3, $4, $5);
      }
    }
}

function write_fig() {
# Create _fig.fig file from _abg file - not components
  if ( (isa_fig_file)&&((object!=text)||(isa_component==0))) {
    if (exact_match($1,data_symbol)) {
      field_1 = out_data_symbol
	}
    else {
      field_1 = $1
	}

    printf field_1   >> fig_file
      for (i=2; i<=NF; i++)
	printf(" %s", $i)  >> fig_file;
    printf("\n") >> fig_file
      }
}

function process_fig() {
# Test for the fig format first line and data line
  data_line = (match($1,data_symbol)>0);
  first_line = (data_line==0)&&(NF>min_line_length);

#Process firstline
  if (first_line) {
    object = $1;
    sub_type = $2;
    style = $3;
    f_arrow = ($14==1)&&(object=polyline);
    b_arrow = ($15==1)&&(object=polyline);
    arrow = f_arrow||b_arrow;
    arg_count = 0;
  }

#Process text
  if (object==text) {
    process_text()
      }

# Process bond
  if ( \
(data_line)&& \
       (object==polyline)&& \
       (sub_type==sub_polyline)&& \
       (style==firm_style) \
       ) {
    process_bond()
      }   

  write_fig()

    }

BEGIN {
  sys_name = ARGV[1];
  delete ARGV[1];
  b_file = sprintf("%s_rbg.m", sys_name);
  c_file = sprintf("%s_cmp.m", sys_name);
  fig_file = sprintf("%s_fig.fig", sys_name);
  warning_f = "WARNING %s \t in fig file but not lbl file  - using\n";
  warning_l = "WARNING %s \t in lbl file but not fig file  - ignoring\n";
  warning_p = "WARNING system ports are not consecutively numbered\n";

  data_symbol = "----";
  out_data_symbol = "\t";
  default_cr = "";
  default_args = "";
  delimiter = ":";
  q = "\047";
  terminator = "\\001";
  component_regexp = "[^0-9a-zA-Z_:]";
  port_regexp = "\[[0-9]*\]";
    
  isa_fig_file = 0;
  min_line_length = 10;
  object = 0;
  polyline = 2;
  sub_polyline=1; 
  firm_style = 0;
  text = 4;
  bond_coords = 3;
  stroke_coords = 2;
  arrow_coords = 2;

  i_bond = 0;
  i_port = 0;
  i_stroke = 0;
  i_arrow = 0;
  i_label = 0;
  i_text = 0;
  i_name = 0;
  i_port_component = 0;

}
{
# Start of .fig file?
  if ( (NF>0) && (match("#FIG", $1) > 0) ) {
    isa_fig_file=1;
  }

  if (isa_fig_file==0) {
    process_lbl()    
      }
  else {
    process_fig()
      }
}

END {
#Print out the matlab functions
  printf("function [rbonds, rstrokes,rcomponents,rports,n_ports] = %s_rbg\n", sys_name) > b_file;
  printf("%% [rbonds,rstrokes,rcomponents,rports,n_ports] = %s_rbg\n", sys_name) > b_file;
  printf("%% Generated by MTT\n\n") > b_file;

  printf("function [comp_type, name, cr, arg] = %s_cmp(i)\n",\
		 sys_name) > c_file;
  printf("%% [comp_type, name, cr, arg] = %s_cmp\n", sys_name) > c_file;
  printf("%% Generated by MTT\n\n") > c_file;

  printf("rbonds = [\n") >> b_file;
  for (i = 1; i <= i_bond; i++)
    print  bonds[i] >> b_file;
  for (i = 1; i <= i_arrow; i++)
    print  arrows[i], "-1 -1" >> b_file;
  printf("];\n") >> b_file;
  
  printf("rstrokes = [\n") >> b_file;
  for (i = 1; i <= i_stroke; i++)
    print  strokes[i] >> b_file;
  printf("];\n") >> b_file;

  printf("rcomponents = [") >> b_file;
  j = 0;


# Do the port components, in order, first
  for (i = 1; i <= i_port_component; i++) {
    port_type = "SS";
    name = sprintf("[%1.0f]", i);
    cr   = i;
    arg  = "";

    if (length(x_port[i])==0)
      printf(warning_p);
    else {
      j++;
      print x_port[i], y_port[i], info_port[i] >> b_file;
      printf("if i==%1.0f\n", j) 	>> c_file;
      printf("\tcomp_type = %s%s%s;\n", q, port_type, q) >> c_file;
      printf("\tname = %s%s%s;\n", q, name, q) >> c_file;
      printf("\tcr = %s%s%s;\n", q, cr, q) >> c_file;
      printf("\targ = %s%s%s;\n", q, arg, q) >> c_file;
      print "end" >> c_file
	}
    
  }

# Now do the ordinary components (in no particular order)
  for (i = 1; i <= i_label; i++) {
    name = label[i,1];
    cr   = label[i,2];
    arg  = label[i,3];
    
    if (length(x[name])==0)
      printf(warning_l, name);
    else {
      j++;
      print x[name], y[name], info[name] >> b_file;
      printf("if i==%1.0f\n", j) 	>> c_file;
      printf("\tcomp_type = %s%s%s;\n", q, comp_type[name], q) >> c_file;
      printf("\tname = %s%s%s;\n", q, name, q) >> c_file;
      printf("\tcr = %s%s%s;\n", q, cr, q) >> c_file;
      printf("\targ = %s%s%s;\n", q, arg, q) >> c_file;
      print "end" >> c_file
	}
  }
  printf("];\n") >> b_file;

  printf("rports = [\n") >> b_file;
  for (i = 1; i <= i_port; i++)
    print  ports[i] >> b_file;
  printf("];\n\n") >> b_file;
  printf("n_ports = %1.0f;\n", i_port_component) >> b_file;

  

}


