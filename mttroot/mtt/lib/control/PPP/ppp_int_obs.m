function [x_p,y_p,y_new,error] = ppp_int_obs (x,y,U,A,B,C,D,A_u,delta,L)

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
  ## x_p, y_p predicted estimated state and output
  ## y_new corrected estimated current output
  ## error corresponding error

  ## Copyright (C) 2003 by Peter J. Gawthrop

  ## Sanity check
  [n_x,n_u,n_y] = abcddim(A,B,C,D);

  if nargin<10
    L = zeros(n_x,n_y);
  endif
  
  ## Corrector (on current value of output)
  error = (C*x-y);
  x_new = x - L*error;
  y_new = C*x_new;

  ## Predictor (predicts Delta_OL ahead)
  [y_p,us,x_p] = ppp_ystar (A,B,C,D,x_new,A_u,U,delta);

endfunction