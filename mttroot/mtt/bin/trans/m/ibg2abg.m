## -*-octave-*-

function [bonds,components,n_vector_bonds] = \
      ibg2abg(name,bonds,infofile,errorfile)

  ## write useful quantity of data to log
  struct_levels_to_print = 5;



  ###############################################
  ## Extract data from bonds structure (ibg.m) ##
  ###############################################
  disp("--- Started extracting bonds data ---")

  ## find number of bonds
  n_bonds = size(struct_elements(bonds), 1);

  ## need to determine size(,2) of components
  max_bonds_on_component = 0;

  ## extract data from each bond
  for [bond, bond_name] = bonds
    i = str2num(split(bond_name, "bond")(2,:))
    for [val, key] = bond
      if (struct_contains(val, "component")) 

	## val is a terminus, key is "head" or "tail"
	if (strcmp(key, "head"))
	  direction = +1;
	elseif (strcmp(key, "tail"))
	  direction = -1;
	else
	  error(sprintf("%s is not 'head' or 'tails'", key));
	endif

	## extract type and name of component
	type_name = deblank(split(val.component, ":"));
	this_type = deblank(type_name(1,:));
	this_name = deblank(type_name(2,:));

	## determine if internal port (and fix name) or subsystem
	if (strcmp(this_type, "SS") && (index(this_name, "[") == 1))
	  comp_or_port = "port";
	  this_name = mtt_strip_name(this_name);
	else
	  comp_or_port = "comp";
	endif

	## create working copy (if master exists)
	S = sprintf("comp_S.%s", comp_or_port);
	T = sprintf("%s.%s", S, this_name);
	if (exist(sprintf(S)) && struct_contains(eval(S), this_name))
	  this = eval(T);
	endif

	this.name = this_name;
	this.type = this_type;

	## initialise structure if we haven't seen this component yet
	if ((! exist("this")) || (! struct_contains(this, "bonds")))
	  this.n_bonds = 0;
	  this.bonds = [];
	  this.named_ports = 0;
	endif
	
	## extract bond data
	++this.n_bonds;
	this.bonds = [this.bonds, direction * i];
	
	port_name = eval(sprintf("bond.%s.ports", key));
	if (! strcmp(port_name, "[]"))
	  ++this.named_ports;
	endif
	
	## extract port data
	eval(sprintf("this.ports.%s.name = bond.%s.ports",
		     bond_name, key));
	eval(sprintf("this.ports.%s.bond = %i", bond_name, i));
	eval(sprintf("this.ports.%s.sign = %i", bond_name, direction));

	## check if this has the most bonds
	if (this.n_bonds > max_bonds_on_component)
	  max_bonds_on_component = this.n_bonds;
	endif
	
	## copy back to master
	eval(sprintf("comp_S.%s.%s = this", comp_or_port, this_name));
	clear this;
	
      else			# val is not a terminus => causality
	
	## extract effort  causality information
	if (strcmp(bond.causality.effort, "head"))
	  causality(i,1) = +1;
	elseif (strcmp(bond.causality.effort, "tail"))
	  causality(i,1) = -1;
	else
	  causality(i,1) = 0;
	endif

	## extract flow causality information
	if (strcmp(bond.causality.flow, "head"))
	  causality(i,2) = -1;
	elseif (strcmp(bond.causality.flow, "tail"))
	  causality(i,2) = +1;
	else
	  causality(i,2) = 0;
	endif
	
      endif      
    endfor			# finished extracting data from this bond
  endfor			# finished extracting data from all bonds


  disp("--- Writing comp_S ---")
  comp_S
  disp("--- Finished extracting bonds data ---")



  #################################
  ## Map component data to cmp.m ##
  #################################
  disp("--- Started extracting cmp.m data ---")

  ## count number of components
  if (struct_contains(comp_S, "comp"))
    n_comps = size(struct_elements(comp_S.comp),1);
  else
    n_comps = 0;
  endif

  ## count number of internal ports
  if (struct_contains(comp_S, "port"))
    n_ports = size(struct_elements(comp_S.port),1);
  else
    n_ports = 0;
  endif

  ## read index from _cmp.m
  for i = 1:(n_comps + n_ports)
    [this_type, this_name] = eval(sprintf("%s_cmp(%i)", name, i));
    ## determine if internal port (and fix name) or subsystem
    if (strcmp(this_type, "SS") && (index(this_name, "[") == 1))
      comp_or_port = "port";
      this_name = mtt_strip_name(this_name);
    else
      comp_or_port = "comp";
    endif
    eval(sprintf("comp_S.%s.%s.index = %i", \
		 comp_or_port, this_name, i));
  endfor
      
  disp("--- Writing comp_S ---")
  comp_S
  disp("--- Finished extracting cmp.m data ---")



  ###########################################
  ## Start connections matrix (components) ##
  ###########################################
  disp("--- Started creating components ---")
  
  components = zeros(n_comps, max_bonds_on_component);
  if (struct_contains(comp_S, "comp"))
    for [comp, comp_name] = comp_S.comp
      components(comp.index,1:comp.n_bonds) = comp.bonds;
    endfor
  endif

  disp("--- Writing components ---")
  if (exist("components")) components endif
  disp("--- Halted creating components ---")



  ##########################################
  ## Assign names to all component ports  ##
  ##########################################
  disp("--- Assigning port names ---")

  if (struct_contains(comp_S, "comp"))
    for [comp, comp_name] = comp_S.comp
      if (strcmp(comp.type, "0") || strcmp(comp.type, "1"))
	disp("---- default junctions ----")
	if (comp.named_ports == 1)
	  
	  ## one named port, find it ...
	  for [port, bond_number] = comp.ports
	    if (! strcmp(port.name, "[]"))
	      the_name = port.name
	    endif
	  endfor
	  
	  ## ... and name all remaining ports identically
	  mtt_info(sprintf("Defaulting all ports on junction %s to %s",
			   comp_name, the_name));
	  for [port, bond_number] = comp.ports
	    eval(sprintf("comp.ports.%s.name = the_name", bond_number));
	  endfor
	  
	elseif ((comp.named_ports != 0)
		&& (comp.named_ports != comp.n_bonds))
	  mtt_error(sprintf("Junction %s must have 0, 1 or %i port \
						       labels", \
			    comp_name, comp.n_bonds));
	endif
	
      else
	
	## Not a junction
	unlabelled_ports = comp.n_bonds - comp.named_ports;
	if (unlabelled_ports == 1)
	  
	  ## find the unlabelled port ...
	  for [port, bond_number] = comp.ports
	    if (strcmp(port.name, "[]"))
	      
	      ## ... and name it [in] or [out]
	      if (port.sign == +1)
		port_name = "[in]";
	      elseif (port.sign == -1)
		port_name = "[out]";
	      endif
	      eval(sprintf("comp.ports.%s.name = '%s'",
			   bond_number, port_name));
	      E = "Defaulting port name %s\t on component %s (%s)";
	      mtt_info(sprintf(E, port_name, comp_name, comp.type),
		       infofile);
	    endif
	  endfor
	  
	elseif (unlabelled_ports == 2)
	  
	  ## find the unlabelled ports ...
	  clear unlabelled_port1
	  for [port, bond_number] = comp.ports
	    if (strcmp(port.name, "[]"))
	      if (exist("unlabelled_port1"))
		unlabelled_port2 = port;
		bond_number2 = bond_number;
	      else
		unlabelled_port1 = port;
		bond_number1 = bond_number;
	      endif
	    endif
	  endfor
	  
	  ## ... and try to assign [in] and [out]
	  if ((unlabelled_port1.sign == +1)
	      && (unlabelled_port2.sign == +1))
	    E = "More than one unlabelled INport on component %s (%s)";
	    mtt_error(sprintf(E, comp_name, comp.type));
	  elseif ((unlabelled_port1.sign == -1)
		  && (unlabelled_port2.sign == -1))
	    E = "More than one unlabelled OUTport on component %s (%s)";
	    mtt_error(sprintf(E, comp_name, comp.type));
	  else
	    if (unlabelled_port1.sign == +1)
	      name1 = "[in]";
	      name2 = "[out]";
	    elseif (unlabelled_port1.sign == -1)
	      name1 = "[out]";
	      name2 = "[in]";
	    endif
	    eval(sprintf("comp.ports.%s.name = '%s'",
			 bond_number1, name1));
	    eval(sprintf("comp.ports.%s.name = '%s'",
			 bond_number2, name2));
	    S = "Defaulting port name %s\t on component %s (%s)"    
	    mtt_info(sprintf(S, name1, comp_name, comp.type), infofile);
	    mtt_info(sprintf(S, name2, comp_name, comp.type), infofile);
	  endif
	endif
		
      endif 
      eval(sprintf("comp_S.comp.%s = comp", comp_name));
    endfor
  endif

  disp(" --- Finished assigning port names ---")



  ###################
  ## Apply aliases ##
  ###################
  disp(" --- Applying aliases --- ")

  for [comp, comp_or_port] = comp_S
    for [this, this_name] = comp
      if (! (strcmp(this.type, "0") || strcmp(this.type, "1")))
	eval(sprintf("alias = %s_alias", this.type));
	if (is_struct(alias))
	  for [port, port_name] = this.ports
	    label = mtt_strip_name(port.name);
	    if (struct_contains(alias, label))
	      eval(sprintf("new_name = alias.%s", label));
	      S = "Aliasing name [%s]\t on component %s (%s) to [%s]";
	      mtt_info(sprintf(S, label, this.name, this.type, \
			       new_name), infofile);	  
	      eval(sprintf("this.ports.%s.name = '[%s]'",
			   port_name, new_name));
	    endif
	  endfor
	endif	
      endif
      eval(sprintf("comp.%s = this", this_name));
    endfor
    eval(sprintf("comp_S.%s = comp", comp_or_port));
  endfor


  ## All ports should now be labelled
  disp(" --- Completed portnames and the corresponding bonds ---");
  


  ###########################
  ## Create n_vector_bonds ##
  ###########################
  disp(" --- n_vector_bonds ---")


  ## Find number of bonds on each component BEFORE vectorisation
  for [comp, comp_or_port] = comp_S
    for [this, this_name] = comp
      n_vector_bonds(this.index) = this.n_bonds;
    endfor
  endfor
  
  disp(" --- Completed n_vector_bonds ---")



  ## Create list of bonds
  bonds = causality;
  

  ## Now expand vector ports
  disp("Expanding vector ports");
  disp("... but not today!");
  
  ## Get subport names (if any)
  for [comp, comp_or_port] = comp_S
    for [this, this_name] = comp
      for [port, port_name] = this.ports
	[subports, port.n_subports] = split_port(port.name);
	if (port.n_subports > 1)
	  for i = 1:port.n_subports
	    eval(sprintf("port.subport%i.name = '%s'",
			 i, deblank(subports(i,:))));
	  endfor
	endif
	eval(sprintf("this.ports.%s = port", port_name));
      endfor
      eval(sprintf("comp.%s = this", this_name));
    endfor
    eval(sprintf("comp_S.%s = comp", comp_or_port));
  endfor

  ## Check that all vector bonds are in matching pairs
  for [comp, comp_or_port] = comp_S
    for [this, this_name] = comp
      for [port, port_name] = this.ports
	
	if (port.n_subports > 1)
	  ## find attached port
	  matched = 0;
	  
	  for [comp2, comp_or_port2] = comp_S
	    for [that, that_name] = comp2
	      for [other_port, other_port_name] = that.ports
				
		if (strcmp(port.name, other_port.name)) 
		  ## found a match ... check it is unique ...
		  if (matched == 1)
		    E = "Multiple matching vector ports: %s matches %s";
		    mtt_error(sprintf(E, port.name, other_port.name),
			      errorfile);
		  else
		    matched = 1;
		  endif
		  ## ... and now check sizes
		  if (port.n_subports == other_port.n_subports)
		    mtt_info(sprintf("Vector port: %s", port.name),
			     infofile);
		    mtt_info(sprintf("matching: %s", other_port.name)
			     , infofile);
		  else
		    E = "Vector port %s and %s are not compatible";
		    mtt_error(sprintf(E, port.name, other_port.name),
			      errorfile);
		  endif
		  
		endif
		## ensure that a match was found
		if (matched == 0)
		  E = "Vector port %s has no matching port";
		  mtt_error(E, port.name, errorfile);
		endif		
	      endfor
	    endfor

	  endfor
	endif

      endfor
    endfor
  endfor

endfunction