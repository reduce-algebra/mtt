function index = cause2index (causality)

  ## usage:  index = cause2index (causality)
  ##
  ## 

  if isstr(causality)
    if strcmp(causality,"effort")
      index = 1;
    elseif strcmp(causality,"flow")
      index = 2;
    elseif strcmp(causality,"state")
      index = 3
    else
      error(sprintf("Causality ""%s"" not recognised",causality));
    endif
    
  else
    if causality==1
      index = 1;
    elseif causality==-1
      index = 2;
    else
      error(sprintf("Causality ""%i"" not recognised",causality));
    endif
  endif

endfunction