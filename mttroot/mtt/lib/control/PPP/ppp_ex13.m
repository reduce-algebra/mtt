function name = ppp_ex13 (ReturnName)

  ## usage:  ppp_ex13 ()
  ##
  ## PPP example: Sensitivity minimisation (incomplete)


  ## Example name
  name = "Sensitivity minimisation (incomplete)";

  if nargin>0
    return
  endif
  

  ## System - unstable
  A = [-3 -3 -1
       1  0  0
       0  1  0];
  B = [1 
       0 
       0];
  C = [0 -0.5 1
       0  1.0 0];
  D = [0;0];

  ## Setpoint
  A_w = [0;0]

  ## Controller
  t =[0:0.1:5];			# Optimisation horizon
  t1 =[0:0.1:1];
  t2 =[1.1:0.1:3.9];	
  t3 =[4:0.1:5];
  

  A_u = ppp_aug(laguerre_matrix(3,5.0), 0);
  q_s=1e3;
  Q = [exp(5*t)
       q_s*exp(-t)]
  size(Q)
  W = [1;0];

  [ol_poles,cl_poles,ol_zeros,cl_zeros,k_x,k_w] = ppp_lin_plot (A,B,C,D,A_u,A_w,t,Q,W)

endfunction



