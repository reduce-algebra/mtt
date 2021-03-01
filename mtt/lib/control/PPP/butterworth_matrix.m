function A = butterworth_matrix (n,p)

  ## usage:  A = butterworth (n,p)
  ##
  ## A-matrix for generating nth order Butterworth functions with parameter p

  ## Copyright (C) 2000 by Peter J. Gawthrop

  ## Butterworth poly
  pol = ppp_butter(n,p);
  
  ## Create A matrix (controller form)
  A = [-pol(2:n+1)
       eye(n-1) zeros(n-1,1)];
	
endfunction