function mtt_write(t,x,y,nx,ny);

###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
###############################################################


  printf("%e ", t);
  for i=1:ny
    printf("%e ", y(i));
  endfor

  printf("%e ", t);
  for i=1:nx
    printf("%e ", x(i));
  endfor
  printf("\n");

endfunction

