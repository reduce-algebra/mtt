function [y,x,u,t,U,U_c,U_l] = ppp_nlin_sim (system_name,A_u,tau,t_ol,N_ol,w,extras)

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

  ## System details 
  par = eval(sprintf("%s_numpar;", system_name));
  x_0 = eval(sprintf("%s_state;", system_name))
  [n_x,n_y,n_u] = eval(sprintf("%s_def;", system_name));

  ## Sensitivity system details
  sympars = eval(sprintf("%s_sympar;", s_system_name));
  pars = eval(sprintf("%s_numpar;", s_system_name));

  ## Times
  n_tau = length(tau);
  dtau = tau(2)-tau(1);		# Optimisation sample time
  Tau = [0:dtau:tau(n_tau)+eps]; # Time  in the moving axes
  n_Tau = length(Tau);
  dt = t_ol(2)-t_ol(1);
  n_t = length(t_ol);
  T_ol = t_ol(n_t)+dt
  

  ## Weight and moving-horizon setpoint
  weight = [zeros(n_y,n_Tau-n_tau), ones(n_y,n_tau)]; 
  ws = w*ones(1,n_tau);

  ## Create input basis functions
  [n_U,junk] = size(A_u);

  ## For moving horizon
  eA = expm(A_u*dtau);
  u_star_i = ones(n_U,1);
  u_star_tau = [];
  for i = 1:n_Tau
    u_star_tau = [u_star_tau, u_star_i];
    u_star_i = eA*u_star_i;
  endfor

  ## and for actual implementation
  eA = expm(A_u*dt);
  u_star_i = ones(n_U,1);
  u_star_t = [];
  for i = 1:n_t
    u_star_t = [u_star_t, u_star_i];
    u_star_i = eA*u_star_i;
  endfor
  
  if extras.verbose
    title("U*(tau)")
    xlabel("tau");
    plot(Tau,u_star_tau)
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
		  
  ## Indices of U and sensitivities
  FREE = "[";
  free_name = "ppp";
  for i=1:n_U
    FREE = sprintf("%ssympars.%s_%i sympars.%s_%is", FREE, free_name, \
		   i, free_name, i);
    if i<n_U
      symbol = "; ";
    else
      symbol = "];";
    endif
    FREE = sprintf("%s%s", FREE, symbol);
  endfor
FREE
  free = eval(FREE);

  ## Compute linear gains 
  [A,B,C,D] = eval(sprintf("%s_sm(par);", system_name));
  B = B(:,1); D = D(:,1);
  [k_x,k_w,K_x,K_w] = ppp_lin(A,B,C,D,A_u,0,tau);

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

  for i = 1:N_ol
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
    ## Put initial value of U into the parameter vector
    pars(free(:,1)) = U;

    ## Compute U
    tick = time;
    if extras.max_iterations>0
      [U, U_all, Error, Y] = ppp_nlin(s_system_name,x_0s,u_star_tau,tau,pars,free,ws,extras);
    else
      Error = [];
    endif
    opt_time = time-tick;  
    printf("Optimisation %i took %i iterations and %2.2f sec\n", i, \
	   length(Error), opt_time);
#     title(sprintf("Moving horizon trajectories: Interval %i",i));
#     grid;
#     plot(tau,Y)
  
    ## Generate control

    u_ol = U'*u_star_t(1:n_U,:);

    ## Simulate system 
    ## (Assumes that first gain parameter is one)
    U_ol = [u_ol; zeros(n_u-1,n_t)]; # Generate the vector input
    [y_ol,x_ol] = eval(sprintf("%s_sim(x_0, U_ol, t_ol, par);", system_name));

    ## Extract state for next time
    x_0  = x_ol(:,n_t);

    y = [y y_ol(:,1:n_t)];
    x = [x x_ol(:,1:n_t)];
    u = [u u_ol(:,1:n_t)];

    UU = [UU, U];
    UU_l = [UU_l, U_l];
    UU_c = [UU_c, U_c];

    t = [t, t_ol(:,1:n_t)+t_last*ones(1,n_t) ];
    t_last = t_last + t_ol(n_t); 
  endfor

  ## Rename returned matrices
  U = UU;
  U_l = UU_l;
  U_c = UU_c;
endfunction





