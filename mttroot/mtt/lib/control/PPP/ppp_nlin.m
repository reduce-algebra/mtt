function [U, U_all, Error, Y] = ppp_nlin (system_name,x_0,us,t,par_0,free,w,extras)

  ## usage:  U = ppp_nlin (system_name,x_0,u,t,par_0,free,w,weight)
  ##
  ## 

   if nargin<8
     extras.criterion = 1e-8;
     extras.max_iterations = 10;
     extras.v = 0.1;
     extras.verbose = 1;
   endif

   ## Details
   [n_x,n_y,n_u] = eval(sprintf("%s_def;", system_name));
   [n_us,n_tau] = size(us);

   ## Checks
   if (n_us<>n_u)
     error(sprintf("Inputs (%i) not equal to system inputs (%i)", n_us, n_u));
   endif
   
  [par,Par,Error,Y] = ppp_optimise(system_name,x_0,us,t,par_0,free,w,extras);

  U = par(free(:,1));
  U_all = Par(free(:,1),:);
endfunction



