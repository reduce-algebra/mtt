## -*-octave-*-

function [bonds,components,n_vector_bonds] = \
      ibg2abg(name,bonds,infofile,errorfile)

  ## write useful quantity of data to log
  struct_levels_to_print(6);

  ################################
  ## create component structure ##
  ################################
  
  ## loop over each bond in ibg.m file
  for [bond, bond_name] = bonds
    ## get the bond number
    bond_name
    i = str2num(strtok(bond_name, "bond"))

    ## populate "head" and "tail" structures
    ## then copy the contents to an overall structure

    ## track (signed) vector bond number within each component
    head.index = +i
    tail.index = -i

    ## extract type of component at each end
    head_type = deblank(char(strsplit(bond.head.component, ":"))(1,:))
    tail_type = deblank(char(strsplit(bond.tail.component, ":"))(1,:))

    ## extract name of component at each end
    head_name = deblank(char(strsplit(bond.head.component, ":"))(2,:))
    tail_name = deblank(char(strsplit(bond.tail.component, ":"))(2,:))

    ## extract port label data
    head.label = bond.head.ports
    tail.label = bond.tail.ports

    disp("--checking head and tail for components or ports --") 
    ## determine whether internal port or subsystem
    ## and fix names of ports
    if (strcmp(head_type, "SS") & (index(head_name, "[") == 1))
      head_comp_or_port = "port"
      head_name = mtt_strip_name(head_name);
    else
      head_comp_or_port = "comp"
    endif
    if (strcmp(tail_type, "SS") & (index(tail_name, "[") == 1))
      tail_comp_or_port = "port"
      tail_name = mtt_strip_name(tail_name);
    else
      tail_comp_or_port = "comp"
    endif

    ## copy data to object structure (objects)
    cmd = sprintf("objects.%s.%s.type = '%s';",
		  head_comp_or_port, head_name, head_type)
    eval(cmd)
    cmd = sprintf("objects.%s.%s.type = '%s';",
		  tail_comp_or_port, tail_name, tail_type)
    eval(cmd)
    
    cmd = sprintf("objects.%s.%s.bond%i = head;", 
		  head_comp_or_port, head_name, i)
    eval(cmd)
    cmd = sprintf("objects.%s.%s.bond%i = tail;", 
		  tail_comp_or_port, tail_name, i)
    eval(cmd)
  endfor    

  disp("--finished extracting data from ibg.m --")
  objects
    
  ## object structure:
  ##
  ## objects
  ##   comp
  ##     %s (name)
  ##       type
  ##       bond%i
  ##         label
  ##   port
  ##     %s (name)
  ##       type
  ##       bond%i
  ##         label
  ##
  ## "comp" contains components, subsystems and external SS
  ## "port" contains internal SS:[...]

  ####################################################
  ## count number of vector bonds on each component ##
  ####################################################

  if (isfield(objects, "comp"))
    for [comp, comp_name] = objects.comp
      n = size(fieldnames(comp))(1) - 1;
      eval(sprintf("objects.comp.%s.n_bonds = %i;",
		   comp_name, n));
    endfor
  endif
  
  if (isfield(objects, "port"))
    for [port, port_name] = objects.port
      n = size(fieldnames(port))(1) - 1;
      eval(sprintf("objects.port.%s.n_bonds = %i;",
		   port_name, n));
    endfor
  endif

  disp("-- finished counting number of bonds on components --")
  objects

  ## objects
  ##   comp
  ##     %s (name)
  ##       type
  ##       n_bonds
  ##       bond%i
  ##         label
  ##   port
  ##     %s (name)
  ##       type
  ##       n_bonds
  ##       bond%i
  ##         label

  ########################################################
  ## ensure labels exist on all ports of each component ##
  ########################################################

  if (isfield(objects, "comp"))
    for [comp, comp_name] = objects.comp
      if (strcmp(comp.type, "0") | strcmp(comp.type, "1"))

	## convert type
	if (strcmp(comp.type, "0"))
	  comp.type = "zero";
	elseif (strcmp(comp.type, "1"))
	  comp.type = "one";
	endif

	## component is a junction
	n_named_ports = 0;
	
	## get labelled ports
	for [bond, bond_name] = comp
	  if (index(bond_name, "bond") == 1)
	    if (! isfield (bond, "label"))
	      bond.label = "[]"
	    endif
	    if (! strcmp(bond.label, "[]"))
	      n_named_ports += 1;
	      port_label = bond.label;
	    endif
	  endif
	  eval(sprintf("comp.%s = bond;", bond_name));
	endfor
	
	## attach labels to unlabelled ports
	if (n_named_ports == 0)
	  mtt_info(sprintf("Defaulting all ports on junction %s to 'in'", \
			   comp_name), infofile);
	  for [bond, bond_name] = comp
	    if (index(bond_name, "bond") == 1)
	      bond.label = "in";
	    endif
	    eval(sprintf("comp.%s = bond;", bond_name));
	  endfor
	elseif (n_named_ports == 1)
	  mtt_info(sprintf("Defaulting all ports on junction %s to %s", \
			   comp_name, port_label), infofile);
	  for [bond, bond_name] = comp
	    if (index(bond_name, "bond") == 1)
	      bond.label = port_label;
	    endif
	    eval(sprintf("comp.%s = bond;", bond_name));
	  endfor
	elseif (n_named_ports != comp.n_bonds)
	  mtt_error(sprintf("Junction must have 0,1 or %i port labels", \
			    comp.n_bonds), errorfile);
	endif
	
      else
	## component is not a junction
	for [bond, bond_name] = comp
	  if (index(bond_name, "bond") == 1)
	    if (strcmp(bond.label, "[]"))
	      if (bond.index > 0)
		bond.label = "in";
	      else
		bond.label = "out";
	      endif
	    else
	      bond.label = mtt_strip_name(bond.label);
	    endif
	  endif
	  eval(sprintf("comp.%s = bond;", bond_name));
	endfor
      endif
      
      eval(sprintf("objects.comp.%s = comp;", comp_name));
    endfor
  endif

  ####################
  ## expand aliases ##
  ####################

  if (isfield(objects, "comp"))
    for [comp, comp_name] = objects.comp
      if ((! strcmp(comp.type, "zero")) & (! strcmp(comp.type, "one")))
	alias = eval(sprintf("%s_alias", comp.type));
	if (isstruct(alias))
	  for [bond, bond_name] = comp;
	    if (isstruct(bond))
	      if (isfield(alias, bond.label))
		old_name = bond.label;
		new_name = eval(sprintf("alias.%s", old_name));
		bond.label = new_name;
		mtt_info(sprintf("Aliasing [%s] on %s (%s) to [%s]",
				 old_name, comp_name, comp.type, new_name),
			 infofile);
	      endif
	    endif
	    eval(sprintf("comp.%s = bond;", bond_name));
	  endfor
	endif
	eval(sprintf("objects.comp.%s = comp;", comp_name));
      endif
    endfor
  endif

  disp("-- finished expanding aliases --")
  objects

  ## objects
  ##   comp
  ##     %s (name)
  ##       type
  ##       n_bonds
  ##       bond%i
  ##         label
  ##   port
  ##     %s (name)
  ##       type
  ##       n_bonds
  ##       bond%i
  ##         label

  ##########################################
  ## create sub-bonds according to labels ##
  ##########################################

  if (isfield(objects, "comp"))
    for [comp, comp_name] = objects.comp
      for [bond, bond_name] = comp
	if (index(bond_name, "bond") == 1)
	  [sub_bonds, n_sub_bonds] = split_port(bond.label);
	  for i = 1:n_sub_bonds
	    eval(sprintf("bond.subbond%i.label = '%s';",
			 i, deblank(sub_bonds(i,:))))
	  endfor
	endif
	eval(sprintf("comp.%s = bond;", bond_name));
      endfor
      eval(sprintf("objects.comp.%s = comp;", comp_name));
    endfor
  endif

  if (isfield(objects, "port"))
    for [port, port_name] = objects.port
      for [bond, bond_name] = port
	if (index(bond_name, "bond") == 1)
	  [sub_bonds, n_sub_bonds] = split_port(bond.label);
	  for i = 1:n_sub_bonds
	    eval(sprintf("bond.subbond%i.label = '%s';",
			 i, deblank(sub_bonds(i,:))));
	  endfor
	endif
	eval(sprintf("port.%s = bond;", bond_name));
      endfor
      eval(sprintf("objects.port.%s = port;", port_name));
    endfor
  endif

  disp("-- finished creating sub-bonds --")
  objects

  ## objects
  ##   comp
  ##     %s (name)
  ##       type
  ##       n_bonds
  ##       bond%i
  ##         label
  ##         subbond%i
  ##   port
  ##     %s (name)
  ##       type
  ##       n_bonds
  ##       bond%i
  ##         label
  ##         subbond%i

  #########################################
  ## assign a unique number to each bond ##
  #########################################

  unique_bond_number = 0;
  
  for [bond, bond_name] = bonds
    i = str2num(strtok(bond_name, "bond"));

    ## extract type of component at each end
    head.type = deblank(char(strsplit(bond.head.component, ":"))(1,:));
    tail.type = deblank(char(strsplit(bond.tail.component, ":"))(1,:));

    ## extract name of component at each end
    head_name = deblank(char(strsplit(bond.head.component, ":"))(2,:));
    tail_name = deblank(char(strsplit(bond.tail.component, ":"))(2,:));
 
    ## determine whether internal port or subsystem
    ## and fix names of ports
    if (strcmp(head.type, "SS") & (index(head_name, "[") == 1))
      head_comp_or_port = "port";
      head_name = mtt_strip_name(head_name);
    else
      head_comp_or_port = "comp";
    endif
    if (strcmp(tail.type, "SS") & (index(tail_name, "[") == 1))
      tail_comp_or_port = "port";
      tail_name = mtt_strip_name(tail_name);
    else
      tail_comp_or_port = "comp";
    endif

    ## create strings to reference each component
    head_str = sprintf("objects.%s.%s.bond%i",
		       head_comp_or_port, head_name, i)
    tail_str = sprintf("objects.%s.%s.bond%i",
		       tail_comp_or_port, tail_name, i)

    head_bond = eval(head_str);
    tail_bond = eval(tail_str);
    
    ## check compatible sizes
    head.n_subs = size(fieldnames(head_bond))(1) - 2;
    tail.n_subs = size(fieldnames(tail_bond))(1) - 2;
    if (head.n_subs != tail.n_subs)
      mtt_error(sprintf("Vector ports '%s' (%s:%s) and '%s' (%s:%s) are not compatible",
			head_bond.label, head.type, head_name,
			tail_bond.label, tail.type, tail_name),
		errorfile);
    elseif (head.n_subs > 1)
      mtt_info(sprintf("Vector port '%s'(%s:%s) matches '%s' (%s:%s)",
		       head_bond.label, head.type, head_name,
		       tail_bond.label, tail.type, tail_type),
	       infofile);
    endif

    ## write type at other end
    eval(sprintf("%s.other_end_type = '%s';",
		 head_str, tail.type));
    eval(sprintf("%s.other_end_type = '%s';",
		 tail_str, head.type));

    ## assign bond number
    for i = 1:head.n_subs
      ++unique_bond_number;
      eval(sprintf("%s.subbond%i.index = +%i;",
		   head_str, i, unique_bond_number));
      eval(sprintf("%s.subbond%i.index = -%i;",
		   tail_str, i, unique_bond_number));

      ## write causality for bond
      if (strcmp(bond.causality.effort, "head"))
	eval(sprintf("causality(%i,1) = +1;", unique_bond_number));
      elseif (strcmp(bond.causality.effort, "tail"))
	eval(sprintf("causality(%i,1) = -1;", unique_bond_number));
      else
	eval(sprintf("causality(%i,1) = 0;", unique_bond_number));
      endif

      if (strcmp(bond.causality.flow, "head"))
	eval(sprintf("causality(%i,2) = -1;", unique_bond_number));
      elseif (strcmp(bond.causality.flow, "tail"))
	eval(sprintf("causality(%i,2) = +1;", unique_bond_number));
      else
	eval(sprintf("causality(%i,2) = 0;", unique_bond_number));
      endif
      
    endfor
  endfor

  disp("-- finished assigning unique numbers to bonds --")
  objects
  
  ## objects
  ##   comp
  ##     %s (name)
  ##       type
  ##       n_bonds
  ##       bond%i
  ##         label
  ##         subbond%i
  ##           index
  ##   port
  ##     %s (name)
  ##       type
  ##       n_bonds
  ##       bond%i
  ##         label
  ##         subbond%i
  ##           index

  ## causality matrix is called "bonds"
  bonds = causality
  disp("-- finished writing bonds matrix --")  

  #################################
  ## map component data to cmp.m ##
  #################################

  ## count number of components
  if (isfield(objects, "comp"))
    n_comps = size(fieldnames(objects.comp), 1)
  else
    n_comps = 0;
  endif

  ## count number of internal ports
  if (isfield(objects, "port"))
    n_ports = size(fieldnames(objects.port), 1)
  else
    n_ports = 0;
  endif

  ## read data from _cmp.m
  for cmp = 1:(n_comps + n_ports)
    [this_type, this_name] = eval(sprintf("%s_cmp(%i)", name, cmp));
    ## determine if internal port (and fix name) or subsystem
    if (strcmp(this_type, "SS") & (index(this_name, "[") == 1))
      comp_or_port = "port";
      this_name = mtt_strip_name(this_name)
    else
      comp_or_port = "comp";
    endif
    eval(sprintf("objects.%s.%s.index = cmp;", comp_or_port, this_name));
  endfor

  disp("-- finished getting component indices from cmp.m --")
  objects

  ## objects
  ##   comp
  ##     %s (name)
  ##       type
  ##       n_bonds
  ##       bond%i
  ##         label
  ##         subbond%i
  ##           index
  ##       index
  ##   port
  ##     %s (name)
  ##       type
  ##       n_bonds
  ##       bond%i
  ##         label
  ##         subbond%i
  ##           index
  ##       index

  ##########################
  ## write n_vector_bonds ##
  ##########################

  if (isfield(objects, "comp"))
    for [comp, comp_name] = objects.comp
      n_vector_bonds(comp.index,1) = comp.n_bonds;
    endfor
  endif

  disp("-- finished writing n_vector_bonds --")
  n_vector_bonds

  ###########################################
  ## Write connections matrix (components) ##
  ###########################################
  
  if (isfield(objects, "comp"))
    n_comps = size(fieldnames(objects.comp))(1);
  else
    n_comps = 0;
  endif

  components = zeros(n_comps+n_ports, max(n_vector_bonds));

  if (isfield(objects, "comp"))
    for [comp, comp_name] = objects.comp
      ## get portlist for component      
      if exist([comp.type, '_cause']) == 0
 	eval(sprintf("ABG = %s_abg;", comp.type));
 	if isfield(ABG, "portlist")
 	  port_list = ABG.portlist;
 	else
 	  error(sprintf("Component %s has no ports", comp.type));
 	endif
      else
	## must be a simple component:
	## lib/comp/simple/comp_ports.m assigns port numbers
 	port_list = comp_ports(comp.type, comp.n_bonds)
      endif
      ## but do what with it?

      counter = 0;

      n_ports = size(port_list,1)
      if (strcmp(comp.type, "zero")) | (strcmp(comp.type, "one"))
	for port = 1 : n_ports
	  component_type = comp.type
	  the_port_list = port_list
	  the_port = port
	  label = port_list(port,:)
	  if (index (label, "[") == 1)
	    label = mtt_strip_name(label)
	  endif
	  label = deblank(label)
	  
	  for [bond, bond_name] = comp
	    if (index(bond_name, "bond") == 1)
	      for [sub_bond, sub_bond_name] = bond
		
		if (index(sub_bond_name, "subbond") == 1)
		  sub_bond_label = sub_bond.label
		  if (index (sub_bond_label, "[") == 1)
		    sub_bond_label = mtt_strip_name(sub_bond_label)
		  endif
		  sub_bond_label = deblank(sub_bond_label)
		  		  
		  if (strcmp(sub_bond_label, label) | strcmp (sub_bond_label,"in"))
		    components(comp.index, ++counter) = sub_bond.index
		  endif
		  
		endif
	      endfor
	    endif
	  endfor
	endfor
	
      elseif (n_ports == 1)
	## no ordering necessary
	for [bond, bond_name] = comp
	  if (index(bond_name, "bond") == 1)
	    for [sub_bond, sub_bond_name] = bond
	      if (index(sub_bond_name, "subbond") == 1)
		components(comp.index, ++counter) = sub_bond.index
	      endif
	    endfor
	  endif
	endfor

      else
	## multiple ports, need to order them
	for port = 1 : n_ports
	  component_type = comp.type
	  the_port_list = port_list
	  the_port = port
	  label = port_list(port,:)
	  if (index (label, "[") == 1)
	    label = mtt_strip_name(label)
	  endif
	  label = deblank(label)
		    	  
	  for [bond, bond_name] = comp
	    if (index(bond_name, "bond") == 1)
	      for [sub_bond, sub_bond_name] = bond

		if (index(sub_bond_name, "subbond") == 1)
		  sub_bond_label = sub_bond.label
		  if (index (sub_bond_label, "[") == 1)
		    sub_bond_label = mtt_strip_name(sub_bond_label)
		  endif
		  sub_bond_label = deblank(sub_bond_label)

		  ## unalias sub_bond label
		  if exist([comp.type, '_alias'])
		    eval(sprintf("alias = %s_alias", comp.type))
		    if isstruct(alias)
		      while_counter = 0;
		      while isfield(alias, sub_bond_label)
			old_sub_bond_label = sub_bond_label;
			sub_bond_label = eval(sprintf("alias.%s", sub_bond_label))
			if strcmp(old_sub_bond_label, sub_bond_label)
			  break;
			endif
		      endwhile
		    endif
		  endif
		    
		  if (strcmp(sub_bond_label, label))
		    components(comp.index, ++counter) = sub_bond.index
		  endif

		endif
	      endfor
	    endif
	  endfor
	endfor

      endif
    endfor
  endif
  disp("-- finished getting port_list --")
  port_list
  
   if (isfield(objects, "port"))
     for [port, port_name] = objects.port
       counter = 0;
       for [bond, bond_name] = port
 	if (index(bond_name, "bond") == 1)
 	  for [sub_bond, sub_bond_name] = bond
 	    if (index(sub_bond_name, "subbond") == 1)
 	      components(port.index, ++counter) = sub_bond.index;
 	    endif
 	  endfor
 	endif
       endfor
     endfor
   endif

  disp("-- finished writing components matrix --")
  components

endfunction
