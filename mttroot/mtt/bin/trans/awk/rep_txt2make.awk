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
# Revision 1.1  1996/08/18  19:59:00  peter
# Initial revision
#
###############################################################


BEGIN {
  split(ARGV[1],a,"_");
  system_name = a[1];
    }
{
  if (NF==2) {
    if( match("tex txt r m ps",$2)>0) {
      printf("mtt -q %s %s %s\n ", system_name, $1, $2)
    } 
  }
}
END {

}



