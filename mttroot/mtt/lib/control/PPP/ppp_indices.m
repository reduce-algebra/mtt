function indices = ppp_indices (names,sympar,sympars)

  ## usage:  indices = ppp_indices (names,sympar)
  ##
  ## names: column vector of component names
  ## sympar symbolic parameter structure for system
  ## sympars symbolic parameter structure for sensitivity system
 

  ## Returns a matrix indices with 3 columns, one row per name
  ## First  col: index of ith parameter of sensitivity system
  ## Second col: index of ith sensitivity parameter of sensitivity system
  ## Third col : index of ith parameter of system
  ## Copyright (C) 2002 by Peter J. Gawthrop

  ## Sanity check
  if nargin<3
    printf("Usage: ppp_indices (names,sympar,sympars)\n");
    return
  endif
  
  ## Set up the
  indices = [];
  [n,m] = size(names);
  for i = 1:n
    p_name = deblank(names(i,:));
    s_name = sprintf("%ss", p_name);
    if struct_contains(sympars, p_name)
      i_ps = eval(sprintf("sympars.%s;", p_name));
      if struct_contains(sympars, s_name)
	i_s = eval(sprintf("sympars.%s;", s_name));
	if struct_contains(sympar, p_name)
	  i_p = eval(sprintf("sympar.%s;", p_name));
	  indices_i = eval(sprintf("[%i,%i,%i];", i_ps, i_s, i_p));
	  indices = [indices; indices_i];
	else
	  printf("Parameter %s does not exist in sympar: ignoring\n", p_name)
	endif
      else
	printf("Sensitivity parameter %s does not exist in sympars: ignoring \
	parameter %s\n", s_name, p_name);
      endif
    else
      printf("Parameter %s does not exist in sympars: ignoring\n", p_name)
    endif
  endfor

endfunction