function [y,u,t,y_e,t_e] = ppp_lin_run (Name,Simulate,ControlType,w,p_c,p_o)

  ## usage:  [y,u,t,y_e,t_e] = ppp_lin_run (Name,Simulate,ControlType,w,p_c,p_o);
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
  
  if nargin<2
    Simulate = 1;
  endif
  
  if nargin<3
    ControlType = 2;
  endif
  
  if nargin<4
    w = 1;
  endif
  
  if nargin<5
    p_c.N = 10;
  endif
  
  if nargin<6
    p_o.sigma = 0.001;
  endif

  if !struct_contains(p_c,"N")
    p_c.N = 10;			# Number of small samples per large sample
  endif
  
  if !struct_contains(p_c,"delta_ol")
    p_c.delta_ol = 1.0;	# OL sample interval
  endif
  
  if !struct_contains(p_c,"T")
    p_c.T = 5.0;			# Last time point.
  endif
  
  if !struct_contains(p_c,"A_w")
    p_c.A_w = 0;
  endif
  
  if !struct_contains(p_c,"A_u")
    p_c.N_u = 3;
    a_u = 2.0;
    p_c.A_u = ppp_aug(p_c.A_w,laguerre_matrix(p_c.N_u-1,a_u));
  endif
  
  [p_c.N_u,M_u] = size(p_c.A_u);
  if (p_c.N_u<>M_u)
    error("A_u must be square");
  endif
  
  ## System
  sys = mtt2sys(Name); # Create system
  [A,B,C,D] = sys2ss(sys);	# SS form
  [n_x, n_u, n_y] = abcddim(A,B,C,D)
  ol_poles = eig(A)

  ## Check w.
  [n_w,m_w] = size(w);
  if ( (n_w<>n_y) || (m_w<>1) )
    error(sprintf("ppp_lin_run: w must a column vector with %i elements",n_y));
  endif
  
  ## Initialise
  x_0 = zeros(n_x,1);
  x_est = x_0;

  ## Initilise simulation state
  x = x_0;
##x(2) = 0.2;		
		#   x(2) = y_0(1);
				#   x(4) = y_0(2);

  if ControlType==0		# Step input
    I = 1;			# 1 large sample
    p_c.delta_ol = p_c.T	# I
    K_w = zeros(p_c.N_u,n_y);
    K_w(1,1) = 1;
    K_w(2,1) = -1;
    K_x = zeros(p_c.N_u,n_x);
    U = K_w*w;			# Initial control U
  else				# PPP control
    I = ceil(p_c.T/p_c.delta_ol); # Number of large samples
    tau = [10:0.1:11]*(2/a_u);	# Time horizons
    [k_x,k_w,K_x,K_w] = ppp_lin(A,B,C,D,p_c.A_u,p_c.A_w,tau); # Design
    U = K_w*w			# Initial control U

    ## Checks
    cl_poles = eig(A - B*k_x)
  endif

  ## Sample times
  dt = 0.1;
  delta = p_c.N*dt;

  ## Observer design
  Ad = expm(A*delta);		# Discrete-time transition matrix
  if (ControlType==2)
    G = eye(n_x);			# State noise gain 
    sigma_x = eye(n_x);		# State noise variance
    Sigma = p_o.sigma*eye(n_y);	# Measurement noise variance
    
    L = dlqe(Ad,G,C,sigma_x,Sigma)
  else
    L = zeros(n_x,n_y);
  endif
  
  obs_poles = eig(Ad-L*C)

  ## Control loop
  y = [];
  u = [];
  t = [];
  y_e = [];
  t_e = [];
  for i=1:I
    i
    if Simulate
      t_sim = [0:p_c.N]*dt;
      [yi,ui,xsi] = ppp_ystar (A,B,C,D,x,p_c.A_u,U,t_sim);
      x = xsi(:,p_c.N+1);
      y_now = yi(:,p_c.N+1);
    else			# The real thing
      to_rt(U');		# Send U
      data = from_rt(p_c.N);	# Receive data
      [yi,ui] = convert_data(data);
      y_now = yi(:,p_c.N);	# Current output
    endif
    

    ## Zero-gain (OL) observer with state resetting
    [x_est y_est] = ppp_int_obs (x_est,y_now,U,A,B,C,D,p_c.A_u,delta,L);
    
				#       ## Reset states
				#       x_est(2) = y_now(1);	# Position
				#       x_est(4) = y_now(2)/g_s;	# Angle 
    
    ##Control
    U = K_w*w- K_x*x_est;

    ## Save
    ti  = [(i-1)*p_c.N:i*p_c.N-1]*dt; 
    t = [t;ti'];
    y = [y;yi(:,1:p_c.N)'];
    u = [u;ui(:,1:p_c.N)'];
    y_e = [y_e; y_est'];
    t_e = [t_e; (i*p_c.N)*dt];
  endfor

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
 				#  figfig("OL_y","eps",boxed,monochrome);
  ylabel("u");
  figure(2);plot(t,u);
 				#  figfig("OL_u","eps",boxed,monochrome);

endfunction