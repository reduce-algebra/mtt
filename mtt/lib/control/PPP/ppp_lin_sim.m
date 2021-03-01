function [y,ystar,t,k_x,k_w,K_x,K_w,Us0,J_uu,J_ux,J_uw,J_xx,J_xw,J_ww,y_u,cond_uu] =  ppp_lin_sim(A,B,C,D,A_u,A_w,tau,Q,W,x_0)

  ## usage:   [ol_poles,cl_poles,ol_zeros,cl_zeros,k_x,k_w,K_x,K_w] = ppp_lin_plot (A,B,C,D,A_u,A_w,tau,Q,W,x_0)
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
  ## tau: row vector of times for optimisation (equispaced in time)
  ## Q: column vector of output weights (defaults to unity)
  ## W: Constant setpoint vector (one element per output)
  ## x_0: Initial state
  ## OUTPUTS:
  ## y : closed-loop output
  ## ystar : open-loop moving-horizon output
  ## t : time axis

  ## Copyright (C) 2001 by Peter J. Gawthrop
  ## 	$id: ppp_lin_plot.m,v 1.13 2001/01/26 16:03:13 peterg Exp $	

  ## Some dimensions
  [n_x,n_u,n_y] = abcddim(A,B,C,D);
  [n_U,m_U]=size(A_u);
  square = (n_U==m_U);		# Its a square matrix so same U* on each input
  [n_W,m_W]=size(A_w);
  if n_W==m_W			# A_w square
    n_W = n_W*n_y;		# Total W functions
  endif
  

  [n_tau,m_tau] = size(tau);

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
  if ((m_Q != 1)&&(m_Q != m_tau)) || (n_Q != n_y)
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

  ## Control design
  disp("Designing controller");
  [k_x,k_w,K_x,K_w,Us0,J_uu,J_ux,J_uw,J_xx,J_xw,J_ww,y_u,cond_uu] = ppp_lin  (A,B,C,D,A_u,A_w,tau,Q);

  ## Set up simulation times
  dtau = tau(2) -tau(1);		# Time increment
  t =  0:dtau:tau(length(tau));	# Time starting at zero

  ## Compute the OL step response
  disp("Computing OL response");
  U = K_w*W - K_x*x_0;
  ystar = ppp_ystar (A,B,C,D,x_0,A_u,U,t);

  ## Compute the CL step response
  disp("Computing CL response");
  y = ppp_sm2sr(A-B*k_x, B, C, D, t, k_w*W, x_0); # Compute Closed-loop control


endfunction

