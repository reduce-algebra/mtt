function structure = cbg2ese(system_name,bonds,eqnfile,infofile)
% cbg2ese(system_name,bonds,infofile)
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  cbg2ese.m
% Acausal bond graph to causal bond graph: mfile format

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


pc = '%';
if nargin<3
  eqnfile = 'stdout';
end;
if nargin<4
  infofile = 'stdout';
end;

% Evaluate the system function to get the bonds
fun_name = [system_name, '_cbg']
if exist(fun_name)~=2
  mtt_info(['m-file ', fun_name, ' does not exist'], infofile);
else
  eval(['bonds=', fun_name, ';']);
  fun_name = [system_name, '_abg'];
  eval(['[junk,components]=', fun_name, ';']);

  % Find number of bonds
  [n_bonds,columns] = size(bonds);
  if (columns ~= 2)&(n_bonds>0)
    error('Incorrect bonds matrix: must have 2 columns');
  end;

  % Find number of components
  [n_components,columns] = size(components);
  
  %Structure matrix [states,nonstates,inputs,outputs]
  structure = zeros(1,4);


  for i = 1:n_components
    comp = nozeros(components(i,:));
    bond_list = abs(comp);
    direction = sign(comp)'*[1 1];
    % Convert from arrow orientated to component orientated causality
    comp_bonds = bonds(bond_list,:).*direction;
    eval([ '[comp_type,name,cr,args] = ', system_name, '_cmp(i);' ]);
    % change name of 0 and 1 components -- matlab doesn't like numbers here
    if strcmp(comp_type,'0')
      comp_type = 'zero';
    end;
    if strcmp(comp_type,'1')
      comp_type = 'one';
    end;
    % Invoke the appropriate equation-generating procedure
    eqn_name = [comp_type, '_eqn']
    if exist(eqn_name)~=2 % Try a compound component
      cbg2ese(comp_type,comp_bonds,eqnfile);
    else % its a simple component
      eval(['structure = ', ...
	    eqn_name, '(bond_list,comp_bonds,direction,cr,args,structure,eqnfile);' ]);
    end;
  end;
end;
