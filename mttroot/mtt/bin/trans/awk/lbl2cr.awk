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
comment = "%";
arg_delimiter = ",";
not_a_cr = "effort flow state internal external zero none";
numeric = "[0-9]";
symbol_count = 0;
symbols = "";
}
{
  if ( (match($1,comment)==0) && (NF>=3) ) {
    cr = $2;
    first_char = substr(cr,1,1);
    if ( (matches(not_a_cr,cr )==0) \
	 && (match(not_a_cr,$3)==0) \
	 && (match(first_char,numeric)==0) \
	 && (length(cr )>0) \
	 && (matches(symbols,cr ) ==0) ) {
      symbol_count++;
      symbols = sprintf("%s %s", symbols, cr );
    }
  }
}
END {
# create the _cr file

  if (symbol_count>0) {
    split(symbols,symbol);
    for (i = 1; i <= symbol_count; i++) {
      #printf("$MTTPATH/lib/cr/r/%s.cr ", symbol[i]);
      printf("%s\n", symbol[i]);
    }
  }








}
