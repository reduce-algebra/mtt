function tex = pol2root2tex(pol,name,f)
  ## pol2tex: converts polynomial into LaTeX form as (s-z_1)..(s-z_n)
  ## tex = pol2root2tex(pol,[name,f])
  
  ###############################################################
  ## Version control history
  ###############################################################
  ## $Id$
  ## $Log$
  ## Revision 1.1  2001/05/10 11:44:40  gawthrop
  ## Useful conversion functions
  ##
  ## Revision 1.1  1999/05/24 22:05:53  peterg
  ## Initial revision
  ##
  ###############################################################

  if nargin<2
    name = "s"
  endif
  
  if nargin<3
    f = "%2.2f";
  endif

  n = length(pol)-1;

  if n>0
    r = sort(roots(pol));
  endif
  
  gain = pol(1);

  complex=0;
  if ((gain==1)&&(n>0))
    tex="";
  else
    tex = sprintf("%g", gain);
  endif
  
  for i=1:n
    if real(r(i))<0
      r_plusminus = '+';
    else
      r_plusminus = '-';
    endif
    if imag(r(i))<0
      i_plusminus = '+';
    else
      i_plusminus = '-';
    endif

    if complex
      complex=0
    else
      if abs(imag(r(i)))<1e-5
	ff = sprintf("%%s (%s %%s %s)",name, f);
	tex = sprintf(ff, tex, r_plusminus, abs(r(i)));
      else
	ff = sprintf("%%s (%s %%s %s \\pm j %s)", name, f, f)
	tex = sprintf(ff, tex, r_plusminus, abs(real(r(i))), imag(r(i)));
	complex=1;
      endif
    endif
  endfor
  
endfunction



