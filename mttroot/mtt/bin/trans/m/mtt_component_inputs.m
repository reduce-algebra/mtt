function [in_bonds,in_components,in_ports,N] = mtt_component_inputs ...
      (name,comp_type, out_causality, causality,comp_bonds,bond_list,cbg)

  ## usage:  [in_bonds,in_components,in_ports,N] = mtt_component_inputs 
  ##      (name,comp_type, out_causality, causality,comp_bonds,bond_list,cbg)
  ##
  ## 


  ## Other causality representations  if strcmp(causality,"effort")
  if strcmp(causality,"effort")
    i_cause = 1;
    othercausality = "flow";
    index_cause = 1;
  elseif strcmp(causality,"flow")
    i_cause = -1;
    othercausality = "effort";
    index_cause = 2;
  else
    error(sprintf("mtt_component_eqn: causality %s invalid", causality));
  endif
  
  in_index = find(comp_bonds(:,index_cause)==i_cause);
  all_in_bonds = bond_list(in_index);
  N_all = length(all_in_bonds);

  ## What components are at the other ends of the in bonds?
  [in_components,in_ports,in_bonds] = mtt_other_end (name,all_in_bonds,cbg);
  N = length(in_bonds);
endfunction