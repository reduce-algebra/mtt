function M = go_lst_to_matrix (L)

  ## usage:  M = go_lst_to_matrix (L)
  ##
  ## Converts a list to a matrix
  ## Assumes list contains equal-length lists as elements
  ## Not in ginsh
  ## Copyright (C) 2002 by Peter J. Gawthrop

  n = eval(g_nops(L));
  m = eval(g_nops(g_op(L,"0")));

  M = "";
  for i = 1:n
    M = sprintf("%s[",M);
    m_i = g_op(L,int2str(i-1));
    if (eval(g_nops(m_i))!=m)
      error("All list elements must be lists of same length");
    endif
    
    for j = 1:m
      m_ij = g_op(m_i,int2str(j-1));
      if j>1 
	jsep = ", ";
      else
	jsep = "";
      endif
      M = sprintf("%s%s%s", M, jsep, m_ij);
    endfor
    if i<n 
      isep=", ";
    else
      isep="";
    endif
    
    M = sprintf("%s]%s", M, isep);
  endfor

  M = sprintf("[%s]",M);
  
endfunction