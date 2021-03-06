function [name,T,y,u,ys,us,ysu,usu,J] = ppp_ex17 (ReturnName)

  ## usage:   [name,T,y,u,ys,us,ysu,usu,J] = ppp_ex17 (ReturnName)
  ##
  ## PPP example - shows output constraints on nonlinear system
  ## 	$Id$	


  ## Example name
  name = "Output constraints -0.1 on y* at tau=0.1,0.5,1,2 - intermittent control";

  if nargin>0
    if ReturnName
      return
    endif
  endif
  
  ## System
  A = [-3 -3  -1
       1  0  0
       0  1  0];
  B = [1 
       0 
       0];
  C = [0 -0.5  1];
  D = 0;
  [n_x,n_u,n_y] = abcddim(A,B,C,D)

  ## Controller
  t = [9:0.02:10];		# Time horizon
  A_w = 0;			# Setpoint
  A_u = ppp_aug(laguerre_matrix(3,2.0), A_w); # Input functions
  Q = ones(n_y,1);;

  ## Constraints - u
  Tau_u = [];
  one = ones(size(Tau_u));
  limit = 3;
  Min_u = -limit*one;
  Max_u =  limit*one;
  Order_u = 0*one;

  ## Constraints - y
  Tau_y = [0.1 0.5 1 2]
  one = ones(size(Tau_y));
  Min_y =  -0.01*one; # Min_y(5) = 0.99;
  Max_y =  1e5*one;   # Max_y(5) = 1.01;
  Order_y = 0*one;

  ## Simulation
  W=1;
  x_0 = zeros(3,1);

  ## Constrained - open-loop
  [k_x,k_w,K_x,K_w,Us0,J_uu,J_ux,J_uw] = ppp_lin  (A,B,C,D,A_u,A_w,t,Q); # Unconstrained design
  [Gamma_u,gamma_u] = ppp_input_constraint (A_u,Tau_u,Min_u,Max_u);
  [Gamma_y,gamma_y] = ppp_output_constraint  (A,B,C,D,x_0,A_u,Tau_y,Min_y,Max_y,Order_y);

  Gamma = [Gamma_u; Gamma_y];
  gamma = [gamma_u; gamma_y];

  ## Constrained OL simulation
  [u,U] = ppp_qp (x_0,W,J_uu,J_ux,J_uw,Us0,Gamma,gamma);
  T = [0:t(2)-t(1):t(length(t))];

  ## OL solution
  [ys,us] = ppp_ystar (A,B,C,D,x_0,A_u,U,T);

  ## Unconstrained OL simulation
  [uu,Uu] = ppp_qp (x_0,W,J_uu,J_ux,J_uw,Us0,[],[]);
  [ysu,usu] = ppp_ystar (A,B,C,D,x_0,A_u,Uu,T);

  title("Constained and unconstrained y*");
  xlabel("t");
  grid;
  figure(1);
  plot(T,ys,"-;y* (constrained);", T,ysu,"--;y* (unconstrained);")

  ## Non-linear - closed-loop
  delta_ol = 0.1; mu = 1e-4;
  [T,y,u,J] = ppp_qp_sim (A,B,C,D,A_u,A_w,t,Q, \
			  Tau_u,Min_u,Max_u,Order_u, \
			  Tau_y,Min_y,Max_y,Order_y,W,x_0,delta_ol,mu);

  title("y and u");
  xlabel("t");
  grid;
  plot(T,y,"1;y (constrained);", T,u,"2;u (constrained);");

endfunction




