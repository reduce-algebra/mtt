function structure = cbg2ese(system_name, system_type, system_cr, ...
    system_args, full_name, full_name_repetition, ...
    repetition,...
    structure, infofile)
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  cbg2ese.m
% Acausal bond graph to causal bond graph: mfile format
% Structure matrix [states,nonstates,inputs,outputs,zero_outputs]

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.9  1996/12/04 21:49:47  peterg
% %% Compares full-name with empty string (instead of testing for zero
% %% length)
% %%
% %% Revision 1.8  1996/08/30  16:36:08  peter
% %% More info written to ese files.
% %%
% %% Revision 1.7  1996/08/30 11:23:13  peter
% %% Argument substitution implemented.
% %%
% %% Revision 1.6  1996/08/27  08:04:52  peterg
% %% Handles complex components and repetative components.
% %%
% %% Revision 1.5  1996/08/24  15:02:23  peter
% %% Writes `END;' to keep reduce happy.
% %%
% %% Revision 1.4  1996/08/19 09:03:41  peter
% %% Handles repeating components.
% %%
% %% Revision 1.3  1996/08/18 20:08:02  peter
% %% Included additional structure: structure(5) = zero_outputs.
% %%
% %% Revision 1.2  1996/08/08 18:08:11  peter
% %% Sorted out file naming sceme
% %%
% %% Revision 1.1  1996/08/08 15:53:23  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

system_name, system_type, full_name,

pc = '%';
if nargin<3
  eqnfile = 'stdout';
end;
if nargin<4
  infofile = 'stdout';
end;

% Are we at the top level of the heirarchy?
at_top_level = strcmp(full_name, '');

% Create the (full) system name
if at_top_level
  full_name = system_name;
  full_name_repetition = system_name;
  system_type = system_name;
else
  full_name = [full_name, '_', system_name];
  full_name_repetition = [full_name_repetition, ...
	'_', system_name, '_', num2str(repetition)];
end;

% $$$ full_name_type = [full_name, '_', system_type];
% $$$ cbg_name = [full_name_type, '_cbg'];
cbg_name = [full_name, '_cbg'];
% Return if cbg file doesn't exist
if exist(cbg_name)~=2
  disp([cbg_name, ' does not exist']);
  return
end;

% Setup file
ese_name = [full_name_repetition, '_ese.r'];
filenum = fopen(ese_name, 'w');
fprintf(filenum, '\n%s%s Equation file for system %s (file %s)\n', ...
    pc, pc, full_name_repetition, ese_name);
fprintf(filenum, '%s%s Generated by MTT\n\n', pc, pc);

% Evaluate the system function to get the bonds
  eval(['[bonds,status,system_type] = ', cbg_name, ';']);
  abg_name = [system_type, '_abg'];
  cmp_name = [system_type, '_cmp'];
  eval(['[junk,components]=', abg_name, ';']);

  % Find number of bonds
  [n_bonds,columns] = size(bonds);
  if (columns ~= 2)&(n_bonds>0)
    error('Incorrect bonds matrix: must have 2 columns');
  end;

  % Find number of components
  [n_components,columns] = size(components);
  n_components = n_components
  
  % Set up the first dummy bond number - needed for repetative components
  next_bond = max(max(abs(components)))+1;

  for i = 1:n_components
    comp = nozeros(components(i,:));
    bond_list = abs(comp);
    direction = sign(comp)'*[1 1];
    % Convert from arrow orientated to component orientated causality
    comp_bonds = bonds(bond_list,:).*direction;
    
    % Get the component details
    eval([ '[comp_type,comp_name,cr,args,repetitions] = ', cmp_name, '(i);' ...
	  ]);
    
    % Substitute positional ($1 etc) arguments
    cr = subs_arg(cr,system_cr);
    args = subs_arg(args,system_args);
    
    % change name of 0 and 1 components -- matlab doesn't like numbers here
    if strcmp(comp_type,'0')
      comp_type = 'zero';
    end;
    if strcmp(comp_type,'1')
      comp_type = 'one';
    end;
    
    comp_type = comp_type
    ports = length(bond_list)
    repetitions = repetitions
    
    if repetitions>1
      port_pairs = ports/2;
      if round(port_pairs)~=port_pairs;
	mtt_info(['Repeated component ', comp_name, ...
	      ' has an odd number of ports - ignoring repetitions']);
	repetitions = 1;
      end;
    end;
    
    if repetitions>1
      odd_bonds = bond_list(1:2:ports-1);
      even_bonds = bond_list(2:2:ports);
    end;
    
    for k = 1:repetitions
      
      if repetitions>1
	
	if k==1
	  bond_list(1:2:ports-1) = odd_bonds;
	else
	  bond_list(1:2:ports-1) = bond_list(2:2:ports);
	end;
	
	if k==repetitions
	  bond_list(2:2:ports) = even_bonds;
	else
	  new_bonds = [next_bond:next_bond+port_pairs-1];
	  next_bond = next_bond+port_pairs;
	  bond_list(2:2:ports) = new_bonds;
	end;
	
      end;
	
      % Invoke the appropriate equation-generating procedure
      name_r = full_name_repetition;
      eqn_name = [comp_type, '_eqn']
      
      if exist(eqn_name)~=2 % Try a compound component
	disp('---PUSH---');
	structure = cbg2ese(comp_name, comp_type, cr, args, ...
	    full_name, full_name_repetition, ...
	    k, structure,  infofile);
	
	% Link up the bonds
	fprintf(filenum, ...
	    '\n\t%s Equations linking up subsystem %s (%s)\n\n', ...
	    pc, comp_name, comp_type);
	name_comp_name = sprintf('%s_%s_%1.0f', ...
	    full_name_repetition, comp_name, k);
	
	for port_number=1:length(bond_list)
	  % Effort
	  if comp_bonds(port_number,1)==1 % Source
	     fprintf(filenum, '%s_MTTu%1.0f := %s;\n', ...
		 name_comp_name, port_number, varname(name_r, ...
		 bond_list(port_number),1));
	   else % sensor
	     	 fprintf(filenum, '%s := %s_MTTy%1.0f;\n', ...
		 varname(name_r, ...
		 bond_list(port_number),1), name_comp_name, port_number);
	  end;
	  % flow
	  if comp_bonds(port_number,2)==-1 % Source
	     fprintf(filenum, '%s_MTTu%1.0f := %s;\n', ...
		 name_comp_name, port_number, varname(name_r, ...
		 bond_list(port_number),-1));
	   else % sensor
	     	 fprintf(filenum, '%s := %s_MTTy%1.0f;\n', ...
		 varname(name_r, ...
		 bond_list(port_number),-1), name_comp_name, port_number);
	   end;	
	 end;
	
	disp('---POP---');
      else % its a simple component
	fprintf(filenum, '\n\t%s Equations for component %s (%s), repetition %1.0f\n\n', ...
	    pc, comp_name, comp_type,k);
	
% Take port SS to be ordinary SS at top level
if at_top_level & strcmp(comp_type, 'SS') 
  effort_attribute = cr;
  flow_attribute = args;
  if strcmp(effort_attribute, 'MTT_port') % Its a numbered port
    effort_attribute = 'external';
    flow_attribute = 'external';
    cr = effort_attribute;
    args = flow_attribute;
  end;
end;

eval(['structure = ', ...
	      eqn_name, ...
	      '(name_r,bond_list,comp_bonds,direction,cr,args,structure,filenum);' ]);
      end;
    end;
  end;

  fclose(filenum);










