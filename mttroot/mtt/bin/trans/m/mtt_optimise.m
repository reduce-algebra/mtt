function [theta,Theta,Error,Y,iterations] = mtt_optimise (system_name,y_s,theta_0,method,free,weight,criterion,max_iterations,alpha,View)
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
    alpha = 0.1;
  endif
  
  if nargin<10
    View = 0;
  endif
  
  if (!strcmp(method,"time"))&&(!strcmp(method,"freq"))
    error("method must be either time or freq")
  endif
  
  [n_data,n_y] = size(y_s);

  n_th = length(free);
  error_old = inf;
  error=1e50;
  theta = theta_0;
  Theta = [];
  Error = [];
  Y = [];
  iterations = 0;
  while (abs(error_old-error)>criterion)&&(abs(error)>criterion)&&(iterations<max_iterations)
    iterations = iterations + 1;
    error_old_old = error_old;
    error_old = error;
    eval(sprintf("[t,y,y_theta] = \
	mtt_s%s(system_name,theta,free);",method)); # Simulate system

    if View
      xlabel("");
      title(sprintf("mtt_optimise: Weighted actual and estimated Interation %i", iterations));
      plot(t,y.*weight,t,y_s.*weight);
    endif
    
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

    error
 
    if error<(error_old+criterion) # Save some diagnostics
      Error = [Error error];	# Save error
      Theta = [Theta theta];	# Save parameters
      Y = [Y y];		# Save output
    endif

    ## Update the estimate if we are not done yet.
    if (abs(error_old-error)>criterion)&&(abs(error)>criterion)&&(iterations<max_iterations)
      if error>(error_old+criterion) # Reduce step size and try again
        factor = 10;
	disp(sprintf("%2.2f*step",alpha));
	error = error_old;	# Go back to previous error value
	error_old = inf;	# Don't let it think its converged
	theta(free) = theta(free)  + step; # Reverse step
	step = alpha*step;	# new stepsize
      else			# Recompute step size
	tol = 1e-5;
	step =  pinv(JJ,tol)*J;	# Step size
	#step =  pinv(JJ)*J;	# Step size (built in tol)
      endif
      theta(free) = theta(free) - step; # Increment parameters
    endif
 ##   theta
  endwhile
endfunction


