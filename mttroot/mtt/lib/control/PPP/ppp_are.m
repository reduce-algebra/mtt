function [P,A_u,A_w,k] = ppp_are (A,B,C,D,Q,R)

  ## usage:  [P,A_u,A_w] = ppp_are (A,B,C,D,Q,R)
  ##
  ## 


  ## Steady-state Linear Quadratic solution
  ## using Algebraic Riccati equation (ARE)
  Q_x =  C'*Q*C;			# Weighting on x
  [k, P, poles] = lqr (A, B, Q_x, R); # Algebraic Riccati solution

  ## Basis functions
  A_u = compan(poly(poles));

  ## Avoid spurious imag parts due to rounding
  A_u = real(A_u);		

  ## Setpoint basis functions
  A_w = 0;

  ## Include A_w in A_u
  A_u = ppp_aug(A_u,A_w);

endfunction
