function [y,u,t,y_e,t_e,e_e] = ppp_lin_run (Name,Simulate,ControlType,w,x_0,p_c,p_o)

  ## usage:  [y,u,t,y_e,t_e,e_e] = ppp_lin_run (Name,Simulate,ControlType,w,x_0,p_c,p_o);
  ##
  ## 
  ## Linear closed-loop PPP of lego system (and simulation)
  ##
  ## Name: Name of system (in mtt terms)
  ## Simulate = 0: real thing
  ## Simulate = 1: simulate
  ## Control = 0:  step test
  ## Control = 1:  PPP open-loop
  ## Control = 2:  PPP closed-loop
  ## w is the (constant) setpoint
  ## par_control and par_observer are structures containing parameters
  ## for the observer and controller

  ##Defaults
  if nargin<1			# Default name to dir name
    names = split(pwd,"/");
    [n_name,m_name] = size(names);
    Name = deblank(names(n_name,:));
  endif

  ## System
  sys = mtt2sys(Name);		# Create system
  [A,B,C,D] = sys2ss(sys);	# SS form
  [n_x, n_u, n_y] = abcddim(A,B,C,D); # Dimensions
  
  if nargin<2
    Simulate = 1;
  endif
  
  if nargin<3
    ControlType = 2;
  endif
  
  if nargin<4
    w = ones(n_y,1);;
  endif
  
  if nargin<5
    x_0 = zeros(n_x,1);
  endif
  
  if nargin<6
    p_c.N = 10;
  endif

  if nargin<7
    p_o.sigma = 1e-1;
  endif

  if !struct_contains(p_c,"delta_ol")
    p_c.delta_ol = 1.0;	# OL sample interval
  endif
  
  if !struct_contains(p_c,"T")
    p_c.T = 10.0;			# Last time point.
  endif
  
  if !struct_contains(p_c,"Method")
    p_c.Method = "lq";
  endif

  if struct_contains(p_c,"Method")
    if strcmp(p_c.Method,"lq") 
      p_c.Q = eye(n_y);
      p_c.R = (0.5^2)*eye(n_u);
      p_c.N_u = n_x;
    elseif strcmp(p_c.Method,"original");
      if !struct_contains(p_c,"A_w")
	p_c.A_w = 0;
      endif
      if !struct_contains(p_c,"A_u")
	p_c.N_u = n_x;
	a_u = 1.0;
	p_c.A_u = laguerre_matrix(p_c.N_u,a_u)
      endif
    else
      error(sprintf("Method %s not recognised", p_c.Method));
    endif
  endif
  
  if !struct_contains(p_o,"x_0")
    p_o.x_0 = zeros(n_x,1);
  endif
  

  ## Check w.
  [n_w,m_w] = size(w);
  if ( (n_w<>n_y) || (m_w<>1) )
    error(sprintf("ppp_lin_run: w must a column vector with %i elements",n_y));
  endif
  
  ## Initialise
  x_est = p_o.x_0;

  ## Initilise simulation state
  x = x_0;

  if ControlType==0		# Step input
    I = 1;			# 1 large sample
    p_c.delta_ol = p_c.T	# I
    K_w = zeros(p_c.N_u,n_y);
    K_w(1,1) = 1;
    K_w(2,1) = -1;
    K_x = zeros(p_c.N_u,n_x);
    U = K_w*w;			# Initial control U
  else
    I = ceil(p_c.T/p_c.delta_ol) # Number of large samples
    if strcmp(p_c.Method, "original")
      tau = [10:0.1:11]*(2/a_u);	# Time horizons
      [k_x,k_w,K_x,K_w] = ppp_lin(A,B,C,D,p_c.A_u,p_c.A_w,tau); # Design
    elseif strcmp(p_c.Method, "lq") # LQ design
      tau = [0:0.001:1.0]*5; # Time horizons
      [k_x,k_w,K_x,K_w,Us0,J_uu,J_ux,J_uw,J_xx,J_xw,J_ww,y_u,p_c.A_u] \
	  = ppp_lin_quad (A,B,C,D,tau,p_c.Q,p_c.R);
    else
      error(sprintf("Method %s not recognised", p_c.Method));
    endif

    ##Sanity check A_u
    [p_c.N_u,M_u] = size(p_c.A_u);
    if (p_c.N_u<>M_u)
      error("A_u must be square");
    endif
    
    
    U = K_w*w;			# Initial control U

    ## Checks
    [ol_zeros, ol_poles] = sys2zp(sys)
    cl_poles = eig(A - B*k_x)
  endif

  ## Observer design
  Ad = expm(A*p_c.delta_ol);		# Discrete-time transition matrix
  if (ControlType==2)		# 
    G = eye(n_x);		# State noise gain 
    sigma_x = eye(n_x);		# State noise variance
    Sigma = p_o.sigma*eye(n_y);	# Measurement noise variance
    
    [L, M, P, obs_poles] = dlqe(Ad,G,C,sigma_x,Sigma);
  else
    L = zeros(n_x,n_y);
    obs_poles = eig(Ad);
  endif
  
  ## Display the poles
  obs_poles

  ## Short sample interval
  dt = p_c.delta_ol/p_c.N;

  ## Write the include file for the real-time function
  ## Use double length to allow for overuns
  disp("Writing Ustar.h");
  overrun = 2;
  ppp_ustar2h(ppp_ustar (p_c.A_u, n_u, [0:dt:overrun*p_c.delta_ol], 0,0)); 


  ## Control loop
  y = [];
  u = [];
  t = [];
  y_e = [];
  t_e = [];
  e_e = [];
  tick = time;
  for i=1:I
    i
    tim=time;			# Timing
    if Simulate			# Exact simulation 
      t_sim = [0:p_c.N]*dt;	# Simulation time points
      [yi,ui,xsi] = ppp_ystar(A,B,C,D,x,p_c.A_u,U,t_sim); # Simulate
      x = xsi(:,p_c.N+1);	# Current state (for next time)
      y_now = yi(:,p_c.N+1);	# Current output
    else			# The real thing
      to_rt(U');		# Send U
      data = from_rt(p_c.N);	# Receive data
      [yi,ui] = convert_data(data); # And convert from integer format
      y_now = yi(:,p_c.N);	# Current output
    endif

    ## Observer
    [x_est y_est e_est] = ppp_int_obs (x_est,y_now,U,A,B,C,D,p_c.A_u,p_c.delta_ol,L);
    
    ##Control
    U = K_w*w - K_x*x_est;

    ## Save data
    ti  = [(i-1)*p_c.N:i*p_c.N-1]*dt; 
    t = [t;ti'];
    y = [y;yi(:,1:p_c.N)'];
    u = [u;ui(:,1:p_c.N)'];
    y_e = [y_e; y_est'];
    t_e = [t_e; (i*p_c.N)*dt];
    e_e = [e_e; e_est];
    sample_time = (time-tim)/p_c.N
    dt
  endfor			# Main loop
  
  sample_interval = (time-tick)/(I*p_c.N)

  ## Put data on file (so can use for identification)
  filename = sprintf("%s_ident_data.dat",Name);
  eval(sprintf("save -ascii %s t y u",filename));


  ## Plot
  gset nokey
  title("");
  boxed=0;
  monochrome=1;
  grid;
  xlabel("t");

  ylabel("y");
  figure(1);plot(t,y, t_e,y_e,"+");

  ylabel("u");
  figure(2);plot(t,u);

  ylabel("e");
  figure(3);plot(t_e,e_e);


endfunction