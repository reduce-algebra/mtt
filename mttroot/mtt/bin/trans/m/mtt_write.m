function mtt_write(t,x,y,nx,ny);

  printf("%g ", t);
  for i=1:ny
    printf("%g ", y(i));
  end
  printf("# ");

  printf("%g ", t);
  for i=1:nx
    printf("%g ", x(i));
  end
  printf("\n");

endfunction

