function v = nozeros (v0,tol)

  ## usage:  v = nozeros (v0,tol)
  ##
  ## Zaps the zeros in a vector with tolerance tol (defaults to zero)

  ## Copyright (C) 2000 by Peter J. Gawthrop

  if nargin<2
    tol=eps;
  endif
  
  
  v = [];
  j=0;
  for i = 1:length(v0)
    if abs(v0(i))>tol
      j=j+1;
      v(1,j) = v0(i);
    end;
  end;
  

endfunction