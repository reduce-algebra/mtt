function [Gamma,gamma] = ppp_output_constraint (A,B,C,D,x_0,A_u,Tau,Min,Max,Order,i_y)

  ## usage:  [Gamma,gamma] = ppp_output_constraint (A,B,C,D,A_u,Tau,Min,Max,Order)
  ##
  ## Derives the output constraint matrices Gamma and gamma
  ## For Constraints Min and max at times Tau 
  ## Order=0 - output constraints
  ## Order=1 - output derivative constraints
  ## etc
  ## NOTE You can stack up Gamma and gamma matrices for create multi-output constraints.

  ## Copyright (C) 1999 by Peter J. Gawthrop
  ## 	$Id$	

  ## Sizes
  [n_x,n_u,n_y] = abcddim(A,B,C,D); # System dimensions
  [n_U,m_U] = size(A_u);	# Number of basis functions
  [n,n_tau] = size(Tau);		# Number of constraint times
  
  if n_tau==0			# Nothing to be done
    Gamma = [];
    gamma = [];
    return
  endif

  ## Defaults
  if nargin<10
    Order = zeros(1,n_tau);
  endif

  if nargin<11
    i_y = 1;			# First output
  endif

  if n != 1
    error("Tau must be a row vector");
  endif
  
  n = length(Min);
  m = length(Max);
  o = length(Order);

  if (n != n_tau)||(m != n_tau)||(o != n_tau)
    error("Tau, Min, Max and Order must be the same length");
  endif
  

  ## Compute Gamma 
  Gamma = [];
  for i=1:n_U
    U = zeros(n_U,1); U(i,1) = 1; # Set up U_i
    y_i = ppp_ystar (A,B,C,D,x_0,A_u,U,Tau);# Compute y* for ith input for each tau
    y_i = y_i(:,i_y:n_y:n_y*n_tau); # Pluck out output i_y
    Gamma = [Gamma [-y_i';y_i']]; # Put in parts for Min and max
  endfor

  ## Compute gamma
  gamma = [-Min';Max'];

endfunction


