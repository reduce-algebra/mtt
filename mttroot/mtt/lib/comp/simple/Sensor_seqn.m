function LHS = Sensor_seqn (attribute,name)

  ## usage:  LHS = Sensor_seqn (attribute,name)
  ##
  ## Write the LHS of a sensor equation
  

  if strcmp(attribute,"external")
    LHS = sprintf("MTTy_%s", name);  
  elseif strcmp(attribute,"internal")
    LHS = sprintf("MTTy_%s", name); 
  else
    error(sprintf("attribute ""%s"" not appropriate for a \
    source"), attribute);
  endif
endfunction