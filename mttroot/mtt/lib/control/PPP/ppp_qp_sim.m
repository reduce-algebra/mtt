function [T,y,u,J] = ppp_qp_sim (A,B,C,D,A_u,A_w,t,Q, Tau_u,Min_u,Max_u,Order_u, Tau_y,Min_y,Max_y,Order_y, W,x_0,Delta_ol,movie)

  ## usage: [T,y,u,J] = ppp_qp_sim (A,B,C,D,A_u,A_w,t,Q, Tau_u,Min_u,Max_u,Order_u, Tau_y,Min_y,Max_y,Order_y, W,x_0,movie)
  ## Needs documentation - see ppp_ex11 for example of use.
  ## OUTPUTS
  ## T: Time vector
  ## y,u,J output, input and cost

  ## Copyright (C) 1999 by Peter J. Gawthrop
  ## 	$Id$	
  
  if nargin<19			# No intermittent control
    Delta_ol = 0;
  endif

  if nargin<20			# No movie
    movie = 0;
  endif

  ## Check some sizes
  [n_x,n_u,n_y] = abcddim(A,B,C,D);

  [n_x0,m_x0] = size(x_0);
  if (n_x0 != n_x)||(m_x0 != 1)
    error(sprintf("Initial state x_0 must be %ix1 not %ix%i",n_x,n_x0,m_x0));
  endif
  
  ## Input constraints (assume same on all inputs)
  Gamma_u=[];
  gamma_u=[];
  for i=1:n_u
    [Gamma_i,gamma_i] = ppp_input_constraint (A_u,Tau_u,Min_u,Max_u,Order_u,i,n_u);
    Gamma_u = [Gamma_u; Gamma_i];
    gamma_u = [gamma_u; gamma_i];
  endfor

  ## Output constraints
  [Gamma_y,gamma_y] = ppp_output_constraint  (A,B,C,D,x_0,A_u,Tau_y,Min_y,Max_y,Order_y);

  ## Composite constraints - t=0
  Gamma = [Gamma_u; Gamma_y];
  gamma = [gamma_u; gamma_y];

  ## Design the controller
  disp("Designing controller");
  [k_x,k_w,K_x,K_w,Us0,J_uu,J_ux,J_uw,J_xx,J_xw,J_ww] = ppp_lin (A,B,C,D,A_u,A_w,t,Q);

  ## Set up various time vectors
  dt = t(2)-t(1);		# Time increment

  ## Make sure Delta_ol is multiple of dt
  Delta_ol = floor(Delta_ol/dt)*dt

  if Delta_ol>0			# Intermittent control
    T_ol = 0:dt:Delta_ol-dt;	# Create the open-loop time vector
  else
    T_ol = 0;
    Delta_ol = dt;
  endif
  
  T_cl = 0:Delta_ol:t(length(t))-Delta_ol; # Closed-loop time vector
  n_Tcl = length(T_cl);
  
  Ustar_ol = ppp_ustar(A_u,n_u,T_ol); # U* in the open-loop interval
  [n,m] = size(Ustar_ol);
  n_U = m/length(T_ol);		# Determine size of each Ustar

  ## Discrete-time system
  csys = ss2sys(A,B,C,D);
  dsys = c2d(csys,dt);
  [Ad, Bd] = sys2ss(dsys);

  x = x_0;			# Initialise state

  ## Initialise the saved variable arrays
  X = [];
  u = [];
  du = [];
  J = [];
  tick= time;
  i = 0;
  disp("Simulating ...");
  for t=T_cl			# Outer loop at Delta_ol
    ##disp(sprintf("Time %g", t));
    ## Output constraints
    [Gamma_y,gamma_y] = ppp_output_constraint  (A,B,C,D,x,A_u,Tau_y,Min_y,Max_y,Order_y);
    
    ## Composite constraints 
    Gamma = [Gamma_u; Gamma_y];
    gamma = [gamma_u; gamma_y];
    
    ## Compute U(t)
    [uu U] = ppp_qp (x,W,J_uu,J_ux,J_uw,Us0,Gamma,gamma); # Compute U
 
    ## Compute the cost (not necessary but maybe interesting)
#    [J_t] = ppp_cost (U,x,W,J_uu,J_ux,J_uw,J_xx,J_xw,J_ww); # cost
#    J = [J J_t];

    ## Simulation loop
    i_ol = 0;
    for t_ol=T_ol		# Inner loop at dt

      ## Compute ol control
      i_ol = i_ol+1;
      range = (i_ol-1)*n_U + 1:i_ol*n_U; # Extract current U*
      ut = Ustar_ol(:,range)*U;	# Compute OL control (U* U)

      ## Simulate the system
      i = i+1;
      X = [X x];		# Save state
      u = [u ut];		# Save input
      x = Ad*x + Bd*ut;	# System

#       if movie			# Plot the moving horizon
# 	tau = T(1:n_T-i);	# Tau with moving horizon
# 	tauT = T(i+1:n_T);	# Tau with moving horizon + real time
# 	[ys,us,xs,xu,AA] = ppp_ystar (A,B,C,D,x,A_u,U,tau); # OL response
# 	plot(tauT,ys, tauT(1), ys(1), "*")
#       endif
    endfor
  endfor
  
  ## Save the last values
  X = [X x];		# Save state
  u = [u ut];		# Save input

  tock = time;
  Iterations = length(T_cl)
  Elapsed_Time = tock-tick
  y = C*X + D*u;		# System output

  T = 0:dt:t+Delta_ol;		# Overall time vector

endfunction



