function [par,Par,Error,Y,iterations] = ppp_optimise(system_name,x_0,u,t,par_0,free,y_0,extras);
  ## Usage: [par,Par,Error,Y,iterations] = ppp_optimise(system_name,x_0,u,t,par_0,free,y_0,weight,extras);
  ##  system_name     String containg system name
  ##  y_s   actual system output
  ##  theta_0   initial parameter estimate
  ##  free  Indices of the free parameters within theta_0
  ##  weight Weighting function - same dimension as y_s
  ##  extras.criterion convergence criterion
  ##  extras.max_iterations limit to number of iterations
  ##  extras.v  Initial Levenberg-Marquardt parameter

  ## Copyright (C) 1999,2000 by Peter J. Gawthrop

  ## Extract indices
  i_t = free(:,1); # Parameters
  i_s = free(:,2)'; # Sensitivities

  if nargin<8
    extras.criterion = 1e-5;
    extras.max_iterations = 10;
    extras.v = 1e-5;
    extras.verbose = 0;
  endif
  

  [n_y,n_data] = size(y_0);

  n_th = length(i_s);
  error_old = inf;
  error_old_old = inf;
  error = 1e50;
  reduction = 1e50;
  par = par_0;
  Par = par_0;
  step = ones(n_th,1);
  Error = [];
  Y = [];
  iterations = 0;
  v = extras.v;			# Levenverg-Marquardt parameter.
  r = 1;			# Step ratio

  while (abs(reduction)>extras.criterion)&&\
	(abs(error)>extras.criterion)&&\
	(iterations<extras.max_iterations)

    iterations = iterations + 1; # Increment iteration counter

    [y,y_par] = eval(sprintf("%s_sim(x_0,u,t,par,i_s)", system_name)); # Simulate

    ##Evaluate error, cost derivative J and cost second derivative JJ
    error = 0; 
    J = zeros(n_th,1);
    JJ = zeros(n_th,n_th);
    
    for i = 1:n_y
      E = y(i,:) - y_0(i,:);	#  Error
      error = error + (E*E');	# Sum the error over outputs
      y_par_i = y_par(i:n_y:n_y*n_th,:);
      J  = J + y_par_i*E';	# Jacobian
      JJ = JJ + y_par_i*y_par_i'; # Newton Euler approx Hessian (with LM
				# term
    endfor

    if iterations>1 # Adjust the Levenberg-Marquardt parameter
      reduction = error_old-error;
      predicted_reduction =  2*J'*step + step'*JJ*step;
      r = predicted_reduction/reduction;
      if (r<0.25)||(reduction<0)
	v = 4*v;
      elseif r>0.75
	v = v/2;
      endif

      if extras.verbose
	printf("Iteration: %i\n", iterations);
	printf("  error:  %g\n", error);
	printf("  reduction:  %g\n", reduction);
	printf("  prediction: %g\n", predicted_reduction);
	printf("  ratio:      %g\n", r);
	printf("  L-M param:  %g\n", v);
	printf("  parameters: ");
	for i_th=1:n_th
	  printf("%g ", par(i_t(i_th)));
	endfor
	printf("\n");
	  
      endif
    
      if reduction<0		# Its getting worse
	par(i_t) = par(i_t) + step; # rewind parameter
	error = error_old;	# rewind error
	error_old = error_old_old; # rewind old error
	if extras.verbose
	  printf(" Rewinding ....\n");
	endif
	
      endif

    endif

    ## Compute step using pseudo inverse
    JJL = JJ + v*eye(n_th);	# Levenberg-Marquardt term
    step =  pinv(JJL)*J;	# Step size

    par(i_t) = par(i_t) - step; # Increment parameters
    error_old_old = error_old;	# Save old error
    error_old = error;		# Save error

    ##Some diagnostics
    Error = [Error error];	# Save error
    Par = [Par par];		# Save parameters
    Y = [Y; y];			# Save output

  endwhile

endfunction





