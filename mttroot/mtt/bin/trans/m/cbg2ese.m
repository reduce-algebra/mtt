function structure = cbg2ese(system_name, system_type, full_name, ...
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

% Create the (full) system name
if length(full_name)==0
  full_name = system_name;
  system_type = system_name;
else
  full_name = [full_name, '_', system_name];
end;

full_name_type = [full_name, '_', system_type];
cbg_name = [full_name_type, '_cbg'];
abg_name = [system_type, '_abg'];
cmp_name = [system_type, '_cmp'];
% Return if cbg file doesn't exist
if exist(cbg_name)~=2
  return
end;

% Setup file
ese_name = sprintf('%s_%1.0f_ese.r', full_name, repetition);
filenum = fopen(ese_name, 'w');

% Evaluate the system function to get the bonds
  eval(['[junk,components]=', abg_name, ';']);
  eval(['bonds=', cbg_name, ';']);
  % Find number of bonds
  [n_bonds,columns] = size(bonds);
  if (columns ~= 2)&(n_bonds>0)
    error('Incorrect bonds matrix: must have 2 columns');
  end;

  % Find number of components
  [n_components,columns] = size(components);
  n_components = n_components
  for i = 1:n_components
    comp = nozeros(components(i,:));
    bond_list = abs(comp);
    direction = sign(comp)'*[1 1];
    % Convert from arrow orientated to component orientated causality
    comp_bonds = bonds(bond_list,:).*direction;
    eval([ '[comp_type,comp_name,cr,args,repetitions] = ', cmp_name, '(i);' ]);
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
      next_bond = max(max(abs(components)))+1;
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
      name_r = sprintf('%s_%1.0f', full_name, repetition);
      eqn_name = [comp_type, '_eqn']
      if exist(eqn_name)~=2 % Try a compound component
	disp('---PUSH---');
	structure = cbg2ese(comp_name, comp_type, full_name, k, ...
	    structure,  infofile);
	% Link up the bonds
	name_k = sprintf('%s_%1.0f', full_name, k);
	name_comp_name = sprintf('%s_%s_%1.0f', full_name, comp_name, k);
	for port_number=1:length(bond_list)

	  % Effort
	  if comp_bonds(port_number,1)==1 % Source
	     fprintf(filenum, '%s_MTT_inport_%1.0f := %s;\n', ...
		 name_comp_name, port_number, varname(name_r, ...
		 bond_list(port_number),1));
	   else % sensor
	     	 fprintf(filenum, '%s := %s_MTT_outport_%1.0f;\n', ...
		 varname(name_r, ...
		 bond_list(port_number),1), name_comp_name, port_number);
	  end;
	  % flow
	  if comp_bonds(port_number,2)==-1 % Source
	     fprintf(filenum, '%s_MTT_inport_%1.0f := %s;\n', ...
		 name_comp_name, port_number, varname(name_r, ...
		 bond_list(port_number),-1));
	   else % sensor
	     	 fprintf(filenum, '%s := %s_MTT_outport_%1.0f;\n', ...
		 varname(name_r, ...
		 bond_list(port_number),-1), name_comp_name, port_number);
	   end;	
	 end;
	
	disp('---POP---');
      else % its a simple component
	eval(['structure = ', ...
	      eqn_name, ...
	      '(name_r,bond_list,comp_bonds,direction,cr,args,structure,filenum);' ]);
      end;
    end;
  end;

  fclose(filenum);










