function name = ppp_ex8 (ReturnName)

  ## usage:  name = ppp_ex8 (ReturnName)
  ##
  ## PPP example - standard multivariable example
  ## 	$Id$	

  ## Example name
  name = "Automotive gas turbine example:  system AUTM from J.M Maciejowski: Multivariable Feedback Design";

  if nargin>0
    return
  endif
  
  ## System
  [A,B,C,D] = autm;
  [n_x,n_u,n_y] = abcddim(A,B,C,D)

  ## Controller
  t = [4:0.1:5];		# Time horizon
  A_w = 0;			# Setpoint
  A_u = ppp_aug(laguerre_matrix(4,2.0), 0) # Input
  Q = [1;1e3];		# Output weightings

  ## Design and plot
  W = [1;2]
  [ol_poles,cl_poles,ol_zeros,cl_zeros,k_x,k_w] = ppp_lin_plot (A,B,C,D,A_u,A_w,t,Q,W);

endfunction
