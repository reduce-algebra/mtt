function [name,T,y,u,J] = ppp_ex6 (ReturnName)

  ## usage:  [name,T,y,u,J] = ppp_ex6 (ReturnName)
  ##
  ## PPP example -- PPP for redundant actuation
  ## 	$Id$	


  ## Example name
  name = "Two input-one output system with input constraints";

  if nargin>0
    return
  endif
  
  ## System
  A = 0;
  B = [0.5 1];
  C = 1;
  D = [0 0];
  [n_x,n_u,n_y] = abcddim(A,B,C,D)

  ## Controller
  t = [4:0.1:5];		# Time horizon
  A_w = 0;			# Setpoint
  A_u = [-2;-0.5];		# Input
  Q = 1;			# Output weight

  ## Constrain  input 1 at time tau=0
  Tau = 0;
  Max = 1;
  Min = -Max;
  Order = 0;
  i_u = 1;
  
  ## Simulation
  W=1;
  x_0 = 0;

  ## Linear
  [ol_poles,cl_poles,ol_zeros,cl_zeros,k_x,k_w] = ppp_lin_plot (A,B,C,D,A_u,A_w,t);
  
  ## Non-linear
  movie = 0;
  [T,y,u,J] = ppp_qp_sim (A,B,C,D,A_u,A_w,t,Q, Tau,Min,Max,Order, \
	      [],[],[],[], W,x_0);
  title("y,u_1,u_2");
  xlabel("t");
  grid;
  plot(T,y,T,u);

endfunction



