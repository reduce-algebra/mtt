function [known] = mtt_component_eqn (fullname, port, causality, \
				      known, Cbg)

  ## function [known] = mtt_component_eqn (fullname, port, causality, known)
  ##
  ## Recursively finds the equations giving the signal of specified
  ## causality on the specified port of component named "name" within
  ## subsystem Name 

  ## fullname:  name of component and subsystem
  ## port: port number of component
  ## causality: effort or flow
  ## know_list: list of components already known

  ## Data structures.
  ## A signal is a row vector containing three numbers:
  ##   Index -- a unique (within a subsystem) signed integer
  ##            abs(index) is the unique bond number, sign is the direction.
  ##   Causality -- 1 for effort, -1 for flow
  ##   Port -- the port of the component to which it is connected.
  ## 

  [Name,name] = mtt_subname(fullname); # Split fullname

  SD = "__";			# Subsystem delimiter
  CD = "\n%%";			# Comment delimiter
  arg_default = "1";		# Default aliased arg

  DEBUG = 0;

  if DEBUG
    disp("=======================================");
    fullname, name, Name, port,causality,known
  endif
  
  eqn="## No equation -- something wrong"; # Default

  if length(known)<2		# Invalid
    known = "  ";
  endif

  if length(Name)>0
    cbg = mtt_cbg(Name);		# Structure for this subsystem
    if struct_contains (cbg, "ports")
      ## Combine ports with the other subsystems
      for [component_structure, component] = cbg.ports
	eval(sprintf("cbg.subsystems.%s=cbg.ports.%s;",component,component));
      endfor
    endif
  endif


  if length(name)>0 		# Alias
    eval(sprintf("ARG=cbg.subsystems.%s.arg;", name)); # Arguments
    ARG = mtt_alias (Name,ARG,arg_default); # Alias them
    eval(sprintf("cbg.subsystems.%s.arg=ARG;", name)); # and copy
  else			  # Call to a subsystem (represented by name="")
    if !struct_contains(cbg,"portlist")
      N_ports = 0;
    else
      [N_ports,M_ports] = size(cbg.portlist);
    endif
    
    if port>N_ports
      error(sprintf("port (%i) > N_ports (%i)", port, N_ports));
    else			# Get name and find equation
      name = deblank(cbg.portlist(port,:));
      if DEBUG
	disp("----> lower-level system")
      endif
      known = mtt_component_eqn (mtt_fullname(Name,name), 1, \
				 causality, known, cbg);
      return
    endif
  endif
  

  ## Other causality representations
  if strcmp(causality,"effort")
    i_cause = 1;
    othercausality = "flow";
    index_cause = 1;
    cause = "e";
  elseif strcmp(causality,"flow")
    i_cause = -1;
    othercausality = "effort";
    index_cause = 2;
    cause = "f";
  else
    error(sprintf("mtt_component_eqn: causality %s invalid", causality));
  endif
  
  ## A useful composite name
  name_port_cause = sprintf("%s_%i_%s",name, port, cause);
  full_name_port_cause = mtt_fullname(Name,name_port_cause);

  ## If value is known, don't do anything.
  if findstr(sprintf(" %s ", full_name_port_cause), known)>0
    eqn = sprintf("%s The %s signal on port %i of %s is known already", \
		  CD, causality, port, name);
    return
  else			# Add to list
    known = sprintf("%s %s", known, full_name_port_cause);
  endif
  
  
  
  ## Component type
  comp_type = eval(sprintf("cbg.subsystems.%s.type;", name));
  if DEBUG
    comp_type
  endif
  
  ## Component cr
  cr = eval(sprintf("cbg.subsystems.%s.cr;", name));

  ## Component arg
  arg = eval(sprintf("cbg.subsystems.%s.arg;", name));

  ## To which bond(s) is the component connected?
  connections = eval(sprintf("cbg.subsystems.%s.connections;", name));
  bond_list = abs(connections);	# Unsigned list 
  out_bond_number = bond_list(port);	# The bond at the output of this component
  direction = sign(connections); # Bond directions
  directions = direction'*[1 1]; 

  ## List of system bonds
  bonds = cbg.bonds;

  ## List of component bond causality (component-orientated causality)
  comp_bonds = bonds(bond_list,:).*directions; # Component bonds

  ## What components are at the other ends of the in bonds?
  ## Effort
  [in_e_bonds,in_e_components,in_e_ports,N_e] = mtt_component_inputs \
      (name,comp_type,causality,"effort",comp_bonds,connections,cbg);
  ## Flow
  [in_f_bonds,in_f_components,in_f_ports,N_f] = mtt_component_inputs \
      (name,comp_type,causality,"flow",comp_bonds,connections,cbg);


  ##Composite values
  N_ef = N_e + N_f;
  in_ef_bonds = [in_e_bonds; in_f_bonds];
  in_ef_components = [in_e_components; in_f_components];
  in_ef_ports = [in_e_ports; in_f_ports];
  in_causality = [ones(N_e,1); -ones(N_f,1)];

  ## Lists of signals relevant to this component
  outsig = [out_bond_number i_cause port];
  insigs = [in_ef_bonds in_causality in_ef_ports];
  innames = in_ef_components;

  if DEBUG
    outsig
    insigs
    innames
  endif
  
  ## Is the signal the output of a port?
  is_port_output = 0;			# Default
  if struct_contains (cbg, "ports")
    if struct_contains (cbg.ports,name)
      is_port_output = (outsig(2)!=insigs(1,2));
    endif
  endif
  
  if is_port_output
    ## Which port (number) is it?
    [N_ports,M_ports] = size(cbg.portlist);
    for i=1:N_ports
      if strcmp(deblank(cbg.portlist(i,:)), name)
	port_index = i;
	break;
      endif
    endfor

    ## File containing data structure
    NAME = mtt_subname(Name);
    CBG = mtt_cbg(NAME);
    
    ## And to which component (at higher level) is it connected?
    [new_Name,new_name] = mtt_subname(Name);
    port_bond = eval(sprintf("CBG.subsystems.%s.connections(%i);", new_name, port_index));
    [in_name, in_port, in_bond] = mtt_other_end (new_name,port_bond,CBG);

    ## Find its equation
    if DEBUG
      disp("----> higher level system")
    endif
    

    known = mtt_component_eqn (mtt_fullname(new_Name,in_name), \
			       in_port, causality, known, cbg);

    LHS = Source_seqn ("external",Name);
    RHS = varname(NAME, abs(in_bond), i_cause);
    eqn = sprintf("%s%s%s := %s;", LHS, SD, name, RHS);

    if !DEBUG
      comment = sprintf("%s PORT", CD);
      disp(sprintf("%s\n%s",comment, eqn));
    endif

  endif
  

  ## Handle special components
  if strcmp(comp_type,"0")||strcmp(comp_type,"1") # Junctions
    [eqn,insigs,innames] = junction_seqn (comp_type,Name, outsig, \
					  insigs, innames);
  else				# Everything else
    if exist(sprintf("%s_cause", comp_type)) # Simple component
      ## Do the equations
      [eqn,insigs,innames] = eval(sprintf("%s_seqn (Name, name, cr, \
						    arg, outsig, \
						    insigs, \
						    innames);", \
					  comp_type));
      ## Resolve CR
      eqn = mtt_resolve_cr(eqn);

    else			# Compound component
      new_NAME = Name;
      new_Name = mtt_fullname(Name,name);
      new_name = "";
      
      ## Get relevant data structure
      Cbg = mtt_cbg(new_Name);
      port_name = Cbg.portlist(port,:);

      LHS = varname(Name, outsig(1,1), outsig(1,2));
      RHS = Sensor_seqn ("external",new_Name);
      eqn = sprintf("%s := %s%s%s;", LHS, RHS, SD, port_name);

      if DEBUG
	disp("----> same-level subsystem")
      endif

      [known] = mtt_component_eqn \
   	  (mtt_fullname(new_Name,new_name), port, causality, known, cbg);
      
    endif
  endif

  comment = \
      sprintf("%s Equation for %s signal on port %i of %s (%s), subsystem %s.", \
     	      CD, causality, port, name, comp_type, Name);

  if DEBUG
    disp(sprintf("%s\n%s",comment, eqn));
  endif
  
  is_external = mtt_is_external(comp_type,outsig, insigs, is_port_output);

  if !is_external
    ## Find the corresponding input equations
    [N_other,M_other] = size(insigs);
    for i = 1:N_other
      if insigs(i,2)==1
	other_causality = "effort";
      else
	other_causality = "flow";
      endif

      other_port = insigs(i,3);
      other_name = deblank(innames(i,:));
      if DEBUG
	disp("----> same-level component")
      endif
      

      [known] = mtt_component_eqn \
    	  (mtt_fullname(Name,other_name), other_port, other_causality, \
	   known, cbg);
    endfor
  endif

  ## Write this signal
  ##comment_2 = sprintf("Connected to:%s", in_component_list);
  if !DEBUG
    disp(sprintf("%s\n%s",comment, eqn));
  endif

endfunction