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
## Revision 1.43  2002/05/22 10:33:18  gawthrop
## Nameless components are now named according to type - replaces old
## mtt1 etc style.
##
## Revision 1.42  2002/03/26 12:05:27  geraint
## Escaped characters to eliminate awk warnings.
##
## Revision 1.41  2001/06/13 10:41:06  gawthrop
## Further changes towards aouto creation of lbl files.
## Prettified lbl files
##
## Revision 1.40  2001/06/11 19:43:50  gawthrop
## MTT is now much more sophisticated in generating lbl files
## Labels can contain maths
## Repetative components are now broken
##
## Revision 1.39  2001/05/09 08:50:02  gawthrop
## Uses _art.fig to transmit the art work to the cbg.fig rep.
##
## Revision 1.38  2001/03/23 14:57:31  gawthrop
## Now puts space after header fields + writes _port.fig
##
## Revision 1.37  2000/09/14 08:43:32  peterg
## Add additional directional informatiuon to rbonds:
## 	cols 7-8 Arrow end directional bond
## 	cols 9-10 Arrow end directional bond
##
## Revision 1.36  1999/11/19 04:00:26  peterg
## Changed a comment to be more accurate.
##
## Revision 1.35  1999/07/25 22:19:45  peterg
## Fixed bug with false objects when compound objects present.
## -- Reset object to 0 after processing text.
##
## Revision 1.34  1999/02/17 06:23:49  peterg
## Bugs arising from Fig 3.2 fixed
##
## -- depth now zero modulo 10 (3.2 defaults to depth 100!!)
## -- horrible bug using = in place of == fixed.
##
## Revision 1.33  1998/08/10 15:51:06  peterg
## Comments may now be prefaced by # as well as %
##
## Revision 1.32  1998/07/27 20:30:03  peterg
## *** empty log message ***
##
## Revision 1.31  1998/04/16 13:18:13  peterg
## Now ignores spurious ports (in lbl but not Figure \ref{) but gives
## warning
##
## Revision 1.30  1998/04/12 15:01:17  peterg
## Converted to uniform port notation - always use []
##
## Revision 1.29  1998/04/12 12:35:32  peterg
## Named and unnamed SS handled in a uniform manner - in particular, the
## attributes are passed through
## wrote_component function used.
##
## Revision 1.28  1998/04/06 08:41:48  peterg
## Fixed bug due to adding (and then removing) 0 and 1 as port types
##
## Revision 1.27  1998/04/04 10:54:58  peterg
## Remove a debugging print statement
##
## Revision 1.26  1998/04/04 07:29:26  peterg
## SS now only port component
##
## Revision 1.25  1998/04/03 15:07:20  peterg
## Now correctly write 0/1 port names
##
## Revision 1.24  1998/04/03 14:02:50  peterg
## Added 0 and 1 to list of possible ports
##
## Revision 1.23  1998/02/01 18:37:41  peterg
## Don't print irritating warnings about ports listed in lbl files.
##
# Revision 1.22  1997/08/09  14:42:39  peterg
# Added underscore to port regexp
#
## Revision 1.21  1997/08/04 12:49:17  peterg
## Modified to use named (as opposed to numbered) ports.
## Generates a list of component ports in the .rbg file.
## As octave handles string vectors properly, the .cmp file format is not
## really necessary - but I've let it be for the moment.
##
## Revision 1.20  1997/03/19 12:02:01  peterg
## Now writes an error message if a lable is used twice in the fig file.
##
# Revision 1.19  1997/03/19  09:49:39  peterg
# Ports now written in cmp file.
#
# Revision 1.18  1997/03/19  09:42:08  peterg
# Now writes out the following additional fig  files:
# _head.fig	The fig header
# _bnd.fig	The bonds actually used
# _cmp.fig	The components actually used.
#
# Revision 1.17  1997/01/02  11:21:17  peterg
# Now assumes all components bonds etc at depth zero in fig file.
# Ie anything at depth>0 is ignored.
# Thanks to Donald for suggesting this.
#
## Revision 1.16  1996/12/30 20:00:29  peterg
## Fixed bent-bond bug.
## NB unfixed problems:
## 1. xfig writes multi line fields if more than about 5 segments.
## 2. rbg2abg takes a multi-segment bond as a straignt line between the
## end points - so computation of stroke and arrow directions may be
## iffy.
##
## Revision 1.15  1996/12/30 19:23:35  peterg
##  Allows for bent bonds - ie bonds with more than 2 line segments.
##
## Revision 1.14  1996/12/21 19:47:53  peterg
## Changed \* to \\*
##
## Revision 1.13  1996/12/21 19:47:23  peterg
## Put back under VC
##
# Revision 1.12  1996/08/24  16:30:12  peter
# Fixed error in nonport_regexp.
#
## Revision 1.11  1996/08/19 10:48:57  peter
## Added `-' to the component regexp.
##
## Revision 1.10  1996/08/19 09:03:13  peter
## Parses repetative components: ie suffixed by *n.
##
## Revision 1.9  1996/08/09 08:23:11  peter
## Fixed bug: ports not recognised.
##
## Revision 1.8  1996/08/05 20:12:43  peter
## Now writes a _fig.fig file.
##
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
# Bonds are firm (not dashed etc) polylines with n line segments - 
#  fig represents this by  a firstline record where
#    field 1 = 2 (always 2)
#    field 2 = 1 (polyline)
#    field 3 = 0 (style is a firm line)
#    field 7 = 0 (depth is zero [top level])
#    field 14 = 0 (no forward arrow)
#    field 15 = 0 (backward arrow) 
#    field 16 = Number of point in line (points=segments+1)
#  a data field starting with a tab followed by  points (x,y) cordinates
#
#
# Strokes are polylines with 1 line segment and and no arrow 
#  fig represents this by  a firstline record where
#    field 1 = 2 (always 2)
#    field 2 = 1 (polyline)
#    field 3 = 0 (style is a firm line)
#    field 14 = 0 (no forward arrow)
#    field 15 = 0 (backward arrow) 
#    field 16 = Number of point in line =2
#  a data field starting with a tab followed by 2 (x,y) cordinates
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

function modulo10(x) {
  return x-int(x/10)*10
    }

function exact_match(name1, name2) {
  return ((match(name1,name2)>0)&&(length(name1)==length(name2)))
    }

function write_component(i) {
    name = label[i,1];
    cr   = label[i,2];
    arg  = label[i,3];
    if (length(x[name])==0) {
        # print error - its in lbl but not fig file
        printf(warning_l, name);
    }
    else {
      component_index++;
      print x[name], y[name], info[name] >> b_file;
      printf("if i==%1.0f\n", component_index) 	>> c_file;
      printf("\tcomp_type = %s%s%s;\n", q, comp_type[name], q) >> c_file;
      printf("\tname = %s%s%s;\n", q, name, q) >> c_file;
      printf("\tcr = %s%s%s;\n", q, cr, q) >> c_file;
      printf("\targ = %s%s%s;\n", q, arg, q) >> c_file;
      printf("\trepetitions = %s;\n",  reps[name]) >> c_file;
      print "end" >> c_file
	}
  }

function process_lbl() {
# This puts the components in the lable file at the top of the list
# and saves up the corresponding CR and arguments
# note that there may be more than one component per label
  if ((match($1,comment_regexp)==0)&&(NF>0))
    { 
      i_label++;
      name = $1;
      CR   = $2;
      args = $3;

      label[i_label,1] = name; 
      label[i_label,2] = CR;
      label[i_label,3] = args;
	}
}

function fig_info() {
# Grabs the fig-file information for a component
  return(sprintf("%s %s %s %s %s %s %s %s %s %s %s ", \
		 $1, $2, $3, $4, $5, $6, $7, \
		 $8, $9, $10, $11))
	 }

function type_name(type) {
#    if (type==1)
#      return "one"
#    else {
#      if (type==0)
#        return "zero"
#      else
#        return type
#    }
    return sprintf("mtt%s", type);
}

function process_text() {
# The text string is field 14 onwards
  str = $14; 
  for (i=15; i<=NF; i++) {
    str = sprintf("%s %s", str, $i)
      }

# The depth is field 4 (for strings)
  depth = modulo10($4);

# It is terminated by \001 - so delete this termination
  str = substr(str,1,length(str)-4);

# Zap maths
  ##gsub(/[()-+*/]/,"",str); 

# Loose the cr stuff (if present)
  if (depth==0) {
      N=split(str,a,delimiter);
      if (N==3)
	  str=sprintf("%s%s%s", a[1],delimiter,a[2]);
    }

# A component string contains only alphanumeric  _ and :
  isa_plain_component = match(str, component_regexp)==0;
# It must also be specified at depth 0 (modulo 10)
  isa_plain_component = isa_plain_component && (depth==0);

# A port is a string within []
  isa_port = (match(str, port_regexp)>0)

# It must also be specified at depth 0
  isa_port = isa_port && (depth==0);

# Vector port definitions
  isa_PORT = ((match(str, PORT_regexp)>0) && (depth==0));

  if (isa_PORT) {
    print str
  }

# A port component is an SS  followed by a port string
  isa_port_component = 0;
  if (match(str, delimiter)) {
    split(str,a,delimiter);
    isa_port_component = (match(a[1], port_component_regexp))&&
      (match(a[2], port_regexp)>0)
      }

# It must also be specified at depth 0
  isa_port_component = isa_port_component && (depth==0);

# A component is a plain or a port component
  isa_component = isa_plain_component||isa_port_component;

# Coordinates in fields 12 & 13
  x_coord = $12;
  y_coord = $13;

# Do the ports
  if (isa_port) {
    i_port++;
    port_name = str;
    ports[i_port] = sprintf("%s %s %s", x_coord, y_coord, port_name);
  }

# Do the port components
#  if (isa_port_component) {
#    i_port_component++;
#    type = a[1];
#    # Port name is the bit between the []
#    port_label  = substr(a[2],2,length(a[2])-2);
#    x_port[i_port_component] = x_coord;
#    y_port[i_port_component] = y_coord;
#    info_port[i_port_component] = fig_info();
#    port_labels[i_port_component] = port_label;
#      }

# Do the components
  if (isa_component) {
    i_text++;

# Get repetitions (if any)
    if (match(str,repetition_regexp) > 0) {
      split(str,b,repetition_delimiter);
      repetitions = b[2];
      str = b[1];
	}
    else {
      repetitions = "1";
    };

    named_component = (match(str,delimiter) > 0);
    if (named_component) {
      split(str,a,delimiter);
      type = a[1];
      name = a[2];
# Check  if name is in label file and if used already
      found = 0; name_used = 0;
      for (i=1; i<=i_label; i++) {
	  lname = label[i,1];
	if ( lname==name ) {
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
printf(warning_f, name);
i_label++;
CR = default_cr;
args = "";
label[i_label,1] = name; 
label[i_label,2] = CR;
label[i_label,3] = args
}

# Give it a new entry if already used
#  -- also tell user as it is an error now(?)
      if (name_used) {
	printf(warning_u, name);
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
      type = str;

      if (type in name_index) 
        name_index[type]++
      else
        name_index[type] = 1;

      if (name_index[type]==1)
        name = sprintf("%s", type_name(type))
      else
        name = sprintf("%s_%i", type_name(type), name_index[type]);

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
    reps[name] = repetitions;
  }

}

#Euclidean length of a line between (first_x,first_y) and (second_x,second_y)
function line_length(first_x,first_y,second_x,second_y) {
  x_length = second_x-first_x;
  y_length = second_y-first_y;
  return sqrt( x_length*x_length +  y_length*y_length );
}

# Returns 1 if (bond) arrow at beginning of field or 2 if arrow at end of field
function arrow_end(first_x,first_y,second_x,second_y,penultimate_x,penultimate_y,last_x,last_y) {
  if ( line_length(first_x,first_y,second_x,second_y) < line_length(first_x,first_y,second_x,second_y) ) {
  return 1
  }
  else {
  return 2
  }
}

function process_bond() {

  arg_count++;
  if ( (arg_count-arrow)==1 ) 
    {

#Save up bond coords - no arrow and more segments than a stroke has.
# Allows for bent bonds - but just write out the relevant coordinates
	if ( (!arrow)&& (NF>2*stroke_coords+1) ) {
	    i_bond++;
	    a_end = arrow_end($2,$3,$4,$5,$(NF-3),$(NF-2),$(NF-1),$NF);
	    if (a_end==1) {
		arrow_end_vector_x = $6-$4; 
		arrow_end_vector_y = $7-$5; 
		other_end_vector_x = $(NF-1)-$(NF-3);
		other_end_vector_y = $(NF)-$(NF-2);
		bonds[i_bond] = sprintf("%s %s %s %s %s %s %s %s %s %s", \
					$2, $3, $4, $5, $(NF-1), $(NF),
					arrow_end_vector_x,
					arrow_end_vector_y,
					other_end_vector_x,
					other_end_vector_y);
	    }
	    else {
		other_end_vector_x = $4-$2; 
		other_end_vector_y = $5-$3; 
		arrow_end_vector_x = $(NF-3)-$(NF-5);
		arrow_end_vector_y = $(NF-2)-$(NF-4);
		bonds[i_bond] = sprintf("%s %s %s %s %s %s %s %s %s %s", \
					$2, $3, $(NF-3),$(NF-2),$(NF-1),$NF,
					arrow_end_vector_x,
					arrow_end_vector_y,
					other_end_vector_x,
					other_end_vector_y);
	    }
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
# and write out the components in a _cmp.fig file
# and write out the bonds in a _bnd.fig file

# The artwork -- not header and not zero depth
    
    if ((NF>2)&&(!zero_depth)) {
	art=$0;
	sub("----","    ",art)
	printf("%s\n", art) >> art_file
	    }
	    

#Everything except components
  if ( ((object!=text)||(isa_component==0)) ) {
    #Replace the data_symbol
    if (exact_match($1,data_symbol)) {
      field_1 = out_data_symbol
	}
    else {
      field_1 = $1
      }

    printf("%s",field_1)   >> fig_file
      for (i=2; i<=NF; i++)
	printf(" %s", $i)  >> fig_file;
    if (NF==1) 
	printf(" ")   >> fig_file; # Put space after header fields
    printf("\n") >> fig_file
    }

# Header
  if ( NF<3 ) {
	printf("%s", $1)  >> head_file;
        for (i=2; i<=NF; i++)
	  printf(" %s", $i)  >> head_file;
	if (NF==1) 
	    printf(" ")   >> head_file; # Put space after header fields
	printf("\n") >> head_file
    }
# Bonds
  if (isa_bond) {

    #Replace the data_symbol
    if (exact_match($1,data_symbol)) {
      field_1 = out_data_symbol
	}
    else {
      field_1 = $1
	}

    printf field_1   >> bnd_file
      for (i=2; i<=NF; i++)
	printf(" %s", $i)  >> bnd_file;
    printf("\n") >> bnd_file
      }

# Components & ports
  if ( isa_component||isa_port ) {
      for (i=1; i<=NF; i++)
	  printf(" %s", $i)  >> cmp_file;
      printf("\n") >> cmp_file
	  }

# Ports
  if ( isa_port_component ||isa_port) {
      for (i=1; i<=NF; i++)
	  printf(" %s", $i)  >> port_file;
      printf("\n") >> port_file
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
    zero_depth = ((modulo10($7)==0)&&(object==polyline)) || ((modulo10($4)==0)&&(object==text))
    f_arrow = ($14==1)&&(object=polyline);
    b_arrow = ($15==1)&&(object=polyline);
    arrow = f_arrow||b_arrow;
    arg_count = 0;
  }

#Process text
  if (object==text) {
    process_text();
    object = 0; # Text on one line so reset object to zero- avoids compound problem
      }

# Process bond
isa_bond = (zero_depth &&\
       (object==polyline)&& \
       (sub_type==sub_polyline)&& \
       (style==firm_style) \
       );   

if ( isa_bond && data_line)
{
    process_bond()
      }   

if (isa_fig_file){
     write_fig()
    }

    }

BEGIN {
  sys_name = ARGV[1];
  delete ARGV[1];

  b_file = sprintf("%s_rbg.m", sys_name);
  c_file = sprintf("%s_cmp.m", sys_name);
  fig_file = sprintf("%s_fig.fig", sys_name);
  cmp_file = sprintf("%s_cmp.fig", sys_name);
  port_file = sprintf("%s_port.fig", sys_name);
  bnd_file = sprintf("%s_bnd.fig", sys_name); 
  head_file = sprintf("%s_head.fig", sys_name);
  art_file = sprintf("%s_art.fig", sys_name);

  warning_f = "WARNING %s \t in fig file but not lbl file  - using\n";
  warning_l = "WARNING %s \t in lbl file but not fig file  - ignoring\n";
  warning_p = "ERROR system ports are not consecutively numbered\n";
  warning_u = "ERROR %s has already appeared in the fig file\n";

  comment_regexp = "%|#"
  data_symbol = "----";
  out_data_symbol = "\t";
  default_cr = "";
  default_args = "";
  delimiter = ":";
  repetition_delimiter = "*";
  repetition_regexp = "\\*";
  q = "\047";
  terminator = "\\001";
  component_regexp = "[^0-9a-zA-Z_:*-]";
  port_regexp = "^[[a-zA-Z0-9_,]*]";
  nonport_regexp = "[a-zA-Z]";
  PORT_regexp = "^PORT .*=";  
  port_component_regexp = "SS";
  isa_fig_file = 0;
  min_line_length = 10;
  object = 0;
  polyline = 2;
  sub_polyline=1; 
  firm_style = 0;
  text = 4;
  compound_object = 6;
  bond_coords = 3;
  stroke_coords = 2;
  arrow_coords = 2;

  i_bond = 0;
  i_port = 0;
  i_stroke = 0;
  i_arrow = 0;
  i_label = 0;
  i_text = 0;
  i_port_component = 0;

  component_index = 0;
}
{
# Start of .fig file?
  if ($1=="#FIG") {
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
#Print out the Octave functions
  printf("function [rbonds, rstrokes,rcomponents,port_coord,port_name,port_list] = %s_rbg\n", sys_name) > b_file;
  printf("%% [rbonds,rstrokes,rcomponents,port_coord,port_name,port_list] = %s_rbg\n", sys_name) > b_file;
  printf("%% Generated by MTT\n\n") > b_file;

  printf("function [comp_type, name, cr, arg, repetitions] = %s_cmp(i)\n",\
		 sys_name) > c_file;
  printf("%% [comp_type, name, cr, arg, repetitions] = %s_cmp\n", sys_name) > c_file;
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


# Do the port components, in order of appearance, first.
  for (i = 1; i <= i_label; i++) {
    name = label[i,1];
    if (match(name,port_regexp))
      write_component(i);
  }

# Now do the ordinary components, in order of appearance, last.
  for (i = 1; i <= i_label; i++) {
    name = label[i,1];
    if (!match(name,port_regexp))
      write_component(i);  
}
  printf("];\n") >> b_file;

# Print the (internal) ports list
  printf("port_coord = [\n") >> b_file;
  for (i = 1; i <= i_port; i++) {
    split(ports[i],a, " ");
    printf("%s %s\n", a[1], a[2]) >> b_file;
  }
  printf("];\n\n") >> b_file;

  printf("port_name = [\n") >> b_file;
  for (i = 1; i <= i_port; i++) {
    split(ports[i],a, " ");
    # Dont Remove the []
    # name = substr(a[3],2,length(a[3])-2);
    name = a[3];
    printf("'%s'\n", name) >> b_file;
  }
  printf("];\n\n") >> b_file;

# Print the (external) port list - ignore spurious ports (in lbl, not fig)
  printf("port_list = [\n") >> b_file;
  for (i = 1; i <= i_label; i++) {
    name = label[i,1];
    if (length(x[name])>0) {
      if (match(name,port_regexp))
	printf("'%s'\n", name) >> b_file;
    }
  }
  printf("];\n\n") >> b_file;
  
}



