function [x] = mtt_update(dx,x,dt,Nx,METHOD);

  x = x + dx*dt;

endfunction;
