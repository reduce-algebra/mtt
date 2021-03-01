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
  
  [n_x,n_u,n_y] = abcddim(A,B,C,D); # Dimensions
  n_q = is_square(Q);		# Size of Q
  if n_q==0
    error("Q must be square");
  endif
  
  ## Steady-state Linear Quadratic solution
  ## using Algebraic Riccati equation (ARE)
  if n_q==n_y			# Output weight
    Q_x =  C'*Q*C;		# Weighting on x
  elseif n_q==n_x		# State weight
    Q_x = Q;
  else
    error(sprintf("Q (%ix%i) must be %ix%i or %ix%i",n_q,n_q,n_y,n_y,n_x,n_x));
  endif

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
