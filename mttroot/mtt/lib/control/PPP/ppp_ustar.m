function Ustar = ppp_ustar (A_u,n_u,tau,order)

  ## usage:  Us = ppp_ustar(A_u,n_u,tau)
  ##
  ## Computes the U* matrix at time tau in terms of A_u
  ## n_u : Number of system inputs
  ## If tau is a vector, computes U* at each tau and puts into a row vector:
  ##     Ustar = [Ustar(tau_1) Ustar(tau_2) ...]
  ## Copyright (C) 1999 by Peter J. Gawthrop
  ## 	$Id$	

  if nargin<2
    n_u = 1;
  endif
  
  if nargin<3
    tau = 0;
  endif
  
  if nargin<4
    order = 0;
  endif
  

  [n,m] = size(A_u);		# Size of composite A_u matrix
  N = m;			# Number of U* functions per input  
  nm = n/m;

  if (nm != n_u)&&(n!=m)	# Check consistency
    error("A_u must be square or be a column of square matrices");
  endif

  u_0 = ones(N,1);

  Ustar = [];
  for t = tau;
    ustar = [];
    for i = 1:n_u
      A_i = ppp_extract(A_u,i);
      Ak = A_i^order;
      eA = expm(A_i*t);
      ustar = [ustar; zeros(1,(i-1)*N), (Ak*eA*u_0)', zeros(1,(n_u-i)*N)];
    endfor
    Ustar = [Ustar ustar];
  endfor


endfunction