# function name = ppp_ex20 (ReturnName)

#   ## usage:  name = ppp_ex20 (ReturnName)
#   ##
#   ## PPP example -- a standard multivariable example
#   ## 	$Id$	



#   ## Example name
#   name = "Turbogenerator example:  system TGEN from J.M Maciejowski: Multivariable Feedback Design";

#   if nargin>0
#     return
#   endif
  
  ## System
  [A,B,C,D] = airc;
  [n_x,n_u,n_y] = abcddim(A,B,C,D)

  ## Controller
  t = [9:0.1:10];		# Time horizon
  A_w = zeros(n_y,1);		# Setpoint
  TC = 2*[1 1];		# Time constants for each input
 #  A_u = [];
#   for tc=TC			# Input
#     A_u = [A_u;ppp_aug(laguerre_matrix(3,1/tc), 0)];
#   endfor
 A_u =  ppp_aug(laguerre_matrix(5,1.0), 0);
 Q = [1;1];		# Output weightings

  ## Constraints
  Gamma = [];
  gamma = [];

  ## Constraints - u
  Tau_u = [0 0.1 0.5 1 1.5 2];
  Tau_u = 0;
  one = ones(size(Tau_u));
  limit = 1.5;
  Min_u = -limit*one;
  Max_u =  limit*one;
  Order_u = 0*one;

  ## Constraints - y
  Tau_y = [];
  one = ones(size(Tau_y));
  limit = 1.5; 
  Min_y = -limit*one;
  Max_y =  limit*one;
  Order_y = 0*one;

  ## Simulation
  W=[1;2;3];
  x_0 = zeros(n_x,1);

  ## Constrained - open-loop
  disp("Control design");
  [k_x,k_w,K_x,K_w,Us0,J_uu,J_ux,J_uw] = ppp_lin  (A,B,C,D,A_u,A_w,t); # Unconstrained design
  [Gamma_u,gamma_u] = ppp_input_constraint (A_u,Tau_u,Min_u,Max_u);

  Gamma = Gamma_u;
  gamma = gamma_u;

  disp("Open-loop simulations");
  ## Constrained OL simulation
  [u,U] = ppp_qp (x_0,W,J_uu,J_ux,J_uw,Us0,Gamma,gamma);
  T = [0:t(2)-t(1):t(length(t))];
  [ys,us] = ppp_ystar (A,B,C,D,x_0,A_u,U,T);

  ## Unconstrained OL simulation
  [uu,Uu] = ppp_qp (x_0,W,J_uu,J_ux,J_uw,Us0,[],[]);
  [ysu,usu] = ppp_ystar (A,B,C,D,x_0,A_u,Uu,T);

  title("Constrained and unconstrained y*");
  xlabel("t");
  grid;
  plot(T,ys,T,ysu)

  ## Non-linear - closed-loop
  disp("Closed-loop simulation");
  [T1,y,u,J] = ppp_qp_sim (A,B,C,D,A_u,A_w,t,Q, \
			   Tau_u,Min_u,Max_u,Order_u, \
			   Tau_y,Min_y,Max_y,Order_y,W,x_0);

  title("y,y*,u and u*");
  xlabel("t");
  grid;
  plot(T1,y,T,ys,T1,u,T,us);


#endfunction
