## -*-octave-*-

function [bonds,components,n_vector_bonds] = \
      ibg2abg(name,bonds,infofile,errorfile)

  ## write useful quantity of data to log
  struct_levels_to_print = 5;



  ###############################################
  ## Extract data from bonds structure (ibg.m) ##
  ###############################################
  disp("--- Started extracting bonds data ---")

  ## unique number for each (sub-) bond
  bond_number = 0;

  ## extract data from each bond
  for [bond, bond_name] = bonds
    i = str2num(split(bond_name, "bond")(2,:))

    ## extract type and name of component at each end
    head.name = deblank(split(bond.head.component, ":")(2,:));
    head.type = deblank(split(bond.head.component, ":")(1,:));
    tail.name = deblank(split(bond.tail.component, ":")(2,:));
    tail.type = deblank(split(bond.tail.component, ":")(1,:));

    ## assign vector bond index
    head.index = i;
    tail.index = i;

    ## determine if internal port (and fix name) or subsystem
    if (strcmp(head.type, "SS") & (index(head.name, "[") == 1))
      head.is_port = true;
      head.name = mtt_strip_name(head.name);
    else
      head.is_port = false;
    endif
    if (strcmp(tail.type, "SS") & (index(tail.name, "[") == 1))
      tail.is_port = true;
      tail.name = mtt_strip_name(tail.name);
    else
      tail.is_port = false;
    endif

    ## determine if junction
    if (strcmp(head.type, "0") | (strcmp(head.type, "1")))
      head.is_junction = true;
    else
      head.is_junction = false;
    endif
    if (strcmp(tail.type, "0") | (strcmp(tail.type, "1")))
      tail.is_junction = true;
    else
      tail.is_junction = false;
    endif

    ## assign (vector) port names
###    if (! head.is_junction)
      if (strcmp(bond.head.ports, "[]"))
	head.label = "in";
	mtt_info(sprintf("Defaulting port name %s on component %s (%s)",
			 head.label, head.name, head.type), infofile);
      else
	head.label = mtt_strip_name(bond.head.ports);
      endif
###    endif
###    if (! tail.is_junction)
      if (strcmp(bond.tail.ports, "[]"))
	tail.label = "out";
	mtt_info(sprintf("Defaulting port name %s on component %s (%s)",
			 tail.label, tail.name, tail.type), infofile);
      else
	tail.label = mtt_strip_name(bond.tail.ports);
      endif
###    endif

    ## apply aliases
      if (! head.is_junction)
      head.alias = eval(sprintf("%s_alias", head.type));
      if (is_struct(head.alias))
	if (struct_contains(head.alias, head.label))
	  old_name = head.label;
	  new_name = eval(sprintf("head.alias.%s", old_name));
	  head.label = new_name;	
	  mtt_info(sprintf("Aliasing [%s]\t on component %s (%s) to [%s]",
			   old_name, head.name, head.type, new_name), \
		   infofile);
	endif
      endif
    endif
    if (!tail.is_junction)
      tail.alias = eval(sprintf("%s_alias", tail.type));
      if (is_struct(tail.alias))
	if (struct_contains(tail.alias, tail.label))
	  old_name = tail.label;
	  new_name = eval(sprintf("tail.alias.%s", old_name));
	  tail.label = new_name;	
	  mtt_info(sprintf("Aliasing [%s]\t on component %s (%s) to [%s]",
			   old_name, tail.name, tail.type, new_name), \
		   infofile);
	endif
      endif
    endif

    ## expand vector bonds
    disp("--- Expanding vector bonds ---");
    [head.sub_bonds, head.n_sub_bonds] = split_port(head.label)
    [tail.sub_bonds, tail.n_sub_bonds] = split_port(tail.label)
    if (head.n_sub_bonds != tail.n_sub_bonds)
      mtt_error(sprintf("Vector ports %s and %s are not compatible",
			head.label, tail.label), errorfile);
    elseif (head.n_sub_bonds > 1)
      mtt_info(sprintf("Vector port %s matching %s",
		       head.label, tail.label), infofile);
    endif

    ## assign unique number and causality to each sub-bond
    for sub_bond = 1:head.n_sub_bonds
      ++bond_number;

      eval(sprintf("head.bond%i.index = %i", sub_bond, +bond_number));
      eval(sprintf("tail.bond%i.index = %i", sub_bond, -bond_number));

      ## effort causality
      if (strcmp(bond.causality.effort, "head"))
	causality(bond_number, 1) = +1;
      elseif (strcmp(bond.causality.effort, "tail"))
	causality(bond_number, 1) = -1;
      else
	causality(bond_number, 1) = 0;
      endif

      ## flow causality
      if (strcmp(bond.causality.flow, "head"))
	causality(bond_number, 2) = -1;
      elseif (strcmp(bond.causality.flow, "tail"))
	causality(bond_number, 2) = +1;
      else
	causality(bond_number, 2) = 0;
      endif

      eval(sprintf("head.bond%i.port = deblank(head.sub_bonds(%i,:))",
		   sub_bond, sub_bond));
      eval(sprintf("tail.port%i.port = deblank(tail.sub_bonds(%i,:))",
		   sub_bond, sub_bond));

    endfor

    ## copy bond data to component structure (comp_s)
    if (head.is_port)
      eval(sprintf("comp_s.port.%s.vector_bond%i = head", 
		   head.name, i));
    else
      eval(sprintf("comp_s.comp.%s.vector_bond%i = head",
		   head.name, i));
    endif
    if (tail.is_port)
      eval(sprintf("comp_s.port.%s.vector_bond%i = tail", 
		   tail.name, i));
    else
      eval(sprintf("comp_s.comp.%s.vector_bond%i = tail",
		   tail.name, i));
    endif
  endfor

  bonds = causality;

  disp("--- Finished extracting bond data ---");


  #################################
  ## Map component data to cmp.m ##
  #################################

  ## count number of components
  if (struct_contains(comp_s, "comp"))
    n_comps = size(struct_elements(comp_s.comp), 1);
  else
    n_comps = 0;
  endif

  ## count number of internal ports
  if (struct_contains(comp_s, "port"))
    n_ports = size(struct_elements(comp_s.port), 1);
  else
    n_ports = 0;
  endif

  ## read data from _cmp.m
  ## write n_vector_bonds
  for cmp = 1:(n_comps + n_ports)
    [this_type, this_name] = eval(sprintf("%s_cmp(%i)", name, cmp));
    ## determine if internal port (and fix name) or subsystem
    if (strcmp(this_type, "SS") & (index(this_name, "[") == 1))
      comp_or_port = "port";
      this_name = mtt_strip_name(this_name);
    else
      comp_or_port = "comp";
    endif
    eval(sprintf("comp_s.%s.%s.index = cmp", comp_or_port, this_name));
  endfor

  disp("--- Finished reading _cmp.m ---");

  ##########################
  ## Write n_vector_bonds ##
  ##########################
  for [comp, comp_name] = comp_s.comp
    i = 0;
    for [val, key] = comp
      if (index(key, "vector_bond") == 1)
	++i;
      endif
    endfor
    n_vector_bonds(comp.index) = i;
  endfor

  ###########################################
  ## Write connections matrix (components) ##
  ###########################################
  
  components = zeros(n_comps, max(n_vector_bonds));
  if (struct_contains(comp_s, "comp"))
    for [comp, comp_name] = comp_s.comp
      counter = 0;
      bond_list = zeros(1, max(n_vector_bonds));
      for [vbond, vbond_name] = comp
	if (index(vbond_name, "vector_bond") == 1)
	  for [sbond, sbond_name] = vbond
	    if (index(sbond_name, "bond") == 1)
	      components(comp.index, ++counter) = sbond.index;
	    endif
	  endfor
	endif
      endfor
    endfor
  endif

  disp("--- Finished writing components ---")

endfunction


## TODO: to fix 1-label vector junctions
## TODO: to put error checks back in
## TODO: port_bond_list error (abg2cbg)

#   ##########################################
#   ## Assign names to all component ports  ##
#   ##########################################
#   disp("--- Assigning port names ---")

#   if (struct_contains(comp_S, "comp"))
#     for [comp, comp_name] = comp_S.comp
#       if (strcmp(comp.type, "0") || strcmp(comp.type, "1"))
# 	disp("---- default junctions ----")
# 	if (comp.named_ports == 1)
	  
# 	  ## one named port, find it ...
# 	  for [port, bond_number] = comp.ports
# 	    if (! strcmp(port.name, "[]"))
# 	      the_name = port.name
# 	    endif
# 	  endfor
	  
# 	  ## ... and name all remaining ports identically
# 	  mtt_info(sprintf("Defaulting all ports on junction %s to %s",
# 			   comp_name, the_name));
# 	  for [port, bond_number] = comp.ports
# 	    eval(sprintf("comp.ports.%s.name = the_name", bond_number));
# 	  endfor
	  
# 	elseif ((comp.named_ports != 0)
# 		&& (comp.named_ports != comp.n_vector_bonds))
# 	  mtt_error(sprintf("Junction %s must have 0, 1 or %i port \
# 						       labels", \
# 			    comp_name, comp.n_vector_bonds));
# 	endif
	
#       else
	
# 	## Not a junction
# 	unlabelled_ports = comp.n_vector_bonds - comp.named_ports;
# 	if (unlabelled_ports == 1)
	  
# 	  ## find the unlabelled port ...
# 	  for [port, bond_number] = comp.ports
# 	    if (strcmp(port.name, "[]"))
	      
# 	      ## ... and name it [in] or [out]
# 	      if (port.sign == +1)
# 		port_name = "[in]";
# 	      elseif (port.sign == -1)
# 		port_name = "[out]";
# 	      endif
# 	      eval(sprintf("comp.ports.%s.name = '%s'",
# 			   bond_number, port_name));
# 	      E = "Defaulting port name %s\t on component %s (%s)";
# 	      mtt_info(sprintf(E, port_name, comp_name, comp.type),
# 		       infofile);
# 	    endif
# 	  endfor
	  
# 	elseif (unlabelled_ports == 2)
	  
# 	  ## find the unlabelled ports ...
# 	  clear unlabelled_port1
# 	  for [port, bond_number] = comp.ports
# 	    if (strcmp(port.name, "[]"))
# 	      if (exist("unlabelled_port1"))
# 		unlabelled_port2 = port;
# 		bond_number2 = bond_number;
# 	      else
# 		unlabelled_port1 = port;
# 		bond_number1 = bond_number;
# 	      endif
# 	    endif
# 	  endfor
	  
# 	  ## ... and try to assign [in] and [out]
# 	  if ((unlabelled_port1.sign == +1)
# 	      && (unlabelled_port2.sign == +1))
# 	    E = "More than one unlabelled INport on component %s (%s)";
# 	    mtt_error(sprintf(E, comp_name, comp.type));
# 	  elseif ((unlabelled_port1.sign == -1)
# 		  && (unlabelled_port2.sign == -1))
# 	    E = "More than one unlabelled OUTport on component %s (%s)";
# 	    mtt_error(sprintf(E, comp_name, comp.type));
# 	  else
# 	    if (unlabelled_port1.sign == +1)
# 	      name1 = "[in]";
# 	      name2 = "[out]";
# 	    elseif (unlabelled_port1.sign == -1)
# 	      name1 = "[out]";
# 	      name2 = "[in]";
# 	    endif
# 	    eval(sprintf("comp.ports.%s.name = '%s'",
# 			 bond_number1, name1));
# 	    eval(sprintf("comp.ports.%s.name = '%s'",
# 			 bond_number2, name2));
# 	    S = "Defaulting port name %s\t on component %s (%s)"    
# 	    mtt_info(sprintf(S, name1, comp_name, comp.type), infofile);
# 	    mtt_info(sprintf(S, name2, comp_name, comp.type), infofile);
# 	  endif
# 	endif
		
#       endif 
#       eval(sprintf("comp_S.comp.%s = comp", comp_name));
#     endfor
#   endif

#   disp(" --- Finished assigning port names ---")


# endfunction
