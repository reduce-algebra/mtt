function [name,T,y,u,ys,us,J] = ppp_ex19 (ReturnName,n_extra,T_extra)

  ## usage:   [name,T,y,u,ys,us,T1,du,dus] = ppp_ex19 (ReturnName)
  ##
  ## PPP example

  ## 	$Id$	


  ## Example name
  name = "Input constraints with redundant U*";

  if (nargin>0)&&(ReturnName==1)
    return
  endif


  if nargin<2
    n_extra = 3
  endif
  
  if nargin<3
    T_extra = 2.0
  endif
  

  ## System
  A = 1
  B = 1
  C = 1
  D = 0;
  [n_x,n_u,n_y] = abcddim(A,B,C,D);

  ## Controller
  t = [2:0.01:3];		# Time horizon
  A_w = 0;
  A_u = diag([0  -6]);
  A_u = ppp_aug(A_u,laguerre_matrix(n_extra,1/T_extra))
  Q = 1;
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
  W=1;
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
endfunction






