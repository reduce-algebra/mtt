function NewType = mtt_type_name (OldType)

  ## usage:  NewType = mtt_type_name (OldType)
  ##
  ## 

  if OldType=="0";
    NewType = "Zero";
  elseif OldType=="1";
    NewType = "One";
  else
    NewType = OldType;
  endif

endfunction