function A = laguerre_matrix (n,p)

  ## usage:  A = laguerre_matrix (n,p)
  ##
  ## A-matrix for generating nth order Laguerre functions with parameter p

  ## Copyright (C) 1999 by Peter J. Gawthrop

  if n<1			# Creatre empty matrix
    A = [];
  else				# Create A matrix
    A = diag(-p*ones(n,1));
    for i=1:n-1
      A = A + diag(-2*p*ones(n-i,1),-i);
    endfor
  endif

endfunction