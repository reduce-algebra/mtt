function [k_x,k_w,K_x,K_w,Us0,J_uu,J_ux,J_uw,J_xx,J_xw,J_ww,y_u,cond_uu] = ppp_lin(A,B,C,D,A_u,A_w,tau,Q,max_cond);
  ## usage:   [k_x,k_w,K_x,K_w,Us0,J_uu,J_ux,J_uw,J_xx,J_xw,J_ww,y_u,cond_uu] = ppp_lin(A,B,C,D,A_u,A_w,tau,Q,max_cond)
  ##
  ## Linear PPP (Predictive pole-placement) computation 
  ## INPUTS:
  ## A,B,C,D: system matrices
  ## A_u: composite system matrix for U* generation 
  ##      one square matrix (A_ui) row for each system input
  ##      each A_ui generates U*' for ith system input.
  ## OR
  ## A_u: square system matrix for U* generation 
  ##      same square matrix for each system input.
  ## A_w: composite system matrix for W* generation 
  ##      one square matrix (A_wi) row for each system output
  ##      each A_wi generates W*' for ith system output.
  ## t: row vector of times for optimisation (equispaced in time)
  ## Q column vector of output weights (defaults to unity)
  ## OR
  ## Q matrix,  each row corresponds to time-varying weight compatible with t
  ## max_cond: Maximum condition number of J_uu (def 1/eps)
  ## OUTPUTS:
  ## k_x: State feedback gain
  ## k_w: setpoint gain
  ## ie u(t) = k_w w(t) - k_x x(t)
  ## K_x, K_w: open loop gains
  ## Us0: Value of U* at tau=0
  ## J_uu, J_ux, J_uw, J_xx,J_xw,J_ww: cost derivatives
  ## cond_uu : Condition number of J_uu
  ## Copyright (C) 1999, 2000 by Peter J. Gawthrop
  ## 	$Id$	

  ## Check some dimensions
  [n_x,n_u,n_y] = abcddim(A,B,C,D);
  if (n_x==-1)
    return
  endif

  ## Default Q
  if nargin<8
    Q = ones(n_y,1);
  endif

  ## Default order
  if nargin<9
    max_cond = 1e20;
  endif
  
  [n_U,m_U] = size(A_u);
  if (n_U != n_u*m_U)&&(n_U != m_U)
    error("A_u must be square or have N_u rows and N_u/n_u columns");
  endif

  if (n_U == m_U)		# U matrix square
    n_U = n_U*n_u;		# So same U* on each input
  endif

  
  [n_W,m_W] = size(A_w);
  if n_W>0
    if (n_W != n_y*m_W)&&(n_W != m_W)
      error("A_w must either be square or have N_w rows and N_w/n_y columns");
    endif
    square_W = (n_W== m_W);	# Flag indicates W is square
    if (n_W == m_W)		# W matrix square
      n_W = n_W*n_y;		# So same W* on each output
    endif
  endif
  

  [n_t,m_t] = size(tau);
  if n_t != 1
    error("tau must be a row vector");
  endif

  [n_Q,m_Q] = size(Q);
  if ((m_Q != 1)&&(m_Q != m_t)) || (n_Q != n_y)
    error("Q must be a column vector with one row per system output");
  endif

  if (m_Q == 1)			# Convert to vector Q(i)
    Q = Q*ones(1,m_t);		# Extend to cover full range of tau
  endif
  
  ##Set up initial states
  u_0 = ones(m_U,1);
  w_0 = ones(m_W,1);

  ## Find y_U - derivative of y* wrt U.
  i_U = 0;
  x_0 = zeros(n_x,1);		# This is for x=0
  y_u = [];			# Initialise
  Us = [];			# Initialise
  for i=1:n_U			# Do for each input function U*_i
    dU = zeros(n_U,1);
    dU(++i_U) = 1;		# Create dU/dU_i 
    [ys,us] = ppp_ystar (A,B,C,D,x_0,A_u,dU,tau); # Find ystar and ustar
    y_u = [y_u ys'];		# Save y_u (y for input u)  with one row for each t.
    Us = [Us us'];		# Save u (input)  with one row for each t.
  endfor

  Ws = [];			# Initialise
  if n_W>0
    ## Find w*
    i_W = 0;
    x_0 = zeros(n_x,1);		# This is for x=0
    for i=1:n_W			# Do for each setpoint function W*i
      dW = zeros(n_W,1);
      dW(++i_W) = 1;		# Create dW/dW_i 
      [ys,ws] = ppp_ystar ([],[],[],[],[],A_w,dW,tau); # Find ystar and ustar
      Ws = [Ws ws'];		# Save u (input)  with one row for each t.
    endfor
  endif
  


  ## Find y_x - derivative of y* wrt x.
  y_x=[];
  for t_i=tau
    y = C*expm(A*t_i);
    yy = reshape(y,1,n_y*n_x);	# Reshape to a row vector
    y_x = [y_x; yy];
  endfor

  ## Compute the integrals to give cost function derivatives
  [n_yu m] = size(y_u');
  [n_yx m] = size(y_x');
  [n_yw m] = size(Ws');

  J_uu = zeros(n_U,n_U);
  J_ux = zeros(n_U,n_x);
  J_uw = zeros(n_U,n_W);
  J_xx = zeros(n_x,n_x);
  J_xw = zeros(n_x,n_W);
  J_ww = zeros(n_W,n_W);

  ## Add up cost derivatives for each output but weighted by Q.
  ## Scaled by time interval
  ## y_u,y_x and Ws should really be 3D matrices, but instead are stored
  ## with one row for each time and one vector (size n_y) column for
  ## each element of U

  ## Scale Q
  Q = Q/m_t;			# Scale by T/dt = number of points
  ## Non-w bits
  for i = 1:n_y			# For each output
    QQ = ones(n_U,1)*Q(i,:);	# Resize Q
    J_uu = J_uu + (QQ .* y_u(:,i:n_y:n_yu)') * y_u(:,i:n_y:n_yu);
    J_ux = J_ux + (QQ .* y_u(:,i:n_y:n_yu)') * y_x(:,i:n_y:n_yx);
    QQ = ones(n_x,1)*Q(i,:);	# Resize Q
    J_xx = J_xx + (QQ .* y_x(:,i:n_y:n_yx)') * y_x(:,i:n_y:n_yx);
  endfor

  ## Exit if badly conditioned
  cond_uu = cond(J_uu);
  if cond_uu>max_cond
    error(sprintf("J_uu is badly conditioned. Condition number = 10^%i",log10(cond_uu)));
  endif

  ## w bits
  if n_W>0
    for i = 1:n_y			# For each output
      QQ = ones(n_U,1)*Q(i,:);	# Resize Q
      J_uw = J_uw + (QQ .* y_u(:,i:n_y:n_yu)') * Ws (:,i:n_y:n_yw);
      QQ = ones(n_x,1)*Q(i,:);	# Resize Q
      J_xw = J_xw + (QQ .* y_x(:,i:n_y:n_yx)') * Ws (:,i:n_y:n_yw);
      QQ = ones(n_W,1)*Q(i,:);	# Resize Q
      J_ww = J_ww + (QQ .* Ws (:,i:n_y:n_yw)') * Ws (:,i:n_y:n_yw);
    endfor
  endif

  ## Compute the open-loop gains
  K_w = J_uu\J_uw;
  K_x = J_uu\J_ux;

  ## U*(tau) at tau=0 
  Us0 = ppp_ustar(A_u,n_u,0);		
  
  ## Compute the closed-loop gains
  k_x = Us0*K_x;
  k_w = Us0*K_w;

endfunction
