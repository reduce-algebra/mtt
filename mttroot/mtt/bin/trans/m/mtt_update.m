function [x] = mtt_update(dx,x,AAx,AA,dt,STEPFACTOR,Nx,METHOD);

  if (METHOD==1)		#Euler
    ddt = dt/STEPFACTOR;
      x = x + dx*ddt;
  elseif ((METHOD==2)||(METHOD==3))#Linear implicit or Implicit
    x = AA\(AAx + dx*dt);
  else
    error("Method %i is not defined", METHOD);
  endif;

endfunction;
