function [y,x,u,t,UU,UU_c,UU_l] = ppp_nlin_sim (system_name,i_ppp,i_par,A_u,w_s,N_ol,extras)

  ## usage:  [y,x,u,t,U,U_c,U_l] = ppp_nlin_sim (system_name,A_u,tau,t_ol,N,w)
  ##
  ## 
  
  ## Simulate nonlinear PPP
  ## Copyright (C) 2000 by Peter J. Gawthrop

  ## Defaults
  if nargin<7
    extras.U_initial = "zero";
    extras.U_next = "continuation";
    extras.criterion = 1e-5;
    extras.max_iterations = 10;
    extras.v = 0.1;
    extras.verbose = 0;
  endif
  
  

  ## Names
  s_system_name = sprintf("s%s", system_name);

  ## System details -- defines simulation within ol interval
  par = eval(sprintf("%s_numpar;", system_name));
  simpar = eval(sprintf("%s_simpar;", system_name));
  x_0 = eval(sprintf("%s_state(par);", system_name));
  [n_x,n_y,n_u] = eval(sprintf("%s_def;", system_name));

  ## Sensitivity system details -- defines moving horizon simulation
  simpars = eval(sprintf("%s_simpar;", s_system_name));
  sympars = eval(sprintf("%s_sympar;", s_system_name));
  pars = eval(sprintf("%s_numpar;", s_system_name));

  ## Times
  ## -- within opt horizon
  n_Tau = round(simpars.last/simpars.dt);
  dtau = simpars.dt;
  Tau = [0:n_Tau-1]'*dtau;
  [n_tau,n_w] = size(w_s);
  tau = Tau(n_Tau-n_tau+1:n_Tau);
  w = w_s(length(w_s));		# Final value of setpoint

  ## -- within ol interval
  n_t = round(simpar.last/simpar.dt);
  dt = simpar.dt;
  t_ol = [0:n_t-1]'*dt;
  T_ol = n_t*dt;

  ## Create input basis functions
  [n_U,junk] = size(A_u);

  ## For moving horizon
  eA = expm(A_u*dtau);
  u_star_i = ones(n_U,1);
  u_star_tau = [];
  for i = 1:n_Tau
    u_star_tau = [u_star_tau; u_star_i'];
    u_star_i = eA*u_star_i;
  endfor

  ## and for actual implementation
  eA = expm(A_u*dt);
  u_star_i = ones(n_U,1);
  u_star_t = [];
  for i = 1:n_t
    u_star_t = [u_star_t; u_star_i'];
    u_star_i = eA*u_star_i;
  endfor
  
  if extras.verbose
    title("U*(tau)")
    xlabel("tau");
    plot(Tau,u_star_tau)
    title("U*(t)")
    xlabel("t_ol");
    plot(t_ol,u_star_t)
  endif
  

  ## Check number of inputs adjust if necessary
  if n_u>n_U
    disp(sprintf("Augmenting inputs with %i zeros", n_u-n_U));
    u_star_tau = [u_star_tau; zeros(n_u-n_U, n_Tau)];
    u_star_t   = [u_star_t; zeros(n_u-n_U, n_t)];
  endif
  
  if n_u<n_U
    error(sprintf("n_U (%i) must be less than or equal to n_u (%i)", \
		  n_U, n_u));
  endif
  
  ## Compute linear gains 
  [A,B,C,D] = eval(sprintf("%s_sm(par);", system_name));
  B = B(:,1); D = D(:,1);
  [k_x,k_w,K_x,K_w] = ppp_lin(A,B,C,D,A_u,0,tau');

  ## Main simulation loop
  y = [];
  x = [];
  u = [];
  t = [];
  t_last = 0;
  UU = [];
  UU_l =[];
  UU_c =[];
  
  x_0s = zeros(2*n_x,1);

  if  strcmp(extras.U_initial,"linear")
    U = K_w*w - K_x*x_0;
  elseif strcmp(extras.U_initial,"zero")
    U = zeros(n_U,1);
  else
    error(sprintf("extras.U_initial = \"%s\" is invalid", extras.U_initial));
  endif

  ## Reverse time to get "previous" U
  U = expm(-A_u*T_ol)*U;

  for i = 1:N_ol		# Main loop 
    ## Compute initial U from linear case
    U_l = K_w*w - K_x*x_0;

    ## Compute initial U  for next time from continuation trajectory
    U_c = expm(A_u*T_ol)*U;

    ## Create sensitivity system state
    x_0s(1:2:2*n_x) = x_0;
    
    ## Set next U (initial value for optimisation)
    if  strcmp(extras.U_next,"linear")
      U = U_l;
    elseif strcmp(extras.U_next,"continuation")
      U = U_c;
    elseif strcmp(extras.U_next,"zero")
      U = zeros(n_U,1);
    else
      error(sprintf("extras.U_next = \"%s\" is invalid", extras.U_next));
    endif
    pars(i_ppp(:,1)) = U;	# Put initial value of U into the parameter vector

    ## Compute U by optimisation
    tick = time;
    if extras.max_iterations>0
      [U, U_all, Error, Y] = ppp_nlin(system_name,x_0s,pars,simpars,u_star_tau,w_s,i_ppp,extras);
      pars(i_ppp(:,1)) = U;	# Put final value of U into the parameter vector
    else
      Error = [];
    endif
    opt_time = time-tick;  
    printf("Optimisation %i took %i iterations and %2.2f sec\n", i, \
	   length(Error), opt_time);
    
    ## Generate control
    u_ol = u_star_t*U;		# Not used - just for show

    ## Simulate system over one ol interval
    [y_ol,ys_ol,x_ol] = eval(sprintf("%s_ssim(x_0s, pars, simpar, u_star_t);", s_system_name));

    x_0  = x_ol(n_t+1,:)';	# Extract state for next time
    y_ol = y_ol(1:n_t,:);	# Avoid extra points due to rounding error 
    x_ol = x_ol(1:n_t,:);	# Avoid extra points due to rounding error 


    y = [y; y_ol];
    x = [x; x_ol];
    u = [u; u_ol];

    UU = [UU; U'];
    UU_l = [UU_l; U_l'];
    UU_c = [UU_c; U_c'];

    t = [t; t_ol+t_last*ones(n_t,1) ];
    t_last = t_last + T_ol; 
  endfor

endfunction

