function [U, U_all, Error, Y, its] = ppp_nlin(system_name,x_0,par_0,sim,us,w,free, Q, extras)

  ## usage:  [U, U_all, Error, Y,its ] = ppp_nlin(system_name,x_0,par_0,sim,us,w,free, Q, extras)
  ##
  ## 
  
  if nargin<9
    extras.criterion = 1e-8;
    extras.max_iterations = 10;
    extras.v = 0.1;
    extras.verbose = 1;
  endif
  
  s_system_name = sprintf("s%s", system_name); # Name of sensitivity system
  
  ## Details
  [n_x,n_y,n_u] = eval(sprintf("%s_def;", system_name));
  [n_tau,n_us] = size(us);
  
  if nargin<8
    Q = ones(n_y,1);
  endif
 
  ## Checks
  if (n_us<>n_u)
    error(sprintf("Inputs (%i)  differenct to system inputs (%i)", n_us, n_u));
  endif
    
  ##Optimise
  [par,Par,Error,Y,its] = ppp_optimise(s_system_name,x_0,par_0,sim,us,w,free,Q,extras);
  
  U = par(free(:,1));
  U_all = Par(free(:,1),:);
endfunction



