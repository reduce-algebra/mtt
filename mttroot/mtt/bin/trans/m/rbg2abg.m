function [bonds,components,n_vector_bonds] = rbg2abg(name,rbonds,rstrokes,rcomponents,\
				      port_coord,port_name,\
				      infofile,errorfile)

  ## ###############################################################
  ## ## Version control history
  ## ###############################################################
  ## ## $Id$
  ## ## $Log$
  ## ## Revision 1.45  1999/10/19 02:13:31  peterg
  ## ## Now assigns correct bonds to the new junction port names
  ## ##
  ## ## Revision 1.44  1999/10/19 00:05:44  peterg
  ## ## Now defaults junction ports when only one specified (for vector junctions)
  ## ##
  ## ## Revision 1.43  1999/10/18 04:08:46  peterg
  ## ## Now computes n_vector_bonds -- number apparent (maybe vector) bonds per component.
  ## ## Neeeded to vectorise junctions.
  ## ##
  ## ## Revision 1.42  1999/08/25 21:45:03  peterg
  ## ## Spurious start to vector 0 and 1
  ## ##
  ## ## Revision 1.41  1999/08/19 21:12:33  peterg
  ## ## Tidied and started implementaation of vector junctions
  ## ##
  ## ## Revision 1.40  1999/08/19 05:39:55  peterg
  ## ## Put into octave format
  ## ##
  ## ## Revision 1.39  1999/08/19 05:22:16  peterg
  ## ## To RCS prior to inplementing vector junctions
  ## ##
  ## ## Revision 1.38  1999/03/12 00:58:06  peterg
  ## ## Now gets portlist from the _abg.m file NOT the _rbg.m file
  ## ## - this allows expansion of vector SS ports.
  ## ##
  ## ## Revision 1.37  1998/07/28 19:06:43  peterg
  ## ## Still some bugs (vector SS ports)??
  ## ##
  ## ## Revision 1.36  1998/07/28 10:30:50  peterg
  ## ## Implemented vector SS ports.
  ## ##
  ## ## Revision 1.35  1998/07/08 15:35:15  peterg
  ## ## Added errorfile argument
  ## ##
  ## ## Revision 1.34  1998/07/02 19:41:29  peterg
  ## ## Fixed empty port string bug - set to null string.
  ## ##
  ## ## Revision 1.33  1998/07/02 17:16:06  peterg
  ## ## Commented out redundent code -- obsolete due to new default mechanism
  ## ##
  ## ## Revision 1.32  1998/07/02 15:12:05  peterg
  ## ## Added hard error reporting
  ## ## Added error when two unlabled bonds point in.
  ## ##
  ## ## Revision 1.31  1998/07/02 14:30:50  peterg
  ## ## Corrected various bugs - including resettting n_ports to correct value
  ## ##
  ## ## Revision 1.30  1998/07/02 13:40:50  peterg
  ## ## Added extra ports names (due to defaults) to relevant lists:
  ## ## 	port_name
  ## ## 	port_bond
  ## ##
  ## ## Revision 1.29  1998/07/02 13:28:31  peterg
  ## ## Added defaults in new form BEFORE alias expansion
  ## ##
  ## ## Revision 1.28  1998/07/02 12:36:05  peterg
  ## ## Removed debugging lines
  ## ##
  ## ## Revision 1.27  1998/07/02 12:24:02  peterg
  ## ## Expand port aliases
  ## ##
  ## ## Revision 1.26  1998/04/16 14:07:51  peterg
  ## ## Sorted out [] problem with vector ports -- new octave function
  ## ## split_port
  ## ##
  ## ## Revision 1.25  1998/04/12 15:01:04  peterg
  ## ## Converted to uniform port notation - always use []
  ## ##
  ## ## Revision 1.24  1998/02/19 08:57:16  peterg
  ## ## Fixed mtt-info bug -- confused filename with number
  ## ##
  ## ## Revision 1.23  1997/12/04 14:24:22  peterg
  ## ## Removed error message about through-pointing arrows
  ## ##
  ## ## Revision 1.22  1997/09/18 19:49:37  peterg
  ## ## Added test for uniquness of bonds on a component -- if non-unique
  ## ## implies same component at both ends of a bond.
  ## ##
  ## ## Revision 1.21  1997/09/16  15:14:14  peterg
  ## ## Added warning if a component has no bonds.
  ## ##
  ## ## Revision 1.20  1997/08/18  19:39:48  peterg
  ## ## Now generates (exampaded) port_bond list correctely
  ## ##
  ## ## Revision 1.19  1997/08/14  11:59:47  peterg
  ## ## Vector ports added!!
  ## ##
  ## ## Revision 1.18  1997/08/14  11:01:42  peterg
  ## ## Reordered algorithms as follows:
  ## ## bond end coordinates
  ## ## associate port labels with bonds (port_bond)
  ## ## associate bonds with components
  ## ## unsorted list of bonds on each component (components)
  ## ## interpret strokes and setup the causality of the bonds (bonds)
  ## ## expand vector ports & add new bonds and connections
  ## ## sort bonds on each component according to the labels -- two ports
  ## ## default included here.
  ## ##
  ## ## Revision 1.17  1997/08/09 11:31:16  peterg
  ## ## Default two port list is [in;out] (or [out;in])
  ## ## Dont do global default if no ports labels.
  ## ##
  ## ## Revision 1.16  1997/08/07  16:12:36  peterg
  ## ## Fixed sorting bug: now puts the jth component from the unsorted list
  ## ## into the kth component of the sorted list .. not vice versa!
  ## ##
  ## ## Revision 1.15  1997/08/06  21:43:19  peterg
  ## ## Corrected error in creating component list: the kth component of the
  ## ## list is given by the jth component of the original list NOT vice
  ## ## versa.
  ## ##
  ## ## Revision 1.14  1997/08/04 14:18:55  peterg
  ## ## If no ports labels at all, just use the default component list.
  ## ##
  ## ## Revision 1.13  1997/08/04 12:50:39  peterg
  ## ## Many bug fixes to the named port version + tied up the logic and
  ## ## supporting comments.
  ## ##
  ## ## Revision 1.12  1997/08/02 19:37:53  peterg
  ## ## Now uses named ports.
  ## ##
  ## ## Revision 1.11  1997/04/29 09:12:37  peterg
  ## ## Added error message if port label near to >1 bond.
  ## ##
  ## ## Revision 1.10  1997/03/17  13:45:42  peterg
  ## ## Added more error info.
  ## ##
  ## ## Revision 1.9  1996/12/31  11:25:57  peterg
  ## ## Clearer error messages for incorrect ports.
  ## ##
  ## ## Revision 1.8  1996/12/04 21:52:39  peterg
  ## ## Now uses fopen.
  ## ##
  ## ## Revision 1.7  1996/11/01 18:01:57  peterg
  ## ## Rationalised port ordering.
  ## ## Fixed port bug.
  ## ##
  ## ## Revision 1.6  1996/08/25 08:27:14  peter
  ## ## Now checks ports correctely - I hope.
  ## ##
  ## ## Revision 1.5  1996/08/24 19:21:26  peter
  ## ## More specific error messages.
  ## ##
  ## ## Revision 1.4  1996/08/24 18:00:33  peter
  ## ## Fixed bug with finding ports.
  ## ##
  ## ## Revision 1.3  1996/08/09 08:26:35  peter
  ## ## Cosmetic tidy up.
  ## ##
  ## ## Revision 1.2  1996/08/04 18:37:57  peter
  ## ## Fixed  no causal strokes bug.
  ## ##
  ## ## Revision 1.1  1996/08/04 18:30:14  peter
  ## ## Initial revision
  ## ##
  ## ###############################################################


  ##Default to no components
  components = [0];

  ## Xfig scaling factor
  scale = 1200.0/2.54546;

  ## Rotation matrix
  rot = [0 -1; 1 0];

  ## Find number of strokes
  [n_strokes,columns] = size(rstrokes);
  if (columns ~= 4)&(n_strokes>0)
    error('Incorrect rstrokes matrix: must have 4 columns');
  endif


  ## Find number of bonds
  [n_bonds,columns] = size(rbonds);
  if (columns ~= 6)&(n_bonds>0)
    error('Incorrect rbonds matrix: must have 6 columns');
  endif


  ## Find number of components
  [n_components,columns] = size(rcomponents);

  ## Find the number of ports refered to within the component
  [n_ports,columns] = size(port_coord)

  ## If port_name is empty, make it a empty string
  if (length(port_name)==0)
    port_name="";
  endif


  ## Determine coordinates of the arrow end of the bond and the other end
  other_end_1 = rbonds(:,1:2);
  arrow_end   = rbonds(:,3:4);
  other_end_2 = rbonds(:,5:6);

  distance_1   = length2d(other_end_1 - arrow_end);
  distance_2   = length2d(other_end_2 - arrow_end);
  which_end    = (distance_1>distance_2)*[1 1];
  one          = ones(size(which_end));
  other_end    = which_end.*other_end_1 + (one-which_end).*other_end_2;
  arrow_vector = ( which_end.*other_end_2 + (one-which_end).*other_end_1 ) - ...
      arrow_end;
  
  ## Locate the bond end nearest to each port
  ## col 1 of port_near_bond contains a signed bond number (+ for arrow end)
  ## col 2  of port_near_bond contains the corresponding port index
  port_bond = [];
  for i = 1:n_ports
    near_bond = adjbond(port_coord(i,1:2),arrow_end,other_end);
    [rows,cols]=size(near_bond);
    if rows>1
      error(sprintf ...
	    ("A port is near to more than one bond at coordinates %g,%g\n", ...
	     port_coord(i,1)/scale,  port_coord(i,2)/scale));
    endif
    

    ##The (signed) bond corresponding to the ith port label
    port_bond(i) = near_bond(1)*sign(1.5-near_bond(2));
  endfor

  port_bond
  ##We now have the (signed) bond (port_bond(i)) correponding to the
  ## ith port label within the component 

  ## Locate the components at the ends of each bond
  ## col 1 of comp_near_bond contain the component nearest to the arrow end
  ## col 2 of comp_near_bond contain the component nearest to the other end
  for i = 1:n_bonds
    comp_near_bond(i,:) = adjcomp(arrow_end(i,:),other_end(i,:),rcomponents);
  endfor

  comp_near_bond
  ## We now have a list (comp_near_bond) of the component(s) at each end
  ## of each bond

  ## Now do a list of the bonds on each component - unsorted at this stage.
  ## Also expand aliases using the alias list for each component
  components = []; 
  i_vector=0;			# Counter for vector components
  for i = 1:n_components
    ##Get component type
    eval(['[comp_type, comp_name] = ', name, '_cmp(i)']);

    
    ## There are n_comp_bonds bonds on this component with corresponding index
    [index,n_comp_bonds] = getindex(comp_near_bond,i);

    if index(1,1)==0
      mtt_error(sprintf("Component %s (%s) has no bonds", comp_name,
			comp_type),errorfile);
    endif
    
    
    ## Create the signed list of bonds on this component
    one = ones(n_comp_bonds,1);
    bond_list = index(:,1); %  bond at component
    
    ## Check that all bonds are unique -- error if not
    if unique(bond_list)==0
      mtt_error(sprintf("Component %s (%s) is at both ends of a bond", comp_name,
			comp_type),errorfile);
    endif
    
    

    ## which end of bond at component?
    bond_end = index(:,2); 
    direction = -sign(bond_end-1.5*one);
    signed_bond_list = bond_list.*direction;
    components = add_bond(components,signed_bond_list',i);
    
    ## Unalias and/or default all the ports on this componen
    unlabelled_ports = 0;  
    in_bonds = 0;
    out_bonds = 0;
    if ((comp_type=="0")||(comp_type=="1")) # A junction
      disp("---- default junctions ---- ");
      junction_names = 0;
      for j=1:n_comp_bonds
	port_name_index = getindex(port_bond,signed_bond_list(j));
	if port_name_index>0
	  junction_port_name = port_name(port_name_index,:);
	  named_bond_index = j;
	  junction_names++;
	endif
      endfor
      if junction_names==1	# one named port
	mtt_info(sprintf("Defaulting all ports on junction %s to %s", comp_name, junction_port_name));
	## Make the other n-1 names the same.
	junction_port_name = mtt_strip_name(junction_port_name);
	for j=1:n_comp_bonds;
	  if j!=named_bond_index
	    port_name = [port_name; ["[" junction_port_name "]"]]; # add to list
	    [port_name_index,junk] = size(port_name); # the corresponding index
	    port_bond(port_name_index,:) = signed_bond_list(j); # add to port bond
	  endif
	endfor
      elseif (junction_names!=0)&&(junction_names!=n_comp_bonds) # not allowed
	mtt_error(sprintf("Junction %s must have 0, 1 or %i port labels", comp_name,n_comp_bonds),errorfile);
      endif
      port_name = port_name
    else			# Not a junction
      for j=1:n_comp_bonds
	signed_bond = signed_bond_list(j);
	port_name_index = getindex(port_bond,signed_bond);
	port_direction = sign(signed_bond);
	
	if port_name_index==0	# There is no port on this bond - so try
				# to default
	  unlabelled_ports++;
	  if(unlabelled_ports==1)
	    if port_direction>0
	      in_bonds++;
	      port_name_i = "in";
	    else
	      out_bonds++;
	      port_name_i = "out";
	    endif
	    
	  elseif (unlabelled_ports==2)
	    if port_direction>0
	      if (++in_bonds>1)
		mtt_error(["More than one unlabelled INport on component " \
			   comp_name " (" comp_type ")"],errorfile);
	      else
		port_name_i = "in";
	      end
	    else
	      if (++out_bonds>1)
		mtt_error(["More than one unlabelled OUTport on component " \
			   comp_name " (" comp_type ")"],errorfile);
	      else
		port_name_i = "out";
	      end
	    endif
	    
	  else
	    mtt_error(["More than two unlabelled ports on component " \
		       comp_name " (" comp_type ")"],errorfile);
          endif
	  
	  mtt_info(["Defaulting port name [" port_name_i "]\t on component " \
		    comp_name " (" comp_type ")" ],infofile);
	  port_name = [port_name; ["[" port_name_i "]"]];	# add to list
	  [port_name_index,junk] = size(port_name); # the corresponding
				# index
	  port_bond(port_name_index,:) = signed_bond; # add to port bond
	else  
	  port_name_i = mtt_strip_name(port_name(port_name_index,:));
	  ## port_name_i = deblank(port_name(port_name_index,:));
	  ## port_name_i = port_name_i(2:length(port_name_i)-1) # strip []
	endif
	
	
	## Replace by alias -- if any
    	eval( ["alias = ", comp_type, '_alias';]); # Get aliases
    	if is_struct(alias)		# are there any aliases
          if struct_contains(alias,port_name_i) # Is this an alias?
	    eval(["new_port_name_i = alias.",port_name_i]);
	    mtt_info(["Aliasing name [" port_name_i "]\t on component " \
		      comp_name " (" comp_type ")\t to [" new_port_name_i "]"],infofile);
	    port_name = replace_name(port_name, \
				     ["[",new_port_name_i,"]"], \
				     port_name_index);
	  endif
	  
      	endif
	
      endfor
      
    endif
    
  endfor
  
  ## At this point, every port should be labeled (port_name) and \
  ## associated with a bond (port_bond).
  disp("--- Completed portnames and the corresponding bonds ---")
  port_name, port_bond


  ## Deduce causality from the strokes (if any) and create the list of bonds
  causality = zeros(n_bonds,2);
  if n_strokes>0
    ## Find out location of centre and ends of stroke.
    stroke_end_1 = [rstrokes(:,1) rstrokes(:,2)];
    stroke_end_2 = [rstrokes(:,3) rstrokes(:,4)];
    
    stroke_centre = (stroke_end_1 + stroke_end_2)/2;
    stroke_vector = (stroke_end_1 - stroke_end_2);
    stroke_length = length2d(stroke_vector);

    ## Deduce bond causality from the strokes 
    for i = 1:n_strokes
      stroke = [stroke_centre(i,:) 
		stroke_end_1(i,:)
		stroke_end_2(i,:)];


      ## Find the nearest bond end.
      [index,distance] = adjbond(stroke(1,:),arrow_end,other_end);
      if (distance>2*stroke_length(i))
	info = sprintf('Stroke at (%4.3f,%4.3f) is %4.3f away from the nearest bond\n', ...
		       stroke(1,1)/scale, stroke(1,2)/scale, distance/scale);
      endif
      
      
      ## Bond end coordinates
      j = index(1,1);
      which_end = index(1,2)==1;
      bond_end = arrow_end(j,:)*which_end + other_end(j,:)*(1-which_end);
      
      ## Now decide which bit of the stroke is nearest
      stroke_index = adjbond(bond_end,stroke,zeros(size(stroke)));
      
      if stroke_index(1)==1 ## uni-causal stroke
	causality(j,1:2) = (2*which_end-1)*[1 1];
      else ## bicausal stroke
	## Find out whether stroke is on flow side of bond
	stroke_direction = stroke(1,:) - stroke(stroke_index(1),:);
	flow_side = stroke_direction*arrow_vector(j,:)'>0;
	causality(j,1+flow_side) = 2*which_end-1;
      endif
      
    endfor
    
  endif


  bonds = causality;


  ## Find number of bonds on each component BEFORE vectorisation
  for i=1:n_components
    n_vector_bonds(i) = length(nozeros(components(i,:)))
  endfor
  
  ## Now expand vector ports
  disp("Expanding vector ports");
  [n_bonds,junk] = size(bonds);
  n_ports = length(port_bond);
  n_exp_ports=n_ports;
  exp_port_name="";
  exp_port_bond = [];
  ##exp_comps = [];
  for i=1:n_ports
    port_name_i = port_name(i,:)
    [subport,n_subports] = split_port(port_name_i, ','); ## Find the components of the vector port

    if n_subports==1 ## an ordinary port
      exp_port_name = [exp_port_name; subport(1,:)]; ## Write out the only port
      exp_port_bond = [exp_port_bond; port_bond(i)]; ## and the port_bond
    else ## its a vector port
      ## Check that there is a corresponding vector port at the other end of the
      ## bond
      signed_bond_index = port_bond(i);
      [other_bond_index,n_other] = getindex(port_bond,-signed_bond_index);
      if n_other == 1
	other_port_name = port_name(other_bond_index,:);
	[other_subport,n_other_subports] = split_port(other_port_name, ',');
	if n_other_subports~=n_subports
	  mtt_error(['Vector ports ', port_name_i, ' and ', other_port_name, 'are not compatible'],errorfile);
	end
      else # No explicit matching vector port
 	mtt_error(['Vector port ', port_name_i, ' has no matching port'], errorfile);
      endif
      
      
      if other_bond_index>i ##then its not been done yet
	mtt_info(["Vector port: ", port_name_i],infofile);
	mtt_info(["matching: ", other_port_name],infofile);
	## Remove sign info.
	bond_index = abs(signed_bond_index);
	sig = sign(signed_bond_index);
	
	## Put the first element of each port list in the expanded list
	exp_port_name = [exp_port_name; subport(1,:)];
	exp_port_name = [exp_port_name; other_subport(1,:)];
	
	## Add to the expanded port_bond list
	exp_port_bond = [exp_port_bond; signed_bond_index; ...
			 -signed_bond_index];
	
	## Add the other names to the expanded list and augment the bonds,
	## components and port_bond lists.
	for j=2:n_subports
	  ## Add a new name (for each end) to give a non-vector list
	  exp_port_name = [exp_port_name; subport(j,:)];
	  exp_port_name = [exp_port_name; other_subport(j,:)];
	  
	  ## Add one more bond to the list
	  bonds = [bonds; bonds(bond_index,:)];
	  n_bonds = n_bonds + 1;
	  
	  ## Add bond to the expanded port_bond list (ports at both ends)
	  exp_port_bond = [exp_port_bond; sig*n_bonds; -sig*n_bonds];


	  ## Add the new bond to the component at both ends (taking note 
	  ## of the direction).
	  arrow_index = comp_near_bond(bond_index,1);
	  components = add_bond(components, n_bonds, arrow_index);
	  other_index = comp_near_bond(bond_index,2);
	  components = add_bond(components, -n_bonds, other_index);
	endfor
	
      endif
      
    endif
    
  endfor



  ##Replace old list by new
  port_name = exp_port_name
  port_bond = exp_port_bond

  ## Resize the lists
  [n_ports,junk] = size(port_name);

  port_name, components
  ## Produce a list of bonds on each component (within this component) 
  ##  - sorted if explicit port numbers
  for i = 1:n_components    
    disp('-----------------');
    ##Get component type
    eval(['[comp_type, comp_name] = ', name, '_cmp(i)']);


    ##Convert junction names   
    if comp_type(1)=='0'	# Zero junction
      comp_type = 'zero';
      isa_junction = 1;
    elseif comp_type(1)=='1'	# One junction
      comp_type = 'one';
      isa_junction = 1;
    else
      isa_junction = 0;
    endif

    ## Find the (unsorted) bond list on this component
    signed_bond_list = nozeros(components(i,:));
    n_comp_bonds = length(signed_bond_list);
    direction = sign(signed_bond_list);
    
    ##Find the port list for this component
    if exist([comp_type, '_cause'])==0
      eval(["ABG = ",comp_type, "_abg;"]);
      if struct_contains (ABG, "portlist")
	port_list = ABG.portlist;
      else
	error(sprintf("Component %s has no ports", comp_type));
        port_list = [];
      endif
    else
      port_list=comp_ports(comp_type,n_comp_bonds)
    endif
    

    [n_comp_ports,m_comp_ports] = size(port_list);
    subport_list="";
    for p=1:n_comp_ports		# Expand any vector ports
      [subport,n_sub] = split_port(port_list(p,:), ','); # Find the components
				# of the vector port
      if n_sub>1
	mtt_info(sprintf("Expanding vector port %s of component type %s",\
			 port_list(p,:), comp_type, infofile));	
      endif
      
      subport_list = [subport_list; subport];
    endfor
    
    port_list = subport_list;	# Set the expanded port list.
    

    ## Check that number of bonds on the component is the same as the number of
    ## ports
    [n_comp_ports,m_comp_ports] = size(port_list);
    if (n_comp_ports~=n_comp_bonds) & ...
	  ~(strcmp(comp_type,'zero')|strcmp(comp_type,'one'))
      message=sprintf('Component %s (%s) has %1.0f impinging bonds but has %1.0f ports', ...
		      comp_name,comp_type,n_comp_bonds,n_comp_ports);
      mtt_error(message, errorfile);
    endif
    
    
    unsorted_port_list="";
    if n_ports>0 ## then there are some named ports
      ## so find those associated with the bonds on this component.
      k=0; 
      for j = 1:n_comp_bonds
	b = signed_bond_list(j); 
	## Find the port label on component end of bond (if any)
	[port_index,m] = getindex(port_bond,b);
	if m==1
	  k=k+1;
	  unsorted_port_list(k,:) = port_name(port_index,:);
	endif
	
      endfor
      
    else 
      k=0;
    endif
    
    %Compute the number of labeled ports
    [n_unsorted_ports,m_unsorted_ports] = size(unsorted_port_list);
    if m_unsorted_ports==0
      n_unsorted_ports = 0;
    endif
    
    ## Junctions (order of ports unimportant)
    if strcmp(comp_type,'zero')|strcmp(comp_type,'one')
      for j = 1:n_comp_bonds
	components(i,j) = signed_bond_list(j);
      endfor
      
    else ##Order of ports is important
      unsorted_port_list, port_list
      if n_unsorted_ports==0
	mtt_error(['Component ', comp_name, ' (', comp_type, ') has no labeled ports'], errorfile); 
      endif
      
      ##Write out the signed bond list in the correct order
      unsorted_port_list
      [n_list,m_list] = size(unsorted_port_list);
      if n_list!=n_comp_bonds
	error(sprintf("Component %s (%s) has %i bonds but %i port lables",\
		      comp_name, comp_type, n_comp_bonds, n_list))
      endif

      for j = 1:n_comp_bonds
	j
	name_k = unsorted_port_list(j,:)
	k = name_in_list(name_k, port_list);
	## Check that it only appears once in port list
	if length(k)>1
	  mtt_error(['Component ', comp_name, ' (', comp_type, ') has ports with the same name:  ', name_k], errorfile); 
	endif
	
	
	##Check that it only appears one in the label list
	kk = name_in_list(name_k,unsorted_port_list);
	if length(kk)>1
	  mtt_error(['Component ', comp_name, ' (', comp_type, ') has multiple port labels:  ', name_k], errorfile); 
	endif
	
	
	if k==0
	  mtt_error(['Component ', comp_name, ' (', comp_type, ') has an unrecognised port: ', name_k], errorfile); 
	else
	  components(i,k) = signed_bond_list(j);     
	endif
      endfor
    endif
  endfor

endfunction



















