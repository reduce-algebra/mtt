function structure =  SS_eqn(bond_number,bonds,direction,cr,args, ...
                            structure,filenum);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.2  1996/08/08 16:38:19  peter
% %% Changed to filenumer type of fprintf
% %%
% %% Revision 1.1  1996/08/08 16:19:08  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% The string 'cr' contains the effort attributes;  
% 'arg' contains the flow attributes. 
% external indicates an external variable
% internal indicates an internal variable
% anything else is the name of a constant.
% Blank is taken to be external

effort_attribute = cr;
flow_attribute = args;

if length(effort_attribute)==0
  effort_attribute = 'external';
end;

if length(flow_attribute)==0
  flow_attribute = 'external';
end;

inputs = structure(3);
outputs = structure(4);

% Effort
if strcmp(effort_attribute, 'external')
  if bonds(1,1)==-1 % Source
    inputs = inputs+1;
    fprintf(filenum, '%s := MTTu(%1.0f,1);\n', ...
        varname(bond_number,1),inputs);
  else % Sensor
    outputs = outputs+1;
    fprintf(filenum, 'MTTy(%1.0f,1) := %s;\n', ...
        outputs, varname(bond_number,1));
  end;
elseif strcmp(effort_attribute, 'internal')
  % Do nothing
else % named constant
  if bonds(1,1)==-1 % Source
    fprintf(filenum, '%s := %s;\n', ...
        varname(bond_number,1), effort_attribute);
  else % Sensor
  % THIS STILL NEEDS DOING!
  mtt_info('Constant outputs not implemented yet!');
  end;
end;

% Flow
if strcmp(flow_attribute, 'external')
  if bonds(1,2)==1 % Source
    inputs = inputs+1;
    fprintf(filenum, '%s := MTTu(%1.0f,1);\n', varname(bond_number,-1),inputs);
  else % Sensor
    outputs = outputs+1;
    fprintf(filenum, 'MTTy(%1.0f,1) := %s;\n', outputs, ...
        varname(bond_number,-1));
  end;
elseif strcmp(flow_attribute, 'internal')
  % Do nothing
else % Named constant
  if bonds(1,2)==1 % Source
    fprintf(filenum, '%s := %s;\n', ...
	varname(bond_number,-1), flow_attribute);
  else % Sensor
  % THIS STILL NEEDS DOING!
  mtt_info('Zero outputs not implemented yet!');
  end;
end;

  
structure(3) = inputs;
structure(4) = outputs;
  

  
  






