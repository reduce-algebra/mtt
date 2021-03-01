function [in_components,in_ports,in_bonds] = mtt_other_end (name,all_in_bonds,cbg);

  ## usage:  [in_components,in_ports,in_bonds] = mtt_other_end (name,all_in_bonds,cbg);
  ##
  ## 

  ## What components are at the other ends of the in bonds?
  in_components = "";
  in_ports = [];
  in_bonds = [];
  in_direction = [];
  for i = 1:length(all_in_bonds);
    for [component_structure, component] = cbg.subsystems
      if !strcmp(name,component)
	other_connections = component_structure.connections;
	one = ones(size(other_connections));
	port = find(abs(all_in_bonds(i))*one==abs(other_connections));
	if (length(port)==1)
	  in_components = [in_components; component];
	  in_bonds = [in_bonds; all_in_bonds(i)];
	  in_ports = [in_ports; port];
	endif
      endif
    endfor
  endfor

endfunction