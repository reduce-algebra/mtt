function other = mtt_other_causality (causality)

  ## usage:  other = mtt_other_causality (causality)
  ##
  ## 

  causality = deblank(causality);
  if strcmp(causality,"effort");
    other = "flow";
  elseif strcmp(causality,"flow");
    other = "effort";
  elseif strcmp(causality,"e");
    other = "f";
  elseif strcmp(causality,"f");
    other = "e";
  else
    error(sprintf("Causality \"%s\" not recognised",causality));
  endif
  

endfunction