function [t,y,u,X_est,y_c,t_e,y_e,e_e,p_c,p_o] = ppp_lin_run (Name,Simulate,ControlType,w,x_0,p_c,p_o)

  ## usage: [t,y,u,y_c,t_e,y_e,e_e,p_c,p_o] = ppp_lin_run (Name,Simulate,ControlType,w,x_0,p_c,p_o)
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

  disp("Special version");

  ##Defaults
  if nargin<1			# Default name to dir name
    names = split(pwd,"/");
    [n_name,m_name] = size(names);
    Name = deblank(names(n_name,:));
  endif

  if nargin<6
    p_c.N = 50;
  endif

  if nargin<7
    p_o.sigma = 1e-1;
  endif

  ## System
  sys = mtt2sys(Name);		# Create system
  [A,B,C_0,D_0] = sys2ss(sys);	# SS form
  [n_x, n_u, n_y] = abcddim(A,B,C_0,D_0);

  ## Extract matrices for controlled and constrained outputs.
  if !struct_contains(p_c,"I_0") # Indices for controlled outputs
    p_c.I_0 = 1:n_y
  endif
  if !struct_contains(p_c,"I_1") # Indices for constrained outputs
    p_c.I_1 = 1:n_y
  endif

  C = C_0(p_c.I_0,:)
  C_c = C_0(p_c.I_1,:);
  D = D_0(p_c.I_0,:);
  D_c = D_0(p_c.I_1,:);
  [n_x, n_u, n_y] = abcddim(A,B,C,D); # Dimensions
  [n_x, n_u, n_y_c] = abcddim(A,B,C_c,D_c); # Dimensions


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
  
  if !struct_contains(p_c,"delta_ol")
    p_c.delta_ol = 0.5;	# OL sample interval
  endif
  
  if !struct_contains(p_c,"T")
    p_c.T = 10;			# Last time point.
  endif

  if !struct_contains(p_c,"Iterations")
    p_c.Iterations = 5;		# Number of interations, total =T*Iterations
  endif

  if !struct_contains(p_c,"augment")
    p_c.augment = 0;		# Augment basis funs with constant
  endif
  
  if !struct_contains(p_c,"integrate")
    p_c.integrate = 0;		
  endif
  
  if !struct_contains(p_c,"Tau_u")
    p_c.Tau_u = [];
    p_c.Min_u = [];
    p_c.Max_u = [];
  endif

  if !struct_contains(p_c,"Tau_y")
    p_c.Tau_y = [];
    p_c.Min_y = [];
    p_c.Max_y = [];
  endif


  if !struct_contains(p_c,"Method")
    p_c.Method = "lq";
  endif

  if struct_contains(p_c,"Method")
    if strcmp(p_c.Method,"lq")
      p_c.Q = eye(n_y);
      p_c.n_U = n_x;
      if !struct_contains(p_c,"R")
	p_c.R = (0.1^2)*eye(n_u);
      endif
    elseif strcmp(p_c.Method,"original");
      if !struct_contains(p_c,"A_w")
	p_c.A_w = 0;
      endif
      if !struct_contains(p_c,"A_u")
	p_c.n_U = n_x;
	a_u = 2.0;
	p_c.A_u = laguerre_matrix(p_c.n_U,a_u);
	if p_c.augment		# Put in constant term
	  p_c.A_u = ppp_aug(0,p_c.A_u);
	endif
      endif
    else
      error(sprintf("Method %s not recognised", p_c.Method));
    endif
  endif

  if !struct_contains(p_c,"tau") # Time horizon
    if strcmp(p_c.Method,"lq")
      p_c.tau = [0:0.1:1]*2;
    elseif strcmp(p_c.Method,"original");
      p_c.tau = [10:0.1:11];
    else
      error(sprintf("Method %s not recognised", p_c.Method));
    endif
  endif
  
  if !struct_contains(p_c,"A_e")
    p_c.A_e = [];			# No extra modes
  endif

  if !struct_contains(p_o,"x_0")
    p_o.x_0 = zeros(n_x,1);
  endif
  
  if !struct_contains(p_o,"method")
    ##p_o.method = "continuous";
    ##p_o.method = "intermittent";
    p_o.method = "remote";
  endif
  
  ## Check w.
  [n_w,m_w] = size(w);
  if ( (n_w!=n_y) || (m_w!=1) )
    error(sprintf("ppp_lin_run: w must a column vector with %i elements",n_y));
  endif
  
  ## Initialise
  x_est = p_o.x_0;

  ## Initialise simulation state
  x = x_0;
  y_i = C*x_0

  if ControlType==0		# Step input
    I = 1;			# 1 large sample
    p_c.delta_ol = p_c.T;	# I
    K_w = zeros(p_c.n_U,n_y);
    K_w(1,1) = 1;
    K_w(2,1) = -1;
    K_x = zeros(p_c.n_U,n_x);
  else
    I = ceil(p_c.T/p_c.delta_ol) # Number of large samples
    if strcmp(p_c.Method, "original")
      [k_x,k_w,K_x,K_w,Us0,J_uu,J_ux,J_uw,J_xx,J_xw,J_ww] =\
	  ppp_lin(A,B,C,D,p_c.A_u,p_c.A_w,p_c.tau); # Design
    elseif strcmp(p_c.Method, "lq") # LQ design
      [k_x,k_w,K_x,K_w,Us0,J_uu,J_ux,J_uw,J_xx,J_xw,J_ww,A_u] \
	  = ppp_lin_quad (A,B,C,D,p_c.tau,p_c.Q,p_c.R,p_c.A_e);
      p_c.A_u = A_u;
    else
      error(sprintf("Control method %s not recognised", p_c.Method));
    endif

    ##Sanity check A_u
    [p_c.n_U,M_u] = size(p_c.A_u);
    if (p_c.n_U!=M_u)
      error("A_u must be square");
    endif

    ## Checks
    cl_poles = eig(A - B*k_x)
    ol_poles = eig(A)
    t_max = 1/min(abs(cl_poles));
    t_min = 1/max(abs(cl_poles));
  endif
  
  ## Initial control U
  U = zeros(p_c.n_U,1)	;

  ## Short sample interval
  dt = p_c.delta_ol/p_c.N;

  ## Observer design
  G = eye(n_x);		# State noise gain 
  sigma_x = eye(n_x);		# State noise variance
  Sigma = p_o.sigma*eye(n_y)	# Measurement noise variance
  
  if strcmp(p_o.method, "intermittent")
    Ad = expm(A*p_c.delta_ol);		# Discrete-time transition matrix
    if (ControlType==2)		# 
      [L, M, P, obs_poles] = dlqe(Ad,G,C,sigma_x,Sigma);
    else
      L = zeros(n_x,n_y);
      obs_poles = eig(Ad);
    endif
  elseif strcmp(p_o.method, "continuous")
    Ad = expm(A*dt);		# Discrete-time transition matrix
    A_ud = expm(p_c.A_u*dt);	# Discrete-time input transition
    if (ControlType==2)		# 
      [L, M, P, obs_poles] = dlqe(Ad,G,C,sigma_x,Sigma);
    else
      L = zeros(n_x,n_y);
      obs_poles = eig(Ad);
    endif
  elseif strcmp(p_o.method, "remote")
    L = zeros(n_x,n_y);
    obs_poles = [];
  else
    error(sprintf("Observer method ""%s"" unknown", p_o.method));
  endif
  
  ## Display the poles
  obs_poles

  ## Write the include file for the real-time function
  ## Use double length to allow for overuns
  overrun = 2;
  Ustar = ppp_ustar (p_c.A_u, n_u, [0:dt:overrun*p_c.delta_ol], 0,0);
  if p_c.integrate		# Integrate Ustar
    disp("Integrating Ustar");
    Ustar = cumsum(Ustar)*dt;
  endif
  
  disp("Writing Ustar.h ...");
  ppp_ustar2h(Ustar); 
  disp("done.");


  ## Control loop
  y = [];
  y_c = [];
  u = [];
  t = [];
  y_e = [];
  X_est = [];
  t_e = [];
  e_e = [];
  tick = time;
  i=0;

  for j=1:p_c.Iterations
    for k=1:I
      tim=time;			# Timing
      i++;

      if Simulate		# Exact simulation 
	X = x;			# Current (simulated) state
      else			# The real thing
	if strcmp(p_o.method, "remote")
	  [t_i,y_i,u_i,X] = ppp_put_get_X(U); # Remote-state interface
	else
	  [t_i,y_i,u_i] = ppp_put_get(U); # Generic interface to real-time
	endif
      endif
      
      ## Observer
      if strcmp(p_o.method, "intermittent")
	[x_est y_est y_new, e_est] = ppp_int_obs \
	    (x_est,y_i,U,A,B,C,D,p_c.A_u,p_c.delta_ol,L);
      elseif strcmp(p_o.method, "continuous")
	Ui = U;			# U at sub intervals
	for k = 1:p_c.N
	  [x_est y_est y_new e_est] = ppp_int_obs \
	      (x_est,yi(:,k),Ui,A,B,C,D,p_c.A_u,dt,L);
	  Ui = A_ud'*Ui;
	  y_e = [y_e; y_new'];
	  e_e = [e_e; e_est'];
	endfor
      elseif strcmp(p_o.method, "remote")
	## predict from remote state (with zero L)	
	if (ControlType==2)	# Closed-loop
    	  [x_est y_est y_new e_est] = ppp_int_obs \
    	      (X,y_i,U,A,B,C,D,p_c.A_u,p_c.delta_ol,zeros(n_x,1));
	##  x_est = X; y_est=y_i; y_new=y_i; e_est=0;
	else			# Open-loop
	  [x_est y_est y_new e_est] = ppp_int_obs \
	      (x_est,y_i,U,A,B,C,D,p_c.A_u,p_c.delta_ol,zeros(n_x,1));
	endif
      endif
      
      ## Simulation (based on U_i)
      if Simulate
	t_sim = [1:p_c.N]*dt;	# Simulation time points
	[yi,ui,xsi] = ppp_ystar(A,B,C,D,x,p_c.A_u,U,t_sim); # Simulate
	x = xsi(:,p_c.N);	# NEXT state
	ti  = [(i-1)*p_c.N:i*p_c.N-1]*dt; 
	y_i = yi(1);	# Current output
	t_i = ti(1);
      endif

      ##Control
      if ( length(p_c.Tau_u)==0&&length(p_c.Tau_y)==0 )
	U = K_w*w - K_x*x_est;
      else
	## Input constraints 
	[Gamma_u, gamma_u] = \
	    ppp_input_constraints(p_c.A_u,p_c.Tau_u,p_c.Min_u,p_c.Max_u);
	
	## Output constraints
	[Gamma_y,gamma_y] = \
	    ppp_output_constraints(A,B,C_c,D_c,x_est,p_c.A_u,\
				   p_c.Tau_y,p_c.Min_y,p_c.Max_y);
	
	## Composite constraints - t=0
	Gamma = [Gamma_u; Gamma_y];
	gamma = [gamma_u; gamma_y];
	
	[u_qp,U,n_active] = ppp_qp \
	    (x_est,w,J_uu,J_ux,J_uw,Us0,Gamma,gamma,1e-6,1);
      endif

      ## Allow for the delay
      ##U = expm(p_c.delta_ol*p_c.A_u)*U;

      ## Save data
      if Simulate
	t = [t;ti'];
	y = [y;yi'];
	X_est = [X_est;x_est'];
	y_c = [y_c;(C_c*xsi)'];
	u = [u;ui'];
      else
	t = [t;t_i];
	y = [y;y_i'];
	X_est = [X_est;x_est'];
	u = [u;u_i'];
      endif

      if strcmp(p_o.method, "intermittent")||strcmp(p_o.method, "remote")
	y_e = [y_e; y_new'];
	e_e = [e_e; e_est'];
	t_e = [t_e; t_i];
      endif
      if !Simulate
	delta_comp = time-tim;
	usleep(floor(1e6*(p_c.delta_ol-delta_comp-0.01)));
      endif
      
    endfor			# Main loop
    w = -w;
  endfor 			# Outer loop
  if !Simulate
    ppp_put_get(0*U); 		# Reset to zero
  endif

  
  if strcmp(p_o.method, "continuous")
    t_e = t;
  endif
  
  
  average_ol_sample_interval = (time-tick)/i

  ## Put data on file (so can use for identification)
  filename = sprintf("%s_ident_data.dat",Name);
  eval(sprintf("save -ascii %s t y u",filename));

endfunction