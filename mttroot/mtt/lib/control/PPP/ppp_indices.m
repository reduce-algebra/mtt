function indices = ppp_indices (names,sympar)

  ## usage:  indices = ppp_indices (names,sympar)
  ##
  ## names: column vector of component names
  ## sympar: mtt-generated data structure od symbolic parameters


  ## Set up the
  indices = [];
  [n,m] = size(names);
  for i = 1:n
    p_name = deblank(names(i,:));
    s_name = sprintf("%ss", p_name);
    if struct_contains(sympar, p_name)
      i_p = eval(sprintf("sympar.%s;", p_name));
      if struct_contains(sympar, s_name)
	i_s = eval(sprintf("sympar.%s;", s_name));
	indices_i = eval(sprintf("[%i,%i];", i_p, i_s));
	indices = [indices; indices_i];
      else
	printf("Sensitivity parameter %s does not exist: ignoring \
	parameter %s\n", s_name, p_name);
      endif
    else
      printf("Parameter %s does not exist: ignoring\n", p_name)
    endif
  endfor
  

endfunction