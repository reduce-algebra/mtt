function [P,A_u,A_w,k] = ppp_are (A,B,C,D,Q,R,A_type)

  ## usage:  [P,A_u,A_w] = ppp_are (A,B,C,D,Q,R,A_type)
  ##
  ## 

  if nargin<1
    disp("usage:  [P,A_u,A_w] = ppp_are (A,B,C,D,Q,R,A_type)");
    return
  endif
  
  if nargin<7
    A_type = "feedback";
  endif
  

  ## Steady-state Linear Quadratic solution
  ## using Algebraic Riccati equation (ARE)
  Q_x =  C'*Q*C;			# Weighting on x
  [k, P, poles] = lqr (A, B, Q_x, R); # Algebraic Riccati solution

  ## Basis functions
  if strcmp(A_type,"companion")
    A_u = compan(poly(poles));
  elseif strcmp(A_type,"feedback")
    A_u = A-B*k;
  else
    error(sprintf("A_type must be %s, not %s", "companion or feedback", A_type));
  endif
  
    ## Avoid spurious imag parts due to rounding
    A_u = real(A_u);		

  ## Setpoint basis functions
  A_w = 0;

endfunction
