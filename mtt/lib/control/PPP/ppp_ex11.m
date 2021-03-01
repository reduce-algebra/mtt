function [name,T,y,u,ys,us,J] = ppp_ex11 (ReturnName)

  ## usage:   [name,T,y,u,ys,us,T1,du,dus] = ppp_ex11 (ReturnName)
  ##
  ## PPP example

  ## 	$Id$	


  ## Example name
  name = "Input constraints +-1.5 on u* at tau=0,0.5,1,1.5,2";

  if nargin>0
    return
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
  [n_x,n_u,n_y] = abcddim(A,B,C,D);

  ## Controller
  t = [6:0.02:7];		# Time horizon
  A_w = 0;			# Setpoint
  A_u = ppp_aug(laguerre_matrix(3,2.0), A_w); # Input functions

  Q = ones(n_y,1);;
  

  ## Constraints
  Gamma = [];
  gamma = [];

  ## Constraints - u
  Tau_u = [0:0.5:2];
  one = ones(size(Tau_u));
  limit = 1.5;
  Min_u = -limit*one;
  Max_u =  limit*one;
  Order_u = 0*one;

  ## Constraints - y
  Tau_y = [];			# No output constraints
  one = ones(size(Tau_y));
  limit = 1.5; 
  Min_y = -limit*one;
  Max_y =  limit*one;
  Order_y = 0*one;

  ## Simulation
  W=1;
  x_0 = zeros(3,1);

  ## Constrained - open-loop
  disp("Designing controller");
  [k_x,k_w,K_x,K_w,Us0,J_uu,J_ux,J_uw] = ppp_lin  (A,B,C,D,A_u,A_w,t,Q); # Unconstrained design
  [Gamma_u,gamma_u] = ppp_input_constraint (A_u,Tau_u,Min_u,Max_u);

  Gamma = Gamma_u;
  gamma = gamma_u;

  ## Constrained OL simulation
  disp("Computing constrained ol response");
  [u,U] = ppp_qp (x_0,W,J_uu,J_ux,J_uw,Us0,Gamma,gamma);
  T = [0:t(2)-t(1):t(length(t))];
  [ys,us] = ppp_ystar (A,B,C,D,x_0,A_u,U,T);

  ## Unconstrained OL simulation
  disp("Computing unconstrained ol response");
  [uu,Uu] = ppp_qp (x_0,W,J_uu,J_ux,J_uw,Us0,[],[]);
  [ysu,usu] = ppp_ystar (A,B,C,D,x_0,A_u,Uu,T);

  title("Constrained and unconstrained y*");
  xlabel("t");
  grid;
  figure(1);
  plot(T,ys,"-;y*: constrained;", T,ysu, "--;y*: unconstrained;")

  ## Non-linear - closed-loop
    disp("Computing constrained closed-loop response");
  [T,y,u,J] = ppp_qp_sim (A,B,C,D,A_u,A_w,t,Q, \
			  Tau_u,Min_u,Max_u,Order_u, \
			  Tau_y,Min_y,Max_y,Order_y,W,x_0);

  title("Constrained closed-loop response");
  xlabel("t");
  grid;
  figure(2);
  plot(T,y,"-;y;", T,u,"--;u;");

#   ## Compute derivatives.
#   dt = t(2)-t(1);
#   du = diff(u)/dt;
#   dus = diff(us)/dt;
#   T1 = T(1:length(T)-1);
  ##plot(T1,du,T1,dus);
endfunction




