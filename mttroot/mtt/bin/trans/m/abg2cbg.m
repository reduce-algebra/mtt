function [port_bonds, status] = abg2cbg(system_name, ...
    system_type, full_name, ...
    port_bonds,infofile)
% [bonds,status] = abg2cbg(system_name, system_type, full_name, port_bonds, infofile)
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  abg2cbg.m
% Acausal bond graph to causal bond graph: mfile format

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%Revision 1.7  1996/08/16  12:58:58  peter
% %% Now does preferred causality of I and C.
% %% Revision 1.6  1996/08/09 08:27:29  peter
% %% Added a few deguging lines
% %%
% %% Revision 1.5  1996/08/08 18:06:18  peter
% %% Unified file naming scheme
% %%
% %% Revision 1.4  1996/08/08 08:30:06  peter
% %% The cbg filename contains the system name - this makes things easier
% %% when setting up the m to fig translation and m to ese translation
% %%
% %% Revision 1.3  1996/08/05 18:53:21  peter
% %% Fixed bug passing causality from subsystems.
% %%
% %% Revision 1.2  1996/08/05 15:41:41  peter
% %% Now recursively does causality on subsystems.
% %%
% %% Revision 1.1  1996/08/04 17:55:55  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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

% Create the (full) system name
if length(full_name)==0
  full_name = system_name;
  system_type = system_name;
else
  full_name = [full_name, '_', system_name];
end;

fun_name = [system_type, '_abg']

% If no such function - then there is nothing to be done.
if exist(fun_name)~=2
  mtt_info(['m-file ', fun_name, ' does not exist'], infofile);
  bonds = [];
  status = [];
  return
end;

% Evaluate the system function to get the bonds
eval(['[bonds,components,n_ports]=', fun_name, ';']);

% Find number of bonds
[n_bonds,columns] = size(bonds);
if (columns ~= 2)&(n_bonds>0)
  error('Incorrect bonds matrix: must have 2 columns');
end;

 
% Find number of components
[n_components,columns] = size(components);
if n_components==0 % there is nothing to be done
  return
end;

% Find number of port bonds
[n_port_bonds,columns] = size(port_bonds);

% Check compatibility - if ok copy port bonds to the internal bonds list.
if n_port_bonds~=n_ports
  mtt_info(sprintf('%1.0f port bonds incompatible with %1.0f ports', ...
      n_port_bonds, n_ports), infofile);
else % Copy the port bonds
  for i = 1:n_ports
    bonds(i,:) = port_bonds(i,:);
  end;
end;


% Set initial status
status = -ones(n_components,1);
total = 2*n_bonds;

done = sum(sum(abs(bonds)))/total*100;

% Outer while loop sets preferred causality
ci_index=1;
while ci_index>0
  old_done = inf;
  % Inner loop propogates causality
  while done~=old_done
    disp(sprintf('Causality is %3.0f%s complete.', done, pc));
    old_done = done;
  
    for i = 1:n_components
      comp = nozeros(components(i,:));
      bond_list = abs(comp);
      direction = sign(comp)'*[1 1];
      % Convert from arrow orientated to component orientated causality
      comp_bonds = bonds(bond_list,:).*direction;
      eval([ '[comp_type,name,cr,arg] = ', system_type, '_cmp(i);' ]);
      % change name of 0 and 1 components -- matlab doesn't like numbers here
      if strcmp(comp_type,'0')
	comp_type = 'zero';
      end;
      if strcmp(comp_type,'1')
	comp_type = 'one';
      end;
      
      % Component causality procedure name
      cause_name = [comp_type, '_cause'];
      
      % Invoke  the appropriate causality procedure
      if exist(cause_name)~=2 % Try a compound component
	% disp('------------PUSH-----------------');
	[comp_bonds,s] = abg2cbg(name, comp_type, full_name, comp_bonds, ...
	    infofile);
	status(i)=max(abs(s));
	% disp('------------POP-----------------');
      else % its a simple component
	% disp(['---', name, ' (', cause_name, ') ---']);
	% comp_bonds
	eval([ '[comp_bonds,status(i)] = ', cause_name, '(comp_bonds);' ]);
	% comp_bonds
      end;
      
      % Update the full bonds list
      % and convert from component orientated to arrow orientated causality
      bonds(bond_list,:) = comp_bonds.*direction; 
    end;
    
    
    done = sum(sum(abs(bonds)))/total*100;
    %  mtt_info(sprintf('Causality is %3.0f%s complete.', done, pc), infofile);
    
  end;
  
  % Set causality of C and I which is not set
  [ci_index,prefered] = getdynamic(status,system_type);
  if ci_index>0
    bond_index = components(ci_index,1) % its a one port
    bonds(bond_index,1) = prefered;
    bonds(bond_index,2) = prefered;
  end;
  
end;

% Print final causality
final_done =  (sum(status==zeros(n_components,1))/n_components)*100;;
mtt_info(sprintf('Final causality is %3.0f%s complete.', final_done, pc), infofile);

% List overcausal bonds
[over_causal_bonds,n] = getindex(status,1);
if n>0
  for i=over_causal_bonds'
    eval([ '[comp_type,name] = ', system_type, '_cmp(i);' ]);
    mtt_info(sprintf('Component %s (%s) is overcausal', name, comp_type), ...
      infofile);
  end;
end;

% List undercausal bonds
[under_causal_bonds,n] = getindex(status,-1);
if n>0
  for i=under_causal_bonds'
    eval([ '[comp_type,name] = ', system_type, '_cmp(i);' ]);
    mtt_info(sprintf('Component %s (%s) is undercausal', name, comp_type), ...
      infofile);
  end;
end;

file_name = [full_name, '_', system_type]
write_cbg(file_name,bonds,status);

% Return the port bonds
for i = 1:n_ports
  port_bonds(i,:) = bonds(i,:);
end;

disp('----------------------');









