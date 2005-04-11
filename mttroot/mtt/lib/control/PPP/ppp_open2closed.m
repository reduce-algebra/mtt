function [K_x T] = ppp_open2closed (A_u,A_c,k_x,x_0,Us0);

  ## usage:  [K_x T] = ppp_open2closed (A_u,A_c,k_x,x_0[,Us0]);
  ## K_x is the open-loop matrix as in U = K_w W - K_x x
  ## Note that K_x is a column vector of matrices - one matrix per input.
  ## T is the transformation matrix: x = T*Ustar; A_c = T*A_u*T^-1; U = (k_x*T)'
  ## A_u: The control basis-function matrix
  ## Us0: The initial value of Ustar
  ## A_c: closed-loop system matrix
  ## k_x: closed-loop feedback gain
  ## x_0: initial state
  ## Us0: initial basis fun state

  ## Copyright (C) 1999 by Peter J. Gawthrop
  ## 	$Id$	


  ## Check sizes
  n_o = is_square(A_u);
  n_c = is_square(A_c);

  if (n_o==0)||(n_c==0)||(n_o!=n_c)
    error("A_u and A_c must be square and of the same dimension");
  endif

  [n_u,n_x] = size(k_x);

  ## Defaults
  if nargin<4
    x_0 = zeros(n_c,1);
  endif

  if nargin<5 #Create U*(0)
    ##Us0  = ppp_ustar(A_u,n_u);
    Us0 = ones(1,n_o);
  endif
  

  ## Decompose A_u and Us0 into two bits:
  if n_o==n_c
    A_w = [];
    u_0 = Us0(1:n_c)';		# Assume same Us0 on each input
  else
    A_w = A_u(n_c+1:n_o, n_c+1:n_o)
    A_u = A_u(1:n_c, 1:n_c)
    U_w = Us0(1,n_c+1:n_o)'
    u_0 = Us0(1:n_c)'
  endif
  
  if !is_controllable(A_u,u_0)
    error("The pair [A_u, u_0] must be controllable");
  endif

  ## Controllability matrices
  C_o = u_0;
  C_c = x_0;
  for i=1:n_c-1
    C_o = [C_o A_u^i*u_0]; 
    C_c = [C_c A_c^i*x_0];
  endfor

  ## Transformation matrix: x = T*Ustar; A_c = T*A_u*T^-1; U = (k_x*T)'
  iC_o = C_o^-1;
  T = C_c*iC_o;

  K_x = [];
  for j = 1:n_u
    ## K_j matrix
    K_j = [];
    for i=1:n_c;
      ## Create T_i = dT/dx_i
      T_i = zeros(n_c,1);
      T_i(i) = 1;
      for k=1:n_c-1;
	A_k = A_c^k;
	T_i = [T_i A_k(:,i)];
      endfor
      T_i = T_i*iC_o;
      kj = k_x(j,:);		# jth row of k_x
      K_ji = kj*T_i;		# ith row of K_j
      K_j = [K_j; K_ji];
    endfor
    K_x = [K_x; K_j'];
  endfor

endfunction
