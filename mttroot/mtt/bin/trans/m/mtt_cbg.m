function cbg = mtt_cbg (name)

  ## usage:  cbg = mtt_cbg (name)
  ##
  ## Gets the cbg (causal bond graph) structure for system name
  ## Copyright (C) 2003 by Peter J. Gawthrop


  ## File name   
  cbg_file = sprintf("%s_cbg",name);

  if (exist(cbg_file)==0)
    error(sprintf("mtt_component_eqn: subystem \"%s\" does not exist", name));
  endif
  
  ## Subsystem data structure
  cbg = eval(sprintf("%s;", cbg_file));

endfunction