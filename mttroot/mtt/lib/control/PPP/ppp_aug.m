function [A,v] = ppp_aug (A_1,A_2)

  ## usage:  [A,v] = ppp_aug (A_1,A_2)
  ##
  ## Augments square matrix A_1 with square matrix A_2 to create A=[A_1 0; A_2 0];
  ## and generates v, a compatible column vector with unit elements

  ## Copyright (C) 1999 by Peter J. Gawthrop


  [n_1,m_1] = size(A_1);
  if n_1 != m_1
    error("A_1 must be square");
  endif
  
  [n_2,m_2] = size(A_2);
  if n_2 != m_2
    error("A_2 must be square");
  endif

  A = [A_1            zeros(n_1,n_2)
       zeros(n_2,n_1) A_2];

  v = ones(n_1+n_2,1);

endfunction