function [ol_poles,cl_poles,ol_zeros,cl_zeros,k_x,k_w,K_x,K_w,cond_uu] =  ppp_lin_plot (A,B,C,D,A_u,A_w,t,Q,W,x_0)

  ## usage:   [ol_poles,cl_poles,ol_zeros,cl_zeros,k_x,k_w,K_x,K_w] = ppp_lin_plot (A,B,C,D,A_u,A_w,t,Q,W,x_0)
  ##
  ## Linear PPP (Predictive pole-placement) computation with plotting
  ## INPUTS:
  ## A,B,C,D: system matrices
  ## A_u: composite system matrix for U* generation 
  ##      one square matrix (A_ui) row for each system input
  ##      each A_ui generates U*' for ith system input.
  ## A_w: composite system matrix for W* generation 
  ##      one square matrix (A_wi) row for each system output
  ##      each A_wi generates W*' for ith system output.
  ## t: row vector of times for optimisation (equispaced in time)
  ## Q: column vector of output weights (defaults to unity)
  ## W: Constant setpoint vector (one element per output)
  ## x_0: Initial state
  ## OUTPUTS:
  ## Various poles 'n zeros
  ## k_x: State feedback gain
  ## k_w: setpoint gain
  ## ie u(t) = k_w w(t) - k_x x(t)
  ## K_x, K_w: open loop gains
  ## J_uu, J_ux, J_uw: cost derivatives

  ## Copyright (C) 1999 by Peter J. Gawthrop
  ## 	$Id$	

  ## Some dimensions
  [n_x,n_u,n_y] = abcddim(A,B,C,D);
  [n_U,m_U]=size(A_u);
  square = (n_U==m_U);		# Its a square matrix so same U* on each input
  [n_W,m_W]=size(A_w);
  if n_W==m_W			# A_w square
    n_W = n_W*n_y;		# Total W functions
  endif
  

  [n_t,m_t] = size(t);

  ## Default Q
  if nargin<8
    Q = ones(n_y,1);
  endif

  ## Default W
  if nargin<9
    W = ones(n_W,1)
  endif

  ## Default x_0
  if nargin<10
    x_0 = zeros(n_x,1);
  endif

  ## Check some dimensions
  [n_Q,m_Q] = size(Q);
  if ((m_Q != 1)&&(m_Q != m_t)) || (n_Q != n_y)
    error("Q must be a column vector with one row per system output");
  endif

  [n,m] = size(W);
  if ((m != 1) || (n != n_W))
    error("W must be a column vector with one element per system output");
  endif

  [n,m] = size(x_0);
  if ((m != 1) || (n != n_x))
    error("x_0 must be a column vector with one element per system state");
  endif

  ## Simulate
  [y,ystar,t,k_x,k_w,K_x,K_w,Us0,J_uu,J_ux,J_uw,J_xx,J_xw,J_ww,y_u,cond_uu]\
      =  ppp_lin_sim(A,B,C,D,A_u,A_w,t,Q,W,x_0);

  ## Plot
  xlabel("Time"); title("y* and y"); grid;
  plot(t,ystar,t,y);

  ## Compute some pole/zero info
  cl_poles = eig(A-B*k_x)';
  ol_poles = eig(A)';

  if nargout>3
    ol_zeros = tzero(A,B,C,D)';
    cl_zeros = tzero(A-B*k_x,B,C,D)';
  endif

endfunction

