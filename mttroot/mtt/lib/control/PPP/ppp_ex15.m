function  [name,T,y,u,ye,ue,J] = ppp_ex15 (ReturnName)

  ## usage:  ppp_ex15 ()
  ##
  ## PPP example - an unstable, nmp siso system
  ## 	$Id$	

  ## Example name
  name = "Linear unstable non-minimum phase third order system - intermittent control";

  if nargin>0
    return
  endif
  

  ## System - unstable
  A = [3 -3  1
       1  0  0
       0  1  0];
  B = [10
       0 
       0];
  C = [0 -0.5 1];
  D = 0;
  [n_x,n_u,n_y] = abcddim(A,B,C,D);

  ## Setpoint
  A_w = ppp_aug(0,[]);

  ## Controller
  t =[4.0:0.01:5.0];		# Optimisation horizon
  dt = t(2)-t(1);
  A_u = ppp_aug(laguerre_matrix(3,2.0), A_w);
  Q = 1;			# Weight

  ##Simulate
  W = 1;			# Setpoint
  x_0 = zeros(n_x,1);		# Initial state


  ## Closed-loop intermittent solution
  Delta_ol = 0.5		# Intermittent time

  disp("Intermittent control simulation");
  [T,y,u,J] = ppp_qp_sim (A,B,C,D,A_u,A_w,t,Q, \
			  [],[],[],[], \
			  [],[],[],[],W,x_0,Delta_ol);

  ## Exact closed-loop
  disp("Exact closed-loop");
  [k_x,k_w] = ppp_lin (A,B,C,D,A_u,A_w,t,Q);
  [ye,Xe] = ppp_sm2sr(A-B*k_x, B, C, D, T, k_w*W, x_0); # Compute Closed-loop control
  ue = k_w*ones(size(T))*W - k_x*Xe';


  title("y and u, exact and intermittent");
  xlabel("t");
  grid;
  plot(T,y,T,u,T,ye,T,ue);

endfunction
