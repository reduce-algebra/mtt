function [y,u,t,p,UU,t_open,t_ppp,t_est,its_ppp,its_est] = ppp_nlin_run (system_name,i_ppp,i_par,A_u,w_s,N_ol,extras)


  ## usage: [y,u,t,p,U,t_open,t_ppp,t_est,its_ppp,its_est] =
  ## ppp_nlin_run (system_name,i_ppp,i_par,A_u,w_s,N_ol[,extras])
  ##
  ##  y,u,t   System output, input and corresponding time p
  ##  Estimated parameters U       PPP weight vector t_open  The
  ##  open-loop interval t_ppp   Time for each ppp optimisation t_est
  ##  Time for each estimation i_ppp   Matrix of ppp gain indices: col.
  ##  1 Gain indices in sensitivity system col. 2  Gain sensitivity
  ##  indices in sensitivity system col. 3  Gain indices in  system
  ##  i_par Matrix of indices of estimated parameters col. 1  Parameter
  ##  indices in sensitivity system col. 2  Parameter sensitivity
  ##  indices in sensitivity system col. 3  Parameter indices in  system
  ##  A_u     Basis function generating matrix w_s     w_star: That part
  ##  of the moving horizon setpoint within the optimisation horizon.
  ##  N_ol The number of open-loop intervals to be computed extras
  ##  Extra parameters in  a structure: extras.alpha           ??
  ##  extras.criterion Optimisation convergence criterion
  ##  extras.emulate_timing Simulate some real-time features
  ##  extras.estimate Estimate parameters and states
  ##  extras.max_iterations Maximum optimisation iterations
  ##  extras.simulate 1 for simulation (not real-time) extras.vInitial Levenberg-Marquardt parameter
  ##          extras.verbose         1 for extra info display
  ##
  ## Real-time implementatipn of  nonlinear PPP Copyright (C) 2001,2002
  ## by Peter J. Gawthrop

  ## Globals to pass details to simulation
  global system_name_sim i_ppp_sim x_0_sim y_sim u_sim A_u_sim simpar_sim

  ## Defaults
  if nargin<7
    extras.alpha = 0.1;
    extras.criterion = 1e-5;
    extras.emulate_timing = 0;
    extras.estimate = 1;
    extras.max_iterations = 10;
    extras.simulate = 1;
    extras.v = 1e-5;
    extras.verbose = 0;
  endif
  
  ## Names
  s_system_name = sprintf("s%s", system_name);

  ## System details -- defines simulation within ol interval
  par = eval(sprintf("%s_numpar;", system_name));
  simpar = eval(sprintf("%s_simpar;", system_name));
  dt = simpar.dt;		# Sample interval
  simpar_est = simpar;		# Initial estimation simulation params
  simpar_model = simpar;	# Initial internal model simulation params
  simpar_pred = simpar;		# Initial prediction simulation params
  T_ol_0 = simpar.last;		# The initial specified interval
  n_t = round(simpar.last/simpar.dt); # Corresponding length
  x_0 = eval(sprintf("%s_state(par);", system_name));
  x_0_model = x_0;
  [n_x,n_y,n_u] = eval(sprintf("%s_def;", system_name));

  ## Sensitivity system details -- defines moving horizon simulation
  simpars = eval(sprintf("%s_simpar;", s_system_name));
  pars = eval(sprintf("%s_numpar;", s_system_name));
  x_0s = eval(sprintf("%s_state(pars);", s_system_name));

  ## Times
  ## -- within opt horizon
  n_Tau = round(simpars.last/simpars.dt);
  dtau = simpars.dt;
  Tau = [0:n_Tau-1]'*dtau;
  [n_tau,n_w] = size(w_s);
  tau = Tau(n_Tau-n_tau+1:n_Tau);
  w = w_s(n_tau,:);		# Final value of setpoint


  ## Main simulation loop
  y = [];
  x = [];
  u = [];
  t = [];

  p = [];

  t_last = 0;
  UU = [];
  UU_l =[];
  UU_c =[];
  
  t_ppp = [];
  t_est = [];
  its_ppp = [];
  its_est = [];
  t_open = [];
  x_nexts = zeros(2*n_x,1);

  ## Initial U is zero
  [n_U,junk] = size(A_u);
  U = zeros(n_U,1);

  ## Create input basis functions
  u_star_tau = ppp_ustar(A_u,1,Tau',0,0,n_u-n_U);
	
  ## Reverse time to get "previous" U
  U_old = U;

  if (extras.simulate==1)
    ## Set up globals for simulation
    system_name_sim = system_name;
    i_ppp_sim = i_ppp;
    x_0_sim = x_0;
    y_sim = [];			# Junk
    u_sim = [];			# Junk
    A_u_sim = A_u;
    simpar_sim = simpar;
    T_total = simpar.last;
  endif
  
  for i = 0:N_ol		# Main loop 
    printf("%i",i);
    if (extras.simulate==1)
      [y_ol,u_ol] = ppp_RT_sim(U); # Simulate
    else
      [y_ol,u_ol] = ppp_RT(U);	# Real thing
    endif

    t_start = time;		# Initialise time

    if (i==0)			# Data is rubbish at i=0 - ignore
      usleep(T_ol_0*1e6);		# Hang about
    else
      ## Set up time information for the gathered data
      n_ol = length(y_ol);	# How many data points?
      t_ol = [0:n_ol-1]'*dt;
      T_ol = n_ol*dt;		# Length of ol interval
      t_open = [t_open;T_ol];

      ## Generate input to actual system
      u_star_t = ppp_ustar(A_u,1,t_ol',0,0,n_u-n_U);

      ## Tune parameters/states
      if (extras.estimate==1)
	## Save up the estimated parameters
	par_est = pars(i_par(:,1));
	p = [p; par_est'];

	## Set up according to interval length
	if (T_ol>T_ol_0) ## Truncate data
	  simpar_est.last = T_ol_0;
	  y_est = y_ol(1:n_t+1,:);
	else
	  simpar_est.last = T_ol;
	  y_est = y_ol;
	endif

	simpar_pred.last = T_ol_0; # Predicted length of next interval
	pars(i_ppp(:,1)) = U_old; # Update the simulation ppp weights
	
	## Optimise
	tick = time;
	[pars,Par,Error,Y,its] = \
	    ppp_optimise(s_system_name,x_0s,pars,simpar_est,u_star_t,y_est,i_par,extras);
	est_time = time-tick;  
	t_est = [t_est;est_time];
	its_est = [its_est; its-1];
      endif

      ## Update internal model
      par(i_ppp(:,3)) = U_old; # Update the simulation ppp weights

      if (extras.estimate==1)
	par(i_par(:,3)) = pars(i_par(:,1)); # Update the simulation params
      endif
      
      simpar_model.last = T_ol;
      [y_model,x_model] = eval(sprintf("%s_sim(x_0_model, par, simpar_model, \
 					       u_star_t);",system_name));

      x_0 = x_model(n_ol+1,:)';	# Initial state of next interval
      x_0_model = x_0;

      ## Compute U by optimisation
      tick = time;

      ## Predict state at start of next interval
      par(i_ppp(:,3)) = U;
      [y_next,x_next] = eval(sprintf("%s_sim(x_0, par, simpar, \
					     u_star_t);",system_name));
      x_next = x_next(n_t+1,:)'; # Initial state for next time
      x_nexts(1:2:(2*n_x)-1) = x_next;
      
      ## Optimize for next interval      
      U_old = U;		# Save previous value
      U = expm(A_u*T_ol)*U;	# Initialise from continuation trajectory
      pars(i_ppp(:,1)) = U;	# Put initial value of U into the parameter vector
      [U, U_all, Error, Y, its] = ppp_nlin(system_name,x_nexts,pars,simpars,u_star_tau,w_s,i_ppp,extras);


      ppp_time = time-tick;  
      t_ppp = [t_ppp;ppp_time];
      its_ppp = [its_ppp; its-1];

      ## Total execution time
      T_total = time - t_start;
      if (extras.simulate==1)&&(extras.emulate_timing!=1)
	printf(".");
	T_diff = 0;		# Always correct interval
      else
	T_diff = T_total - T_ol_0; # Compute difference
	if T_diff<0
	  printf("-");
	  usleep(-T_diff*1e6);
	  T_total = time - t_start;
	else
	  printf("+");
	endif   
				printf("%2.2f",T_total);
      endif
      T_total = simpar.dt*round(T_total/simpar.dt); # Whole no. of intervals

      pars(i_ppp(:,1)) = U;	# Put final value of U into the parameter vector

      ## Save up data
      y_ol = y_ol(1:n_ol,:);
      y = [y; y_ol];
      u = [u; u_ol];
      UU = [UU; U'];
      t = [t; t_ol+t_last*ones(n_ol,1) ];
      t_last = t_last + T_ol;

    endif


    if (extras.simulate==1) # Do the actual simulation
      if (extras.emulate_timing==1) # Emulate timing
	simpar_sim.last = T_total; # simulate for actual execution time
      endif
      ppp_RT_sim_compute (U_old);
    endif
    
  endfor
  printf("\n");
endfunction
