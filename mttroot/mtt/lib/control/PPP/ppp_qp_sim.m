function [T,y,u,X,Iterations] = ppp_qp_sim (A,B,C,D,A_u,A_w,t,Q,R,P,\
					    Tau_u,Min_u,Max_u,Order_u, \
					    Tau_y,Min_y,Max_y,Order_y, \
					    W,x_0,Delta_ol,mu,test,movie)

  ## usage: [T,y,u,J] = ppp_qp_sim (A,B,C,D,A_u,A_w,t,Q, Tau_u,Min_u,Max_u,Order_u, Tau_y,Min_y,Max_y,Order_y, W,x_0,movie)
  ## Needs documentation - see ppp_ex11 for example of use.
  ## OUTPUTS
  ## T: Time vector
  ## y,u,J output, input and cost

  ## Copyright (C) 1999 by Peter J. Gawthrop
  ## 	$Id$	
  
  if nargin<21			# No intermittent control
    Delta_ol = 0;
  endif

  if nargin<22			# Mu
    mu = 0;
  endif

  if nargin<23
    test=0
  endif
  
  if nargin<24			# No movie
    movie = 0;
  endif

test = test
  ## Check some sizes
  [n_x,n_u,n_y] = abcddim(A,B,C,D);

  [n_x0,m_x0] = size(x_0);
  if (n_x0 != n_x)||(m_x0 != 1)
    error(sprintf("Initial state x_0 must be %ix1 not %ix%i",n_x,n_x0,m_x0));
  endif
  
  ## Input constraints 
  [Gamma_u, gamma_u] = ppp_input_constraints(A_u,Tau_u,Min_u,Max_u);

  ## Output constraints
  [Gamma_y,gamma_y] = ppp_output_constraints(A,B,C,D,x_0,A_u,Tau_y,Min_y,Max_y,Order_y);

  ## Composite constraints - t=0
  Gamma = [Gamma_u; Gamma_y];
  gamma = [gamma_u; gamma_y];

  ## Design the controller
  ## disp("Designing controller");
  [k_x,k_w,K_x,K_w,Us0,J_uu,J_ux,J_uw,J_xx,J_xw,J_ww] = ppp_lin (A,B,C,D,A_u,A_w,t,Q,R,P);

  ## Set up various time vectors
  dt = t(2)-t(1);		# Time increment

  ## Make sure Delta_ol is multiple of dt
  Delta_ol = floor(Delta_ol/dt)*dt;

  if Delta_ol>0			# Intermittent control
    T_ol = 0:dt:Delta_ol;	# Create the open-loop time vector
  else
    T_ol = [0,dt];
    Delta_ol = dt;
  endif
  t_last = t(length(t));
  T_cl = 0:Delta_ol:t_last-Delta_ol; # Closed-loop time vector
  T = 0:dt:t_last;		# Overall time vector
 
  ## Lengths thereof
  n_Tcl = length(T_cl);
  n_ol = length(T_ol);
  n_T = length(T);

  ## Expand W with constant last value or truncate
  [n_W,m_W] = size(W);

  if m_W>n_T
    W = W(:,1:n_T);
  else
    W = [W W(:,m_W)*ones(1,n_T-m_W+1)];
  endif

  ## Compute U*
  Ustar_ol = ppp_ustar(A_u,n_u,T_ol); # U* in the open-loop interval

  [n,m] = size(Ustar_ol);
  n_U = m/length(T_ol);		# Determine size of each Ustar

#   ## Discrete-time system
#   csys = ss2sys(A,B,C,D);
#   dsys = c2d(csys,dt);
#   [Ad, Bd] = sys2ss(dsys)

  x = x_0;			# Initialise state

  ## Initialise the saved variable arrays
  X = [];
  u = [];
  Iterations = [];
  du = [];
  J = [];
  tick= time;

  ## disp("Simulating ...");
  for t=T_cl			# Outer loop at Delta_ol

    ##disp(sprintf("Time %g", t));
    ## Output constraints
    [Gamma_y,gamma_y] = ppp_output_constraints  (A,B,C,D,x,A_u,Tau_y,Min_y,Max_y,Order_y);
    
    ## Composite constraints 
    Gamma = [Gamma_u; Gamma_y];
    gamma = [gamma_u; gamma_y];
    
    ## Current Setpoint value
    w = W(:,floor(t/dt)+1);
    
    ## Compute U(t) via QP optimisation
    [uu, U, iterations] = ppp_qp (x,w,J_uu,J_ux,J_uw,Us0,Gamma,gamma,mu,test); # Compute U

    ## Compute the cost (not necessary but maybe interesting)
#    [J_t] = ppp_cost (U,x,W,J_uu,J_ux,J_uw,J_xx,J_xw,J_ww); # cost
#    J = [J J_t];

    ## OL Simulation (exact)
    [ys,us,xs] = ppp_ystar (A,B,C,D,x,A_u,U,T_ol);

    ## Save values (discarding final ones)
    X = [X xs(:,1:n_ol-1)];			# save state
    u = [u us(:,1:n_ol-1)];			# save input
    Iterations = [Iterations iterations*ones(1,n_ol-1)];

    ## Final values
    x = xs(:,n_ol);		# Final state
    ut = us(:,n_ol);		# Final control

  endfor
  
  ## Save the last values
  X = [X x];		# Save state
  u = [u ut];		# Save input
  Iterations = [Iterations iterations]; # Save iteration count

  tock = time;
  Elapsed_Time = tock-tick;
  y = C*X + D*u;		# System output


endfunction



