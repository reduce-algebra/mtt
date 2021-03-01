function A_i = ppp_extract (A_u,input)

  ## usage:  A_i = ppp_extract (A_u)
  ##
  ## Extracts the ith A_u matrix.

  ## Copyright (C) 1999 by Peter J. Gawthrop
  ## 	$Id$	

  [n,m] = size(A_u);		# Size of composite A_u matrix
  square = (n==m);		# Its a square matrix so same U* on each input
  if square
    A_i = A_u;			# All a_u the same
  else
    N = m;			# Number of U* functions per input  
    n_u = n/m;
    if floor(n_u) != n_u	# Check that n_u is an integer
      error("A_u must be square or be a column of square matrices");
    endif
    
    if input>n_u
      error("Input index too large");
    endif
    
    ## Extract the ith matrix
    start = (input-1)*N;
    range=(start+1:start+N);
    A_i = A_u(range,:);
  endif

endfunction