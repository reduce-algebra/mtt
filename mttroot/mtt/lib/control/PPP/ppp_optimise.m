function [par,Par,Error,Y,iterations,x] = \
      ppp_optimise(system_name,x_0,par_0,simpar,u,y_0,free,Q,extras);
  ## Levenberg-Marquardt optimisation for PPP/MTT
  ## Usage: [par,Par,Error,Y,iterations,x] = ppp_optimise(system_name,x_0,par_0,simpar,u,y_0,free[,extras]);
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
  ##  Q               vector of positive output weights.
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
  ## Revision 1.11  2002/05/20 13:32:36  gawthrop
  ## Sanity check on y_0
  ##
  ## Revision 1.10  2002/05/13 16:01:09  gawthrop
  ## Addes Q weighting matrix
  ##
  ## Revision 1.9  2002/05/08 10:14:21  gawthrop
  ## Idetification now OK (Moved data range in ppp_optimise by one sample interval)
  ##
  ## Revision 1.8  2002/04/23 17:50:39  gawthrop
  ## error --> err to avoid name clash with built in function
  ##
  ## Revision 1.7  2001/08/10 16:19:06  gawthrop
  ## Tidied up the optimisation stuff
  ##
  ## Revision 1.6  2001/07/03 22:59:10  gawthrop
  ## Fixed problems with argument passing for CRs
  ##
  ## Revision 1.5  2001/06/06 07:54:38  gawthrop
  ## Further fixes to make nonlinear PPP work ...
  ##
  ## Revision 1.4  2001/05/26 15:46:38  gawthrop
  ## Updated to account for new nonlinear ppp
  ##
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

  if nargin<9
    extras.criterion = 1e-5;
    extras.max_iterations = 10;
    extras.v = 1e-5;
    extras.verbose = 0;
  endif
  

  [n_data,n_y] = size(y_0);
  if n_data<n_y
    error("ppp_optimise: y_0 should be in columns, not rows")
  endif

  if nargin<8
    Q = ones(n_y,1);
  endif
  
  n_th = length(i_s);
  err_old = inf;
  err_old_old = inf;
  err = 1e50;
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
    printf("  error:  %g\n", err);
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
	(abs(err)>extras.criterion)&&\
	(iterations<extras.max_iterations)

    iterations = iterations + 1 # Increment iteration counter

    [y,y_par,x] = eval(sim_command); # Simulate
    [N_data,N_y] = size(y)

    if (N_y!=n_y)
      mess = sprintf("n_y (%i) in data not same as n_y (%i) in model", n_y,N_y);
      error(mess);
    endif

    ## Use the last part of the simulation to compare with data
    ## ### Removed #### And shift back by one data point
#     if ( (N_data-n_data)<1 )
#       error(sprintf("y_0 (%i) must be shorter than y (%i)", n_data, N_data));
#     endif
    
    y = y(N_data-n_data+1:N_data,:);
    y_par = y_par(N_data-n_data+1:N_data,:);

    if extras.visual==1
      ## Plot
      title("Optimisation data");
      plot([y y_0])
    endif
    
    ##Evaluate error, cost derivative J and cost second derivative JJ
    err = 0; 
    J = zeros(n_th,1);
    JJ = zeros(n_th,n_th);
   
    for i = 1:n_y
      E = y(:,i) - y_0(:,i);	#  Error in ith output
      err = err + Q(i)*(E'*E);	# Sum the squared error over outputs
      y_par_i = y_par(:,i:n_y:n_y*n_th); # sensitivity function (ith output)
      J  = J + Q(i)*y_par_i'*E;	# Jacobian
      JJ = JJ + Q(i)*y_par_i'*y_par_i; # Newton Euler approx Hessian
    endfor

    if iterations>1 # Adjust the Levenberg-Marquardt parameter
      reduction = err_old-err;
      predicted_reduction =  2*J'*step + step'*JJ*step;
      r = predicted_reduction/reduction;
      if (r<0.25)||(reduction<0)
	v = 4*v;
      elseif r>0.75
	v = v/2;
      endif

      if reduction<0		# Its getting worse
	par(i_t) = par(i_t) + step; # rewind parameter
	err = err_old;	# rewind error
	err_old = err_old_old; # rewind old error
	if extras.verbose
	  printf(" Rewinding ....\n");
	endif
      endif
    endif

    ## Compute step using pseudo inverse
    JJL = JJ + v*eye(n_th);	# Levenberg-Marquardt term
    step =  pinv(JJL)*J;	# Step size
    par(i_t) = par(i_t) - step; # Increment parameters
    err_old_old = err_old;	# Save old error
    err_old = err;		# Save error

    ##Some diagnostics
    Error = [Error err];	# Save error
    Par = [Par par];		# Save parameters
    Y = [Y y];			# Save output

    if extras.verbose		# Diagnostics
      printf("Iteration: %i\n", iterations);
      printf("  error:  %g\n", err);
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
