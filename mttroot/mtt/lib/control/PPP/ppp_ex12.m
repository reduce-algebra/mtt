function [name,T,y,u,ys,us,J,T1,du,dus] = ppp_ex12 (ReturnName)

  ## usage:   [name,T,y,u,ys,us,T1,du,dus] = ppp_ex12 (ReturnName)
  ##
  ## PPP example - shows input derivative constraints  
  ## $Id$


  ## Example name
  name = "Input derivative constraints +-1 on u* at tau=0,0.5,1,1.5,2";

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
  t = [4:0.02:5];		# Time horizon
  A_w = 0;			# Setpoint
  A_u = ppp_aug(laguerre_matrix(3,2.0), A_w); # Input functions
  Q = ones(n_y,1);;

  ## Constaints - du*/dtau
  Tau = [0:0.5:2];
  one = ones(size(Tau));
  limit = 1;
  Min = -limit*one;
  Max =  limit*one;
  Order = one;
  [Gamma,gamma] = ppp_input_constraint (A_u,Tau,Min,Max,Order);

  W=1;
  x_0 = zeros(3,1);

  ## Constrained - open-loop
  [k_x,k_w,K_x,K_w,Us0,J_uu,J_ux,J_uw] = ppp_lin (A,B,C,D,A_u,A_w,t,Q);
  [u,U] = ppp_qp (x_0,W,J_uu,J_ux,J_uw,Us0,Gamma,gamma);
  T = [0:t(2)-t(1):t(length(t))];
  [ys,us] = ppp_ystar(A,B,C,D,x_0,A_u,U,T);

  ## Non-linear - closed-loop
  [T,y,u,J] = ppp_qp_sim (A,B,C,D,A_u,A_w,t,Q, \
			   Tau,Min,Max,Order, \
			   [],[],[],[], W,x_0);

  title("y,y*,u and u*");
  xlabel("t");
  grid;
  plot(T,y,"1;y;", T,u,"2;u;", T,ys,"3;y*;", T,us,"4;u*;");

  ## Compute derivatives.
  dt = t(2)-t(1);
  du = diff(u)/dt;
  dus = diff(us)/dt;
  T1 = T(1:length(T)-1);
  ##plot(T1,du,T1,dus);
endfunction








