## -*-octave-*-

function [bonds,components,n_vector_bonds] = ibg2abg(name,bonds, \
						     infofile, \
						     errorfile)

  ## Provide useful data for log
  struct_levels_to_print = 5;

  ## Find number of bonds
  [n_bonds, junk] = size(struct_elements(bonds));

  ## Get components
  max_bonds_on_component = 0;

  for i = 1:n_bonds
    eval(sprintf("bond = bonds.b%i", i));

    ## heads
    head_type_name = bond.head.component;
    head_type_name = deblank(split(head_type_name, ":"));
    head_type = deblank(head_type_name(1,:));
    head_name = deblank(head_type_name(2,:));
    if (exist("component_struct"))
      if (struct_contains(component_struct, head_name))
	## create a copy to work on - clearer than eval(sprintf(...))
	## (pointers would be better still!)
	eval(sprintf("head = component_struct.%s;", head_name));
      endif
    endif
    head.type = head_type;
    if (!struct_contains(head,"bonds"))
      head.n_bonds = 1;
      head.bonds = [+i];
      head.named_ports = !strcmp(bond.head.ports, "[]");
    else
      head.n_bonds = head.n_bonds + 1;
      head.bonds = [head.bonds, +i];
      head.named_ports = head.named_ports + !strcmp(bond.head.ports, \
						    "[]");
    endif
    eval(sprintf("head.ports.bond%i.name = '%s'", i, bond.head.ports));
    eval(sprintf("head.ports.bond%i.sign = '[in]'", i));
    max_bonds_on_component = max(max_bonds_on_component, \
				 head.n_bonds)
    eval(sprintf("component_struct.%s = head", head_name));
    clear head;

    ## tails
    tail_type_name = bond.tail.component;
    tail_type_name = deblank(split(tail_type_name, ":"));
    tail_type = deblank(tail_type_name(1,:));
    tail_name = deblank(tail_type_name(2,:));
    if (exist("component_struct"))
      if (struct_contains(component_struct, tail_name))
	## create a copy to work on - clearer than eval(sprintf(...))
	tail = eval(sprintf("tail = component_struct.%s", tail_name));
      endif
    endif
    tail.type = tail_type;
    if (!struct_contains(tail,"bonds"))
      tail.n_bonds = 1;
      tail.bonds = [-i];
      tail.named_ports = !strcmp(bond.tail.ports, "[]");
    else
      tail.n_bonds = tail.n_bonds + 1
      tail.bonds = [tail.bonds, -i];
      tail.named_ports = tail.named_ports + !strcmp(bond.tail.ports, \
						    "[]");
    endif
    eval(sprintf("tail.ports.bond%i.name = '%s'", i, bond.tail.ports));
    eval(sprintf("tail.ports.bond%i.sign = '[out]'", i));
    max_bonds_on_component = max(max_bonds_on_component, \
				 tail.n_bonds);
    eval(sprintf("component_struct.%s = tail", tail_name));
    clear tail;

    ## causality
    if (bond.causality.effort == "head")
      causality(i,1) = +1;
    elseif (bond.causality.effort == "tail")
      causality(i,1) = -1;
    else
      causality(i,1) = 0;
    endif

    if (bond.causality.flow == "head")
      causality(i,2) = -1;
    elseif (bond.causality.flow == "tail")
      causality(i,2) = +1;
    else
      causality(i,2) = 0;
    endif

  endfor
  
  ## Get component indices from sys_cmp.m
  [n_components, junk] = size(struct_elements(component_struct));
  for i = 1:n_components
    [comp_type, comp_name] = eval(sprintf("%s_cmp(%i)", name, i));
    eval(sprintf("component_struct.%s.index = %i", comp_name, i));
  endfor

  ## Create the connections matrix (components)
  components = zeros(n_components, max_bonds_on_component);
  for [comp, comp_name] = component_struct
    components(comp.index,1:comp.n_bonds) = comp.bonds;
  endfor
  
  for [comp, comp_name] = component_struct
    ## default port names
    if ((strcmp(deblank(comp.type), "0")) || (strcmp(deblank(comp.type), "1")))
      disp("---- default junctions ----");
      if (comp.named_ports == 1) # one named port
	for [port, bond_number] = comp.ports
	  if (!strcmp(port.name,"[]"))
	    junction_port_name = port.name;
	  endif
	endfor
	mtt_info(sprintf("Defaulting all ports on junction %s to %s", \
			 comp_name, junction_port_name));
	for [port, bond_number] = comp.ports
	  port.name = junction_port_name;
	endfor	
      elseif ((comp.named_ports != 0) && (comp.named_ports != \
					  comp.n_bonds)) # not allowed
	mtt_error(sprintf("Junction %s must have 0, 1 or %i port labels", \
			  comp_name, comp.n_bonds));
      endif
    else			# Not a junction
      unlabelled_ports = comp.n_bonds - comp.named_ports;
      if (unlabelled_ports == 1)
	## find unlabelled ports
	for [port, bond_number] = comp.ports
	  if (strcmp(deblank(port.name), "[]"))
	    ## found it - default to "in" or "out"
	    eval(sprintf("comp.ports.%s.name = port.sign", bond_number));
	    mtt_info(["Defaulting port name [" port.sign "]\t on component " \
		      comp_name " (" deblank(comp.type) ")"], infofile);
	  endif
	endfor
      elseif (unlabelled_ports == 2)
	## find unlabelled ports
	for [port, bond_number] = comp.ports
	  if (strcmp(deblank(port.name), "[]"))
	    ## got one
	    if (exist("unlabelled_port1"))
	      unlabelled_port2 = port;
	      bond_number2 = bond_number;
	    else
	      unlabelled_port1 = port;
	      bond_number1 = bond_number;
	    endif
	  endif
	endfor
	if (strcmp(unlabelled_port1.sign, "[in]") && \
	    strcmp(unlabelled_port2.sign, "[in]"))
	  mtt_error(["More than one unlabelled INport on component " \
		     comp_name " (" deblank(comp.type) ")"], errorfile);
	elseif (strcmp(unlabelled_port1.sign, "[out]") && \
		strcmp(unlabelled_port2.sign, "[out]"))
	  mtt_error(["More than one unlabelled OUTport on component " \
		     comp_name " (" deblank(comp.type) ")"], errorfile);
	else
	  eval(sprintf("comp.ports.%s.name = \
	  unlabelled_port1.sign", bond_number1));
	  mtt_info(["Defaulting port name [" unlabelled_port1.sign
		    "]\t on component "  comp_name " (" \
		    deblank(comp.type) ")"], infofile);
	  eval(sprintf("comp.ports.%s.name = \
	  unlabelled_port2.sign", bond_number2));
	  mtt_info(["Defaulting port name [" unlabelled_port2.sign
		    "]\t on component "  comp_name " (" \
		    deblank(comp.type) ")"], infofile);
	endif
      endif

      ## strip port names of blanks and []
      for [port, port_name] = comp.ports
	eval(sprintf("comp.ports.%s.name = \
	mtt_strip_name(comp.ports.%s.name)", port_name, port_name));
      endfor
      
      ## replace aliases
      eval(sprintf("alias = %s_alias", comp.type))
      if (is_struct(alias))
	for [port, port_name] = comp.ports
	  if (struct_contains(alias,port_name))
	    eval(sprintf("new_port_name = alias.%s", port.name))
	    mtt_info(sprintf("Aliasing name [%s]\t on component %s (%s) to \
	    [%s]", port.name, comp_name, comp.type, new_port_name), \
		     infofile);
	    eval(sprintf("comp.ports.%s.name = new_port_name", port_name))
	  endif
	endfor
      endif
      
    endif

    eval(sprintf("component_struct.%s = comp", comp_name));    
  endfor

  ## All ports should bow be labelled
  disp("--- Completed portnames and the corresponding bonds ---");

  ## Create list of bonds
  bonds = causality;

  ## Find number of bonds on each component BEFORE vectorisation
  for [comp, comp_name] = component_struct
    n_vector_bonds(comp.index) = comp.n_bonds;
  endfor

  ## Now expand vector ports
  disp("Expanding vector ports");
  disp("... but not today!");
  ## ???

  components;
  n_vector_bonds = 1;
endfunction