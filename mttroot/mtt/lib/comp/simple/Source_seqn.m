function RHS = Source_seqn (attribute,name)

  ## usage:  RHS = Source_seqn (attribute,name)
  ##
  ## Write the RHS of a source equation
  
  if strcmp(attribute,"external")
    RHS = sprintf("MTTu_%s",name);
   elseif strcmp(attribute,"internal")
     error(sprintf("attribute ""internal"" not appropriate for a \
 	source"));
  else
    RHS = attribute;
  endif
  
endfunction