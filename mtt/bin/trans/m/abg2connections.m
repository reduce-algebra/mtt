## -*-octave-*- put Emacs into Octave mode
##
##     ###################################### 
##     ##### Model Transformation Tools #####
##     ######################################
##
## abg2connections_m
##
## Creates a cell array recording the name of the
## component at each end of every bond.
##
## This data may differ from ibg.m because of the
## expansion of vector bonds that takes place
## during the generation of abg.m

function connections = abg2connections (abg)

  substructures = {"ports", "subsystems"};

  for i = [1,2]
    substruct = substructures{i};
    
    if (isfield (abg, substruct))
      for [val, key] = eval (sprintf ("abg.%s", substruct))
	for bond_id = val.connections
	  if (bond_id > 0)
	    connections.head {+bond_id} = key
	  else
	    connections.tail {-bond_id} = key
	  endif
	endfor
      endfor
    endif

  endfor

endfunction

