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
    criterion = 1e-7;
  endif
  
  if nargin <8
    max_iterations = 25;
  endif

  if nargin<9
    alpha = 1.0;
  endif
  
  if (!strcmp(method,"time"))&&(!strcmp(method,"freq"))
    error("method must be either time or freq")
  endif
  
  [n_data,n_y] = size(y_s);

  n_th = length(free);
  error_old = 1e20;
  error=1e10;
  theta = theta_0;
  Theta = [];
  Error = [];
  Y = [];
  iterations = -1;
  while (abs(error_old-error)>criterion)&&(iterations<max_iterations)
    iterations = iterations + 1;
    error_old_old = error_old;
    error_old = error;
    eval(sprintf("[t,y,y_theta] = mtt_s%s(system_name,theta,free);",method)); # Simulate system
plot(t,y(:,2:3));
    error = 0; 
    J = zeros(n_th,1);
    JJ = zeros(n_th,n_th);
    for i = 1:n_y
      E = weight(:,i).*(y(:,i) - y_s(:,i)); # Weighted error
      error = error + (E'*E);	# Sum the error

      Weight = weight(:,i)*ones(1,n_th); # Sensitivity weight
      y_theta_w = Weight.*y_theta(:,i:n_y:n_y*n_th); # Weighted sensitivity
      J  = J + real(y_theta_w'*E); # Jacobian
      JJ = JJ + real(y_theta_w'*y_theta_w); # Newton Euler approx Hessian
    endfor

    error = error
    ## Diagnostics
    Error = [Error error];	# Save error
    Theta = [Theta theta];	# Save parameters
    Y = [Y y];			# Save output

    ## Update the estimate if we are not done yet.
    if (abs(error_old-error)>criterion)&&(iterations<max_iterations)
      if error>error_old+criterion # Halve step size and try again
        factor = 10;
	disp(sprintf("step/%i",factor));
	error = error_old;	# Go back to previous error value
	error_old = inf;	# Don't let it think its converged
	theta(free) = theta(free)  + step; # Reverse step
	step = step/factor;	# new stepsize
      else			# Recompute step size
	tol = 1e-5;
	step =  pinv(JJ,tol)*J;	# Step size
	#step =  pinv(JJ)*J;	# Step size (built in tol)
      endif
      theta(free) = theta(free) - step; # Increment parameters
    endif

   endwhile
endfunction


