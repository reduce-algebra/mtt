function [x_p,y_p,error] = ppp_int_obs (x,y,U,A,B,C,D,A_u,delta,L)

  ## usage: x_new = ppp_int_obs (x,y,U,A,B,C,D,A_u,delta,L)
  ##
  ## Intermittent observer for PPP
  ##
  ## x,y Current estimated state and measured output
  ## U PPP control weights
  ## A,B,C,D System matrices
  ## A_u PPP basis matrix
  ## delta time step
  ## L Observer gain

  ## Sanity check
  [n_x,n_u,n_y] = abcddim(A,B,C,D);

  if nargin<10
    L = zeros(n_x,n_y);
  endif
  
  ## Corrector (on current value of output)
  error = (C*x-y);
  x_new = x - L*error;

  ## Predictor (predicts Delta_OL ahead)
  [y_p,us,x_p] = ppp_ystar (A,B,C,D,x_new,A_u,U,delta);

endfunction