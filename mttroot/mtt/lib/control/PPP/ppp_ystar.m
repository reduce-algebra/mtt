function [ys,us,xs,xu,AA] = ppp_ystar (A,B,C,D,x_0,A_u,U,tau)

  ## usage:  [ys,us,xs,xu,AA] = ppp_ystar (A,B,C,D,x_0,A_u,U,tau)
  ##
  ## Computes open-loop moving horizon variables at time tau
  ## Inputs:
  ## A,B,C,D     System matrices
  ## x_0         Initial state
  ## A_u         composite system matrix for U* generation 
  ##             one square matrix (A_ui) row for each system input
  ##             each A_ui generates U*' for ith system input.
  ## OR
  ## A_u         square system matrix for U* generation 
  ##             same square matrix for each system input
  ## U           Column vector of optimisation coefficients  
  ## tau         Row vector of times at which outputs are computed
  ## Outputs:
  ## ys          y*, one column for each time tau 
  ## us          u*, one column for each time tau 
  ## xs          x*, one column for each time tau 
  ## xu          x_u, one column for each time tau 
  ## AA          The composite system matrix
  
  ## Copyright (C) 1999 by Peter J. Gawthrop
  ## 	$Id$	


  [n_x,n_u,n_y] = abcddim(A,B,C,D); # System dimensions
  no_system = n_x==0;

  [n,m] = size(A_u);		# Size of composite A_u matrix
  square = (n==m);		# Is A_u square?
  n_U = m;			# functions per input

  
  [n,m] = size(U);
  if (m != 1)
    error("U must be a column vector");
  endif
  
  if n_u>0
    if n_u!=length(U)/n_U
      error("U must be a column vector with n_u*n_U components");
    endif
  else
    n_u = length(U)/n_U;	# Deduce n_u from U if no system
  endif
  
  [n_x0,m_x0] = size(x_0);
  if n_x0!=n_x
    error(sprintf("x_0 must be a column with length %i", n_x));
  endif
  

  [n,m]=size(tau);
  if (n != 1 )
    error("tau must be a row vector of times");
  endif
  
  if square			# Then same A_u for each input
    ## Reorganise vector U into matrix Utilde  
    Utilde = [];
    for i=1:n_u
      j = (i-1)*n_U;
      range = j+1:j+n_U;
      Utilde = [Utilde; U(range,1)'];
    endfor

    ## Composite A matrix
    if no_system
      AA = A_u;
    else
      Z = zeros(n_U,n_x);
      AA = [A   B*Utilde
	    Z   A_u];
    endif
    
    xx_0 = [x_0;ones(n_U,1)];	# Composite initial condition
  else				# Different A_u on each input
    ## Reorganise vector U into matrix Utilde  
    Utilde = [];
    for i=1:n_u
      j = (i-1)*n_U;
      k = (n_u-i)*n_U;
      range = j+1:j+n_U;
      Utilde = [Utilde; zeros(1,j), U(range,1)', zeros(1,k)];
    endfor

    ## Create the full A_u matrix (AA_u) with the A_i s on the diagonal
#     AA_u = [];
#     for i = 1:n_u
#       AA_u = ppp_aug(AA_u,ppp_extract(A_u,i));
#     endfor
    AA_u = ppp_inflate(A_u);

    ## Composite A matrix
    if no_system
      AA = AA_u;
    else
      Z = zeros(n_U*n_u,n_x);
      AA = [A   B*Utilde
	    Z   AA_u];
    endif
    xx_0 = [x_0;ones(n_U*n_u,1)];	# Composite initial condition
  endif
  
  
  ## Initialise
  xs = [];			# x star
  xu = [];			# x star
  ys = [];			# y star
  us = [];			# u star
  n_xx = length(xx_0);		# Length of composite state

  ## Compute the star variables
  for t=tau
    xxt = expm(AA*t)*xx_0;	# Composite state
    xst = xxt(1:n_x);		# x star
    xut = xxt(n_x+1:n_xx);	# x star
    yst = C*xst;		# y star
    ust = Utilde*xut;		# u star

    xs = [xs xst];		# x star
    xu = [xu xut];		# x star
    ys = [ys yst];		# y star
    us = [us ust];		# u star
  endfor

endfunction