function name = ppp_ex10 (ReturnName)

  ## usage:  name = ppp_ex10 (ReturnName)
  ##
  ## PPP example - shows a standard multivariable system
  ##
 
  ## Example name
  name = "Remotely-piloted vehicle example:  system RPV from J.M Maciejowski: Multivariable Feedback Design";

  if nargin>0
    return
  endif
  
  ## System
  [A,B,C,D] = rpv;
  [n_x,n_u,n_y] = abcddim(A,B,C,D)

  ## Controller
  t = 1*[0.9:0.01:1];		# Time horizon
  A_w = 0;		# Setpoint
#   TC = 0.1*[1 1];		# Time constants for each input
#   A_u = [];
#   for tc=TC			# Input
#     A_u = [A_u;ppp_aug(laguerre_matrix(2,1/tc), 0)];
#   endfor
  A_u = ppp_aug(laguerre_matrix(2,5.0), A_w)
  Q = [1;1];		# Output weightings

  ## Design and plot
  W = [1;2]
  [ol_poles,cl_poles,ol_zeros,cl_zeros,k_x,k_w,K_x,K_w] = ppp_lin_plot (A,B,C,D,A_u,A_w,t,Q,W);

endfunction
