###################################### 
##### Model Transformation Tools #####
######################################

# gawk script: rep_txt2make
# Converts the text file describing a report to makefile dependencies
# P.J.Gawthrop August 1996
# Copyright (c) P.J.Gawthrop, 1996.

###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
# Revision 1.3  1997/05/19  15:40:04  peterg
# Pass mtt swithches to the new make file
#
# Revision 1.2  1996/11/21  15:57:28  peterg
# Now runs mtt quietly.
#
# Revision 1.1  1996/08/18  19:59:00  peter
# Initial revision
#
###############################################################


{
  if (NF==2)
    if( match("tex txt r m ps",$2)>0)
      print "mtt -q", switches, system_name, $1, $2
}



