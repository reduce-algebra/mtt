function Ustar = ppp_ustar (A_u,n_u,tau,order,packed,n_zero)

  ## usage:  Us = ppp_ustar(A_u,n_u,tau,order,packed)
  ##
  ## Computes the U* matrix at time tau in terms of A_u
  ## n_u : Number of system inputs
  ## If tau is a vector, computes U* at each tau and puts into a row vector:
  ## If packed==1
  ##     Ustar = [Ustar(tau_1) Ustar(tau_2) ...]
  ## else Ustar = [Ustar(tau_1); Ustar(tau_2) ...]
  ## n_zero extra zero columns appended

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
  
  if nargin<5
    packed=1;
  endif
  
  if nargin<6
    n_zero=0;
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
      if (packed==1)
	ustar = [ustar; zeros(1,(i-1)*N), (Ak*eA*u_0)', \
		 zeros(1,(n_u-i)*N)];
      else
	ustar = [ustar, (Ak*eA*u_0)'];
      endif
    endfor

    if (packed==1)
      Ustar = [Ustar ustar];
    else
      Ustar = [Ustar; ustar];
    endif
  endfor

  if (n_zero>0)
    [N,M] = size(Ustar);
    Ustar = [Ustar zeros(N, n_zero)];
  endif
  
endfunction