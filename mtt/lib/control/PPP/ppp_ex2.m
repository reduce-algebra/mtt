function name = ppp_ex2 (Return_Name)

  ## usage:  Name = ppp_ex2 (Return_Name)
  ##
  ## PPP example: Effect of slow desired closed-loop
  ## 	$Id$	


  ## Example name
  name = "Effect of slow desired closed-loop: closed-loop is same as open loop";

  if nargin>0
    return
  endif
  
  ## System
  A = -1;			# Fast - time constant = 1
  B = 0.5;			# Gain is 1/2
  C = 1;
  D = 0;

  ## Controller
  t =[9:0.1:10];		# Optimisation horizon

  A_u = [-0.1 0			# Slow - time constant = 10
         1 0];

  A_w = 0;			# Constant set point

  [ol_poles,cl_poles,ol_zeros,cl_zeros,k_x,k_w] = ppp_lin_plot(A,B,C,D,A_u,A_w,t)
endfunction

