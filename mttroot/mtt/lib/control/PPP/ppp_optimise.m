function [par,Par,Error,Y,iterations] = \
      ppp_optimise(system_name,x_0,par_0,simpar,u,y_0,free,extras);
  ## Levenberg-Marquardt optimisation for PPP/MTT
  ## Usage: [par,Par,Error,Y,iterations] = ppp_optimise(system_name,x_0,par_0,simpar,u,y_0,free[,extras]);
  ##  system_name     String containing system name
  ##  x_0             Initial state
  ##  par_0           Initial parameter vector estimate
  ##  simpar          Simulation parameters:
  ##        .first      first time
  ##        .dt         time increment
  ##        .stepfactor Euler integration step factor
  ##  u               System input (column vector, each row is u')
  ##  y_0             Desired model output
  ##  free            one row for each adjustable parameter
  ##                  first column parameter indices
  ##                  second column corresponding sensitivity indices
  ##  extras (opt)    optimisation parameters
  ##        .criterion convergence criterion
  ##        .max_iterations limit to number of iterations
  ##        .v  Initial Levenberg-Marquardt parameter

  ###################################### 
  ##### Model Transformation Tools #####
  ######################################
  
  ###############################################################
  ## Version control history
  ###############################################################
  ## $Id$
  ## $Log$
  ## Revision 1.3  2001/04/05 11:50:12  gawthrop
  ## Tidied up documentation + verbose mode
  ##
  ## Revision 1.2  2001/04/04 08:36:25  gawthrop
  ## Restuctured to be more logical.
  ## Data is now in columns to be compatible with MTT.
  ##
  ## Revision 1.1  2000/12/28 11:58:07  peterg
  ## Put under CVS
  ##
  ###############################################################


  ## Copyright (C) 1999,2000 by Peter J. Gawthrop

  sim_command = sprintf("%s_ssim(x_0,par,simpar,u,i_s)", system_name);

  ## Extract indices
  i_t = free(:,1);		# Parameters
  i_s = free(:,2)';		# Sensitivities

  if nargin<8
    extras.criterion = 1e-5;
    extras.max_iterations = 10;
    extras.v = 1e-5;
    extras.verbose = 0;
  endif
  

  [n_data,n_y] = size(y_0);
  if n_data<n_y
    error("ppp_optimise: y_0 should be in columns, not rows")
  endif

  n_th = length(i_s);
  error_old = inf;
  error_old_old = inf;
  error = 1e50;
  reduction = inf;
  predicted_reduction = 0;
  par = par_0;
  Par = par_0;
  step = ones(n_th,1);
  Error = [];
  Y = [];
  iterations = 0;
  v = extras.v;			# Levenverg-Marquardt parameter.
  r = 1;			# Step ratio

  if extras.verbose		# Diagnostics
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
  
  while (abs(reduction)>extras.criterion)&&\
	(abs(error)>extras.criterion)&&\
	(iterations<extras.max_iterations)

    iterations = iterations + 1; # Increment iteration counter

    [y,y_par] = eval(sim_command); # Simulate
    [N_data,N_y] = size(y);

    if (N_y!=n_y)
      mess = sprintf("n_y (%i) in data not same as n_y (%i) in model", n_y,N_y);
      error(mess);
    endif
    
    ## Use the last part of the simulation to compare with data
    y = y(1+N_data-n_data:N_data,:);
    y_par = y_par(1+N_data-n_data:N_data,:);

    ##Evaluate error, cost derivative J and cost second derivative JJ
    error = 0; 
    J = zeros(n_th,1);
    JJ = zeros(n_th,n_th);
    
    for i = 1:n_y
      E = y(:,i) - y_0(:,i);	#  Error in ith output
      error = error + (E'*E);	# Sum the squared error over outputs
      y_par_i = y_par(:,i:n_y:n_y*n_th); # sensitivity function (ith output)
      J  = J + y_par_i'*E;	# Jacobian
      JJ = JJ + y_par_i'*y_par_i; # Newton Euler approx Hessian
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
    Y = [Y y];			# Save output

    if extras.verbose		# Diagnostics
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
    

  endwhile

endfunction
