function [bonds,status] = abg2cbg(system_name,bonds,infofile)
% [bonds,status] = abg2cbg(system_name,bonds,infofile)
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
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


pc = '%';
if nargin<3
  infofile = 'stdout';
end;

% Evaluate the system function to get the bonds
fun_name = [system_name, '_abg']
if exist(fun_name)~=2
  mtt_info(['m-file ', fun_name, ' does not exist'], infofile);
  bonds = [];
  status = [];
else
  eval(['[bonds,components]=', fun_name, ';']);

  % Find number of bonds
  [n_bonds,columns] = size(bonds);
  if (columns ~= 2)&(n_bonds>0)
    error('Incorrect bonds matrix: must have 2 columns');
  end;

  % Find number of components
  [n_components,columns] = size(components);

  % Set initial status
  status = -ones(n_components,1);
  total = 2*n_bonds;
  done = sum(sum(abs(bonds)))/total*100;
  mtt_info(sprintf('Initial causality is %3.0f%s complete.', done, pc), infofile);

  old_done = inf;

  while done~=old_done
    disp(sprintf('Causality is %3.0f%s complete.', done, pc));
    old_done = done;

    for i = 1:n_components
      comp = nozeros(components(i,:));
      bond_list = abs(comp);
      direction = sign(comp)'*[1 1];
      % Convert from arrow orientated to component orientated causality
      comp_bonds = bonds(bond_list,:).*direction;
      eval([ '[comp_type,name,cr,arg] = ', system_name, '_cmp(i);' ]);
      % change name of 0 and 1 components -- matlab doesn't like numbers here
      if strcmp(comp_type,'0')
	comp_type = 'zero';
      end;
      if strcmp(comp_type,'1')
	comp_type = 'one';
      end;
      
      % Invoke  the appropriate causality procedure
      cause_name = [comp_type, '_cause'];
      if exist(cause_name)~=2 % Try a compound component -- need doing
       mtt_info(sprintf('Component %s is unknown', comp_type), infofile);
% $$$ 	sys_name = [comp_type, '_abg'];
% $$$ 	agb2cbg(sys_name,comp_bonds,infofile);
      else % its a simple component
	cause_name
	eval([ '[comp_bonds,status(i)] = ', cause_name, '(comp_bonds);' ]);
        % Convert from component orientated to arrow orientated causality
	bonds(bond_list,:) = comp_bonds.*direction; 
      end;
    end;

    done = sum(sum(abs(bonds)))/total*100;
%  mtt_info(sprintf('Causality is %3.0f%s complete.', done, pc), infofile);

  end;
end;

final_done =  (sum(status==zeros(n_components,1))/n_components)*100;;

mtt_info(sprintf('Final causality is %3.0f%s complete.', final_done, pc),
infofile);

% List overcausal bonds
[over_causal_bonds,n] = getindex(status,1)
if n>0
  for i=over_causal_bonds'
    eval([ '[comp_type,name] = ', system_name, '_cmp(i);' ]);
    mtt_info(sprintf('Component %s (%s) is overcausal', name, comp_type), ...
      infofile);
  end;
end;

% List undercausal bonds
[under_causal_bonds,n] = getindex(status,-1)
if n>0
  for i=under_causal_bonds'
    eval([ '[comp_type,name] = ', system_name, '_cmp(i);' ]);
    mtt_info(sprintf('Component %s (%s) is undercausal', name, comp_type), ...
      infofile);
  end;
end;























