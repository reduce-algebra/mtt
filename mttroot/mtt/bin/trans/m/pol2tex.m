function tex = pol2tex(pol)
  ## pol2tex: converts polynomial into LaTeX form.
  ## tex = pol2tex(pol)
  

  ###############################################################
  ## Version control history
  ###############################################################
  ## $Id$
  ## $Log$
  ## Revision 1.1  1999/03/25 01:33:51  peterg
  ## Initial revision
  ##
  ###############################################################

  n = length(pol);
  
  if pol(1) == 1
    if n>1
      tex = '';
    else
      tex = '1';
    endif
  else
    tex = sprintf(" %1.2f", pol(1));
  endif
  
  if n>2
    tex = sprintf("%ss^%1.f", tex, n-1);
  elseif n==2
    tex = sprintf("%ss", tex);
  else
    tex = sprintf("%s", tex);
  endif

  for i=2:n
    if pol(i)<0
      plusminus = '-';
    else
      plusminus = '+';
    endif
    tex = sprintf("%s %s %1.2f", tex, plusminus, abs(pol(i)));
    if i<n-1
      tex = sprintf("%ss^%1.0f", tex, n-i);
    elseif i==n-1
      tex = sprintf("%ss", tex); 
    else
      tex = sprintf("%s", tex);
    endif
  endfor
endfunction



