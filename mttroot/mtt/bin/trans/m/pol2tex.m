function tex = pol2tex(pol,name,f)
  ## pol2tex: converts polynomial into LaTeX form.
  ## tex = pol2tex(pol,[name,f])
  
  ## pol  polynomial (row vector)
  ## name name of the variable (eg s or z)
  ## f    format of the coefficients (eg %2.4f)

  ###############################################################
  ## Version control history
  ###############################################################
  ## $Id$
  ## $Log$
  ## Revision 1.2  2001/05/10 19:08:35  gawthrop
  ## Cosmetic improvements
  ##
  ## Revision 1.1  2001/05/10 11:44:40  gawthrop
  ## Useful conversion functions
  ##
  ## Revision 1.1  1999/03/25 01:33:51  peterg
  ## Initial revision
  ##
  ###############################################################

  if nargin<2
    name = "s";
  endif
  
  if nargin<3
    f = "%2.2f";
  endif
  
  n = length(pol);
  
  if pol(1) == 1
    if n>1
      tex = '';
    else
      tex = '1';
    endif
  else
    ff = sprintf(" %s",f);
    tex = sprintf(ff, pol(1));
  endif
  
  if n>2
    tex = sprintf("%s%s^%i", tex, name, n-1);
  elseif n==2
    tex = sprintf("%s%s", tex, name);
  else
    tex = sprintf("%s", tex);
  endif

  for i=2:n
    if pol(i)<0
      plusminus = '-';
    else
      plusminus = '+';
    endif
    ff = sprintf("%%s %%s %s",f);
    tex = sprintf(ff, tex, plusminus, abs(pol(i)));
    if i<n-1
      tex = sprintf("%s%s^%i", tex, name, n-i);
    elseif i==n-1
      tex = sprintf("%s%s", tex, name); 
    else
      tex = sprintf("%s", tex);
    endif
  endfor
endfunction



