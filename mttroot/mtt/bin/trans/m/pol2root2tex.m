function tex = pol2root2tex(pol)
  ## pol2tex: converts polynomial into LaTeX form as (s-z_1)..(s-z_n)
  ## tex = pol2root2tex(pol)
  
  ###############################################################
  ## Version control history
  ###############################################################
  ## $Id$
  ## $Log$
  ## Revision 1.1  1999/05/24 22:05:53  peterg
  ## Initial revision
  ##
  ###############################################################


  n = length(pol)-1;

  if n>0
    r = sort(roots(pol));
  endif
  
  gain = pol(1);

  complex=0;
  tex = sprintf("%g", gain);
  for i=1:n
    if complex
      complex=0
    else
      if imag(r(i))<eps
	tex = sprintf("%s (s + %g)", tex, -r(i));
      else
	tex = sprintf("%s (s + %g \\pm %g)", tex, -real(r(i)), imag(r(i)));
	complex=1;
      endif
    endif
  endfor
  
endfunction



