function mtt_write(t,x,y,nx,ny);

###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
## Revision 1.4  1999/03/15 23:05:29  peterg
## A complete rewrite - now puts into a Global matrix MTT_data
##
## Revision 1.3  1999/03/15 21:57:00  peterg
## Removed the # symbol
##
###############################################################

global MTT_data
  if t==0.0
    MTT_data=[];
  endif

  MTT_data = [MTT_data; t,y',t,x'];
endfunction

