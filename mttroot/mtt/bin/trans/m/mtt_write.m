function mtt_write(t,x,y,nx,ny);

  printf("%e ", t);
  for i=1:ny
    printf("%e ", y(i));
  end
  printf("# ");

  printf("%e ", t);
  for i=1:nx
    printf("%e ", x(i));
  end
  printf("\n");

endfunction

