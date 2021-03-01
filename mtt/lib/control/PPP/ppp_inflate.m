function A_m = ppp_inflate (A_v)

  ## usage:  A_m = ppp_inflate (A_v)
  ##
  ## Creates the square matrix A_m with the matrix elements of the column
  ## vector of square matrices A_v.

  ## Copyright (C) 2001 by Peter J. Gawthrop

  [N,M] = size(A_v);

  if N<M
    error("A_v must have at least as many rows as columns");
  endif
  
  n = N/M;			# Number of matrix elements in A_v

  if round(n)!=n
    error("A_v must be a column vector of square matrices");
  endif
  
  A_m = [];
  for i = 1:n
    A_m = ppp_aug(A_m,ppp_extract(A_v,i));
  endfor

endfunction