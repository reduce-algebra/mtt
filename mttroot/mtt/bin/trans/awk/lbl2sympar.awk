###################################### 
##### Model Transformation Tools #####
######################################

# gawk script: lbl2sympar.awk
# Label file to symbolic parameters conversion
# P.J.Gawthrop August 1996
# Copyright (c) P.J.Gawthrop, 1996.

###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
## Revision 1.5  1996/12/07 18:06:50  peterg
## Now detects symbolic args ($1 etc) and ignores them.
##
# Revision 1.4  1996/08/30  18:45:32  peter
# Removed header stuff.
#
## Revision 1.3  1996/08/30 10:30:54  peter
## Switched order of args in matches.
##
## Revision 1.2  1996/08/30 09:35:10  peter
## Fixed problem with global variable in function.
##
## Revision 1.1  1996/08/24 13:34:48  peter
## Initial revision
##
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
sys_name = ARGV[1];
comment = "%";
arg_delimiter = ",";
not_an_arg = "effort flow state internal external zero 0 1";
numeric = "[0-9]";
symbol_count = 0;
symbols = "";
}
{
  if ( (match($1,comment)==0) && (NF>=3) ) {
# The following line is a bad attempt to use parameters in SS fields
# It assumes that at least one SS field is not_an_arg.
    if (matches(not_an_arg,$3)) {
      args = $2
	}
    else {
      args = $3;
    }
    n_args = split(args,arg,arg_delimiter);
    for (i = 1; i <= n_args; i++) {
      first_char = substr(arg[i],1,1);
      if ( (matches(not_an_arg,arg[i])==0) \
	   && (match(first_char,numeric)==0) \
	   && (match(arg[i],"\\$")==0) \
	   && (length(arg[i])>0) \
	   && (matches(symbols,arg[i]) ==0) ) {
	symbol_count++;
	symbols = sprintf("%s %s", symbols, arg[i]);
	  }
    }
  }
}
END {
# print the _sympar file

  printf("MTTNVar := %1.0f;\n", symbol_count);

  if (symbol_count>0) {
    printf("MATRIX MTTVar(MTTNVar,1);\n");
    split(symbols,symbol);
    for (i = 1; i <= symbol_count; i++) {
      printf("MTTVar(%1.0f,1) \t := %s;\n", i, symbol[i]);
    }
  }

}



