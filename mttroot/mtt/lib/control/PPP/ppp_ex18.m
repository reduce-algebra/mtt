function name = ppp_ex18 (ReturnName)

  ## usage:  ppp_ex18 ()
  ##
  ## PPP example - an unstable, nmp siso system
  ## 	$Id$	


  ## Example name
  name = "First order with redundant inputs";

  if nargin>0
    return
  endif
  
  ## System 
  A = 1
  B = 1
  C = 1
  D = 0;

  ## Setpoint
  A_w = ppp_aug(0,[]);

  ## Controller
  ##Optimisation horizon
  t =[2:0.1:3];

  ## A_u
  A_u = diag([0  -2 -4 -6])

  [ol_poles,cl_poles] = ppp_lin_plot (A,B,C,D,A_u,A_w,t)

  
endfunction





