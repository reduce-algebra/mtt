function name = ppp_ex7 (ReturnName)

  ## usage:  name = ppp_ex7 (ReturnName)
  ##
  ## PPP example -- standard multivariable system
  ## 	$Id$	


  ## Example name
  name = "Aircraft example:  system AIRC from J.M Maciejowski: Multivariable Feedback Design";

  if nargin>0
    return
  endif
  
  ## System
  [A,B,C,D] = airc;
  [n_x,n_u,n_y] = abcddim(A,B,C,D)

  ## Controller
  t = [4:0.01:5];		# Time horizon
  A_w = 0;		# Setpoint (same for each input)
  #A_u = ppp_aug(laguerre_matrix(5,1), 0) # Same for each input 
  A_u = laguerre_matrix(5,1); # Same for each input 
  Q = ones(3,1);		# Output weightings
  ## Design and plot
  W = [1;2;3]
  [ol_poles,cl_poles,ol_zeros,cl_zeros,k_x,k_w,K_x,K_w] = ppp_lin_plot (A,B,C,D,A_u,A_w,t,Q,W);
   cl_poles

  ## Try open-closed theory but using computed values:
  A_c = A - B*k_x; eig(A_c)
  K_x
  KK = ppp_open2closed (A_u,A_c,k_x)

  100*((KK-K_x)./KK)
endfunction
