function mtt_write(t,x,y,nx,ny,first);

###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
## Revision 1.6  2002/05/13 08:52:23  gawthrop
## FIRST parameter of simpar now specifies first printed point -
## simulation still starts at zero
##
## Revision 1.5  2001/03/30 15:13:58  gawthrop
## Rationalised simulation modes to each return mtt_data
##
## Revision 1.4  1999/03/15 23:05:29  peterg
## A complete rewrite - now puts into a Global matrix MTT_data
##
## Revision 1.3  1999/03/15 21:57:00  peterg
## Removed the # symbol
##
###############################################################

global MTT_data
  if (t==0.0)
    MTT_data=[];
  endif

  if (t>= first)
    MTT_data = [MTT_data; t,y(:)',t,x(:)'];
  endif
  
endfunction

