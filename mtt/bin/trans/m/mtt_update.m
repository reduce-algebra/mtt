function [x] = mtt_update(dx,x,dt,STEPFACTOR,METHOD,name);

  if (METHOD==1)		#Euler
    ddt = dt/STEPFACTOR;
    x = x + dx*ddt;
  elseif (METHOD==2)		#Linear implicit or Implicit
    eval("[AA,AAx] = ",name,"_smx;");
    x = AA\(AAx + dx*dt);
  else
    error("Method %i is not defined", METHOD);
  endif;

endfunction;
