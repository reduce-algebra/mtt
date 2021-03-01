function [par,Par,Error,Y] = ppp_identify (system_name,u,y_0,par_names,par_0,extras)
  ## ppp_identify: System identification for PPP
  ## usage:  [par,Par,Error,Y] = ppp_identify(system_name,u,y_0,par_names,par_0,extras)
  ##
  ##  system_name     String containing system name
  ##  u               System input (column vector, each row is u')
  ##  y_0             Desired model output
  ##  par_names       Column vector of (padded) strings - the adjustable
  ##                  parameter names
  ##  par_0           Initial parameter vector estimate
  ##  extras (opt)    optimisation parameters
  ##        .criterion convergence criterion
  ##        .max_iterations limit to number of iterations
  ##        .v  Initial Levenberg-Marquardt parameter

  
  if nargin<6
    extras.criterion = 1e-5;
    extras.max_iterations = 10;
    extras.v = 1e-5;
    extras.verbose = 0;
  endif  

  s_system_name = sprintf("s%s", system_name); # Name of sensitivity system

  ## Set up parameters
  sim = eval([s_system_name, "_simpar;"]); # Simulation parameter
  sym = eval([s_system_name, "_sympar;"]); # Parameter names
  x0  = eval([s_system_name, "_state(par_0);"]); # Initial state

#   ## Set up the free parameter list
#   free = [];
#   [n,m] = size(par_names);
#   for i = 1:n
#     p_name = deblank(par_names(i,:));
#     s_name = sprintf("%ss", p_name);
#     if struct_contains(sym, p_name)
#       i_p = eval(sprintf("sym.%s;", p_name));
#       if struct_contains(sym, s_name)
# 	i_s = eval(sprintf("sym.%s;", s_name));
# 	free_i = eval(sprintf("[%i,%i];", i_p, i_s));
# 	free = [free; free_i];
#       else
# 	printf("Sensitivity parameter %s does not exist: ignoring \
# 	parameter %s\n", s_name, p_name);
#       endif
#     else
#       printf("Parameter %s does not exist: ignoring\n", p_name)
#     endif
#   endfor
#   free
  free = ppp_indices(par_names,sym);
  [par,Par,Error,Y] = ppp_optimise(s_system_name,x0,par_0,sim,u,y_0,free,extras);

endfunction







