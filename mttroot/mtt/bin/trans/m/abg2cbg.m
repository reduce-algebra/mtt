function [port_bonds, status] = abg2cbg(system_name, system_type, full_name,
					port_bonds,
					port_bond_direction,
					port_status,
					typefile, infofile, errorfile)

# abg2cbg - acausal to causal bg conversion
#
#     ###################################### 
#     ##### Model Transformation Tools #####
#     ######################################
# 
# Matlab function  abg2cbg.m
# Acausal bond graph to causal bond graph: mfile format
# [bonds,status] = abg2cbg(system_name, system_type, full_name, port_bonds, infofile)

# ###############################################################
# ## Version control history
# ###############################################################
# ## $Id$
# ## $Log$
# ## Revision 1.36  1998/08/25 06:44:40  peterg
# ## Furhter revisions
# ##
# ## Revision 1.35  1998/08/24 10:16:32  peterg
# ## Coverted to new structure - still needs status sorting.
# ##
# ## Revision 1.34  1998/08/24 07:35:03  peterg
# ## About to go to new abg format.
# ##
# ## Revision 1.33  1998/07/29 13:36:37  peterg
# ## Don't set port status if there aren't any ports.
# ##
# ## Revision 1.32  1998/07/28 19:06:11  peterg
# ## *** empty log message ***
# ##
# ## Revision 1.31  1998/07/28 13:15:10  peterg
# ## Vector SS ports included.
# ##
# ## Revision 1.30  1998/07/27 20:29:49  peterg
# ## Had another go at causality ....
# ##   1. Impose external causality onto all port bonds
# ##   2. Set C_cause.m so that it DOESN'T set causality
# ##       -- I_cause is already ok !
# ##
# ## Revision 1.29  1998/07/10 09:01:42  peterg
# ## Added error + info file in new form
# ##
# ## Revision 1.28  1998/07/08 09:23:42  peterg
# ## Undid the previous change -- needs more thought.
# ##
# ## Revision 1.27  1998/07/03 19:03:31  peterg
# ## Always override the causality of port bonds!
# ##
# ## Revision 1.26  1998/06/27 13:24:04  peterg
# ## Causality now set correctly for:
# ## 	multi-port C and I
# ## 	C and I with arrows pointing in
# ##
# ## Revision 1.25  1998/06/25 18:53:30  peterg
# ## Actually, the previous comment was optimistic.
# ## The port causalities on a compound are now forced to be the same as
# ## that specified by a a _cuase.m file (if it exists)
# ##
# ## Revision 1.24  1998/06/25 17:45:03  peterg
# ## No change -- but checked that explicit causality works!
# ##
# ## Revision 1.23  1998/04/04 10:46:37  peterg
# ## Coerces port bonds to have smae direction as the imposing bonds
# ## _cbg now generates the (coerced) components as welll as the (coerced)
# ## causality.
# ##
# ## Revision 1.22  1997/08/19 10:21:09  peterg
# ## Only copy port cuaslity info if not already set within the
# ## subsystem. I thought I'd done this already ....
# ##
# ## Revision 1.21  1997/08/18 16:25:25  peterg
# ## Minor bug fixes
# ##
# ## Revision 1.20  1997/08/18 12:45:24  peterg
# ## Replaced: comp_bonds = bonds(bond_list,:)
# ## by: 	for kk = 1:n_comp
# ## 	  comp_bonds(kk,:) = bonds(comp(kk),:);
# ## 	end;
# ##
# ## to avoid an octave bug in 1.92.
# ##
# ## Revision 1.19  1997/08/18 11:23:59  peterg
# ## Main component loop now misses out the ports (SS:[]) -- the causality
# ## is merely passed through these components.
# ##
# ## Revision 1.18  1997/08/08 08:11:04  peterg
# ## Suppress compoment trace.
# ##
# ## Revision 1.17  1997/08/07 16:10:13  peterg
# ## Move the if status ..  to the beginning of the main loop.
# ##
# ## Revision 1.16  1997/08/04 13:11:19  peterg
# ## Only change to component-orientated causality for simple components
# ## NOT for compound components.
# ##
# ## Revision 1.15  1997/01/05 12:25:59  peterg
# ## More informative message about port bonds incompatible with  ports
# ##
# ## Revision 1.14  1996/12/31 16:20:42  peterg
# ## Just write causality information at top level -- it gets a bit
# ## voluminous if written at deeper levels.
# ##
# ## Revision 1.13  1996/12/31 11:49:09  peterg
# ## Don't copy port bond causality if already set -- allows subsystem
# ## causality to be preset directely on named SS.
# ##
# ## Revision 1.12  1996/12/31 11:42:36  peterg
# ## *** empty log message ***
# ##
# ## Revision 1.11  1996/12/07  17:10:48  peterg
# ## Allows port SS at top level - ie takes it to be an ardianry SS at top
# ## level.
# ##
# ## Revision 1.10  1996/12/04 21:48:55  peterg
# ## Compares full-name with empty string (instead of testing for zero
# ## length.
# ##
# ## Revision 1.9  1996/08/30  12:55:40  peter
# ## More heirachical stuff added.
# ##
# ## Revision 1.8  1996/08/26  10:04:25  peterg
# ## Fixed error due to a line wrap.
# ##
# ##Revision 1.7  1996/08/16  12:58:58  peter
# ## Now does preferred causality of I and C.
# ## Revision 1.6  1996/08/09 08:27:29  peter
# ## Added a few deguging lines
# ##
# ## Revision 1.5  1996/08/08 18:06:18  peter
# ## Unified file naming scheme
# ##
# ## Revision 1.4  1996/08/08 08:30:06  peter
# ## The cbg filename contains the system name - this makes things easier
# ## when setting up the m to fig translation and m to ese translation
# ##
# ## Revision 1.3  1996/08/05 18:53:21  peter
# ## Fixed bug passing causality from subsystems.
# ##
# ## Revision 1.2  1996/08/05 15:41:41  peter
# ## Now recursively does causality on subsystems.
# ##
# ## Revision 1.1  1996/08/04 17:55:55  peter
# ## Initial revision
# ##
# ###############################################################

  pc = '%';
  if nargin<1
    system_name = 'no_name';
  end;

  if nargin<4
    port_bonds = [];
  end;

  if nargin<5
    infofile = 'stdout';
  end;

# Are we at the top level of the heirarchy?
  at_top_level = strcmp(full_name, '');

# Create a file to contain shell commands which map subsystem types 
# onto components
  if at_top_level # Then at top level
    fprintf(typefile, "# Commands to map types onto subsystems\n");
    fprintf(typefile, "# File %s_type.sh\n", system_name);
    fprintf(typefile, "# Generated by MTT at %s\n\n", ctime(time));
  end;

# Create the (full) system name
  if at_top_level
    full_name = system_name;
    system_type = system_name;
  else
    full_name = [full_name, "_", system_name];
  end;
  

# Add to file to contain shell commands which map subsystem types 
# onto components
  fprintf(typefile, "$1%s$2%s$3\n", system_type, full_name);

  fun_name = [system_type, "_abg"];

  disp("====================================");
  disp(["BEGIN: ", full_name, " (", fun_name, ")"]);
  disp("====================================");

# If no such function - then there is nothing to be done.
  if exist(fun_name)~=2
    mtt_error(["m-file ", fun_name, " does not exist"], errorfile);
    bonds = [];
    status = [];
    return
  end;

# Evaluate the system function to get the bonds and number of ports
#eval(["[bonds,components,n_ports,N_ports]=", fun_name, ";"]);
  eval(["[ABG]=", fun_name, ";"]);

  if !struct_contains(ABG,"subsystems")# Are there any subsystems?
    return;			# Nothing to do
  else
    [n_subsystems,junk] = size(struct_elements(ABG.subsystems));
  endif
  
  if struct_contains(ABG,"ports")# Are there any ports?
    [n_ports,junk] = size(struct_elements(ABG.ports));
    port_bond_index=zeros(n_ports,1);
    for port = ABG.ports	# Find indices of the internal
				# port bonds in correct order
       port_bond_index(port.index) = port.connections;
    endfor
    port_bond_index=abs(port_bond_index);
  else
    n_ports = 0;
  endif				   

				
  [n_bonds,columns] = size(ABG.bonds);# Find number of bonds
  if (columns ~= 2)&(n_bonds>0)
    error("Incorrect bonds matrix: must have 2 columns");
  end;

 
## Find number of components
#  [n_components,m_components] = size(components);
#  if n_components==0 # there is nothing to be done
#    return
#  end;


  
# Coerce the port (SS:[]) component bonds to have the same direction as
# of the bonds in the encapsulating system -- but not at top level
#  if (n_ports>0)&&(!at_top_level)
    
#   # port_bond_index = abs(components(1:n_ports,1:m_components))# relevant
#							     # bond
#							     # numbers
#				#    port_bond_index = nozeros(reshape(\
#				#			      port_bond_index',n_ports*m_components,1))'# vectorise

#    for port = ABG.ports
#    #for i=1:n_ports
#				# Is the direction different?
#      if (sign(port.connections)!=port_bond_direction(i))
#      	mtt_info(sprintf("Flip port #i",i),infofile);
#				# Flip direction at port
#      	port.connections = - port.connections;
#				# and at the other end
#      	for subsystem = ABG.subsystems
#	  for k=1:length(subsystem.connections)
#	    if (abs(subsystem.connection(k))==port_bond_index(i))
#	    subsystem.connection(k)   = -subsystem.connection(k);
#	    end
#	  end
#      	end;
#				# Flip the bond causalities (these are arrow-orientated)
#      	ABG.bonds(port_bond_index(i),:) = -ABG.bonds(port_bond_index(i),:);
#      end
#    end
#  end



# Set initial status
#  status = -ones(n_subsystems,1);

# If not at top level, then copy the port bonds.
  if ~at_top_level 
  # Find number of port bonds
    [n_port_bonds,columns] = size(port_bonds);

  # Check compatibility - if ok copy port bonds to the internal bonds list.
#    if n_port_bonds~=N_ports
#      mtt_error(sprintf("#s: #1.0f port bonds incompatible with #1.0f ports", ...
#			full_name, n_port_bonds, n_ports), errorfile);

#    else # Copy the port bonds & status
      for j = 1:n_port_bonds
      	jj = port_bond_index(j);
      	for k = 1:2
	  if ABG.bonds(jj,k)==0 # only copy if not already set
	    ABG.bonds(jj,k) = port_bonds(j,k);
	  end;
      	end;
#      status(1:N_ports) = port_status;
#      end
    end
  else
    n_port_bonds=0;
  end;
# bonds,port_bonds

# Causality indicator
  total = 2*n_bonds;
  done = sum(sum(abs(ABG.bonds)))/total*100;


  fields=["ports";"subsystems"];	# Do for both ports and subsystems -
				# ports first
  for i=1:2
    field=deblank(fields(i,:));
    if struct_contains(ABG,field);
      eval(["ABG_field = ABG.",field, ";"]);
      
# Outer while loop sets preferred causality
      ci_index=1;

      for [subsystem,name] = ABG_field# Set new status field to -1
    	eval(["ABG_field.",name,".status=-1;"]);
      endfor;
      
      while( ci_index>0)
    	old_done = inf;
	
    	while done!=old_done	# Inner loop propagates causality
	  old_done = done;
	  for [subsystem,name] = ABG_field
      	    if subsystem.status != 0 # only do this if causality not yet complete
	      comp = subsystem.connections; # Get the bonds on this component
	      bond_list = abs(comp);
	      direction = sign(comp)'*[1 1];
              n_bonds = length(bond_list);

	      if strcmp(subsystem.type,"0") # Change names
	    	subsystem.type = "zero";
	      end;
	      if strcmp(subsystem.type,"1")
	    	subsystem.type = "one";
	      end;
				
	      cause_name = [subsystem.type, "_cause"];# Component causality procedure name
	      eqn_name = [subsystem.type, "_eqn"]; #Component equation procedure name
	      
	      comp_bonds=[];	# Bonds on this component (arrow-orientated) -- these become the
	      for kk = 1:n_bonds # port bonds on the ith component of this subsystem.
	    	comp_bonds(kk,:) = ABG.bonds(bond_list(kk),:);
	      end;

	      if exist(eqn_name)!=2 # Try a compound component
				# Port status depends on whether the corresponding bonds are
				#  fully causal at this stage.
            	one = ones(n_bonds,1);
            	port_status = (sum(abs(comp_bonds'))'==2*one) - one;
		
	    	port_bond_direction = -sign(subsystem.connections)'; # Direction of bonds

            	if exist(cause_name)==2	# If there is a predefined causality function; use it
		  comp_bonds = comp_bonds.*(port_bond_direction*[1 1]);	# Convert from arrow orientated to component orientated causality
		  eval([ "[comp_bonds] = ", cause_name, "(comp_bonds);" ]); # Evaluate the built-in causality procedure

		  comp_bonds = comp_bonds.*(port_bond_direction*[1 1]);	# and convert from component orientated to arrow orientated causality
            	end;
		
	    	[comp_bonds,subsystem.status] = abg2cbg(name, subsystem.type, full_name, 
							comp_bonds, port_bond_direction, port_status, ...
						    	typefile, infofile, errorfile);
				#	# Create a single status from the status vector s
				#	    if max(abs(s)) == 0 # Causal
				#	      status(i) = 0;
				#	    else
				#	      if max(s) == 1 # At least one component is overcausal
				#	    	status(i) = 1;
				#	      else           # no component is overcausal but some are undercausal
				#	    	status(i) = -1;
				#	      end;
				#	    end;
		
	      else # its a simple component -- or explicit causality defined
	    	disp(["---", name, " (", cause_name, ") ---"]);
	    	comp_bonds_in = comp_bonds
	    	
				# Convert from arrow orientated to component orientated causality
	    	comp_bonds = comp_bonds.*direction;
	    	
				# Evaluate the built-in causality procedure
				#eval([ "[comp_bonds,status(i)] = ", cause_name, "(comp_bonds);" ]);
	    	eval([ "[comp_bonds,subsystem.status] = ", cause_name, "(comp_bonds)" ]);
				# and convert from component orientated to arrow orientated causality
            	comp_bonds = comp_bonds.*direction; 
		
	    	comp_bonds_out = comp_bonds
	      end;
	      
	      ABG.bonds(bond_list,:) = comp_bonds;# Update the full bonds list
	      eval(["ABG.subsystems.",name,".status = subsystem.status'"]);
    	    end;
	  end;
	  
	  done = sum(sum(abs(ABG.bonds)))/total*100
				#disp(sprintf("Causality is #3.0f#s complete.", done, pc), infofile));
	  
    	endwhile			# done!=old_done
  	
				# Set causality of a C or I which is not already set
    	[name,prefered] = getdynamic(ABG.subsystems)
    	if prefered==0
	  ci_index=0;
    	else
	  disp("Set causality of a C or I which is not already set")
	  eval(["ci_bond_index = ABG.subsystems.",name,".connections;"]); # Get bonds
	  ci_direction = sign(ci_bond_index);
	  ci_bond_index = abs(ci_bond_index)
	  ABG.bonds(ci_bond_index,1:2) = prefered*ci_direction'*[1 1]
	  eval(["ABG.subsystems.",name,".status=0"]); #set status of the C or I
    	endif
      endwhile			# ( ci_index>0)
    endif				# struct_contains(CBG,field(i,:));
  endfor
#  if n_ports>0
#    status(1:n_ports) = zeros(n_ports,1); # Port status not relevant
#  endif;
  
				# Print final causality
				#  final_done =  (sum(status==zeros(n_components,1))/n_components)*100;
  
  if at_top_level
    mtt_info(sprintf("Final causality of %s is %3.0f%s complete.", ...
		     full_name, done, pc), infofile);
    
    if done<100
      mtt_error(sprintf("Unable to complete causality"),errorfile);
    end;
  endif				# at_top_level
  

  disp(["Writing ", full_name]);
  write_cbg(full_name,system_type,ABG);
  
				# Return the port bonds - arrow orientated causality - and the direction 
  status=0;
  if !at_top_level # Not at top level
    port_bonds = ABG.bonds(port_bond_index,:); # Return port bonds
    for [subsystem,name] = ABG.subsystems
      if subsystem.status==-1	# Under causal
      	status=-1;
      	mtt_info(sprintf("Component %s (%s) is undercausal", name, subsystem.type), ...
		 infofile);
      elseif subsystem.status==1;	# Over causal
      	status=-1;
      	mtt_info(sprintf("Component %s (%s) is overcausal", name, subsystem.type), ...
		 infofile);
      endif;
    endfor;			# [subsystem,name] = ABG.subsystems
  endif;				# at top level

  status, port_bonds
  disp("====================================");
  disp(["END: ", full_name, " (", fun_name, ")"]);
  disp("====================================");

endfunction;







