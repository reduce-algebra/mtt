###################################### 
##### Model Transformation Tools #####
######################################

# gawk script: lbl2cr.awk
# Label file to symbolic parameters conversion
# P.J.Gawthrop August 1996
# Copyright (c) P.J.Gawthrop, 1996.

###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
## Revision 1.9  1998/03/08 21:01:40  peterg
## Now does multiple crs
##
## Revision 1.8  1998/03/06 09:15:28  peterg
## Ignores SS fields (assumes that if first field is a symbol then other
## field is and SS-style field.
##
## Revision 1.7  1997/04/22 12:50:15  peterg
## New much simpler version -- does not check for multiple crs -- these
## are removed later anyway.
##
# Revision 1.6  1997/03/22  15:15:44  peterg
# Ignores symbolic ($i) crs.
#
# Revision 1.5  1997/03/20  12:05:31  peterg
# Now just writes out the cr name.
#
# Revision 1.4  1996/11/09  20:38:45  peterg
# Put in new lib pat
#
## Revision 1.3  1996/11/04 14:51:14  peterg
## Added none to no cr list
##
# Revision 1.2  1996/11/02  10:22:22  peterg
# Now ignores SS lines.
#
###############################################################


function exact_match(name1, name2) {
  return ((match(name1,name2)>0)&&(length(name1)==length(name2)))
    }

function matches(names, name) {
  n_matches = split(names,match_name);
  matched = 0;
  for (i_matches = 1; i_matches <= n_matches; i_matches++) {
    if ( exact_match(name,match_name[i_matches]) ) {
      matched = 1;
      break;
    }
  }
  return matched;
    }


BEGIN {
comment = "%|#";
cr_delimiter = ";";
not_a_cr = "effort flow state internal external zero none";
is_a_SS = "internal external zero";
numeric = "[0-9]";
symbolic = "\044"; # Ascii $
symbol_count = 0;
symbols = "";

# Include lin cr anyway.
print "lin"
}
{
  if ( (match($1,comment)==0) && (NF>=3) ) {
      crs = $2
    n_crs = split(crs,cr,cr_delimiter);
    for (i = 1; i <= n_crs; i++) {
      first_char = substr(cr[i],1,1);
      if ( (matches(not_a_cr,cr[i])==0) &&
         (match(numeric,first_char)==0) &&
         (matches(is_a_SS,$3)==0))
	 print cr[i];
    }
  }
}
