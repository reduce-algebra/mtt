function mtt_write(t,x,y,nx,ny);

###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
## Revision 1.3  1999/03/15 21:57:00  peterg
## Removed the # symbol
##
###############################################################

global MTT_data
  if t==0.0
    MTT_data=[];
  endif

MTT_data = [MTT_data; t,y',t,x'];



#   printf("%e ", t);
#   for i=1:ny
#     printf("%e ", y(i));
#   endfor

#   printf("%e ", t);
#   for i=1:nx
#     printf("%e ", x(i));
#   endfor
#   printf("\n");

endfunction

