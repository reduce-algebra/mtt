function name = ppp_ex9 (ReturnName)

  ## usage:  name = ppp_ex9 (ReturnName)
  ##
  ## PPP example -- a standard multivariable example
  ## 	$Id$	



  ## Example name
  name = "Turbogenerator example:  system TGEN from J.M Maciejowski: Multivariable Feedback Design";

  if nargin>0
    return
  endif
  
  ## System
  [A,B,C,D] = tgen;
  [n_x,n_u,n_y] = abcddim(A,B,C,D)

  ## Controller
  t = [1.0:0.01:2.0];		# Time horizon
#   A_w = zeros(n_y,1);		# Setpoint
#   TC = 2*[1 1];		# Time constants for each input
#   A_u = [];
#   for tc=TC			# Input
#     A_u = [A_u;ppp_aug(laguerre_matrix(3,1/tc), 0)];
#   endfor
  A_w = 0;
  A_u = ppp_aug(ppp_aug(laguerre_matrix(2,1.0),laguerre_matrix(2,2.0)), A_w)
  Q = [1;1];		# Output weightings

  ## Design and plot
  W = [1;2]
  [ol_poles,cl_poles,ol_zeros,cl_zeros,k_x,k_w,K_x,K_w] = ppp_lin_plot (A,B,C,D,A_u,A_w,t,Q,W);

#   ol_poles, cl_poles
#   k_x,k_w
#   K_X = [K_x -K_w]
#   A_c = A - B*k_x;
#   K_X_comp = ppp_open2closed (A_u,[A_c B*k_w*W; zeros(1,n_x+1)],[k_x -k_w*W])
endfunction
