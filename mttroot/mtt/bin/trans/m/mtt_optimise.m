function [theta,Theta,Error,Y,iterations] = mtt_optimise (system_name,y_s,theta_0,method,free,weight,criterion,max_iterations,alpha)
  ## Usage: [theta,Theta,Error,Y,iterations] = mtt_optimise (system_name,y_s,theta_0,method,free,weight,criterion,max_iterations,alpha)
  ##  system_name     String containg system name
  ##  y_s   actual system output
  ##  theta_0   initial parameter estimate
  ##  free  Indices of the free parameters within theta_0
  ##  weight Weighting function - same dimension as y_s
  ##  method "time" or "freq"
  ##  criterion convergence criterion
  ##  max_iterations limit to number of iterations
  ##  alpha  Optimisation gain parameter

  ## Copyright (C) 1999 by Peter J. Gawthrop

  if nargin<4
    method="time";
  endif

  N = length(theta_0);
  if nargin<5
    free = [1:N];
  endif
  
  if nargin<6
    weight = ones(size(y_s));
  endif

  if nargin<7
    criterion = 1e-5;
  endif
  
  if nargin <8
    max_iterations = 10;
  endif

  if nargin<9
    alpha = 1.0;
  endif
  
  if (!strcmp(method,"time"))&&(!strcmp(method,"freq"))
    error("method must be either time or freq")
  endif
  
  N_theta = length(free);
  Weight = weight*ones(1,N_theta); # Sensitivity weight
  e_last = 1e20;
  error=1e10;
  theta = theta_0;
  Theta = [];
  Error = [];
  Y = [];
  iterations = -1;
  while (abs(e_last-error)>criterion)&&(iterations<max_iterations)
    iterations = iterations + 1;
    e_last = error;
    eval(sprintf("[t,y,y_theta] = mtt_s%s(system_name,theta,free);",method)); # Simulate system
    Theta = [Theta theta];	# Save parameters
    Y = [Y y];			# Save output
    E = weight.*(y - y_s);	# Weighted error
    y_theta = Weight.*y_theta;	# Weighted sensitivity
    error = (E'*E);		# Sum the error
    Error = [Error error];
    ##    theta(free) = theta(free) - alpha*(real(y_theta'*y_theta)\real(y_theta'*E));
    tol = 1e-4;
    JJ = real(y_theta'*y_theta);
    ## sigma = svd(JJ)
    theta(free) = theta(free) - alpha*( pinv(JJ,tol)*real(y_theta'*E) );
  endwhile

endfunction


