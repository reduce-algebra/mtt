function alias = SS_alias	# Port aliases for SS

###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
## Revision 1.2  1998/07/28 19:08:22  peterg
## Some vector aliases added.
##
## Revision 1.1  1998/07/02 14:37:42  peterg
## Initial revision
##
###############################################################

  alias.in   = "1";
  alias.out  = "1";

  MAX = 10;
  value = "1";
  for i=1:MAX
    eval(sprintf("alias.in%i = \"%s\";", i, value));
    eval(sprintf("alias.out%i = \"%s\";", i, value));
    value = sprintf("%s,%i",value,i+1);
  endfor;
endfunction


