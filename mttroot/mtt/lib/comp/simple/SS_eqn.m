function structure =  SS_eqn(bond_number,bonds,direction,cr,args, ...
                            structure,eqnfile);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<7
  eqnfile = 'stdout';
end;

% The string 'cr' contains the effort attributes;  
% 'arg' contains the flow attributes. 
% external indicates an external variable
% internal indicates an internal variable
% anything else is the name of a constant.

effort_attribute = cr;
flow_attribute = args;

inputs = structure(3);
outputs = structure(4);

% Effort
if strcmp(effort_attribute, 'external')
  if bonds(1,1)==-1 % Source
    inputs = inputs+1;
    fprintf(eqnfile, '%s := MTTu(%1.0f,1);\n', ...
        varname(bond_number,1),inputs);
  else % Sensor
    outputs = outputs+1;
    fprintf(eqnfile, 'MTTy(%1.0f,1) := %s;\n', ...
        outputs, varname(bond_number,1));
  end;
elseif strcmp(effort_attribute, 'internal')
  % Do nothing
else % named constant
  if bonds(1,1)==-1 % Source
    fprintf(eqnfile, '%s := %s;\n', ...
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
    fprintf(eqnfile, '%s := MTTu(%1.0f,1);\n', varname(bond_number,-1),inputs);
  else % Sensor
    outputs = outputs+1;
    fprintf(eqnfile, 'MTTy(%1.0f,1) := %s;\n', outputs, ...
        varname(bond_number,-1));
  end;
elseif strcmp(flow_attribute, 'internal')
  % Do nothing
else % Named constant
  if bonds(1,2)==1 % Source
    fprintf(eqnfile, '%s := %s;\n', ...
	varname(bond_number,-1), flow_attribute);
  else % Sensor
  % THIS STILL NEEDS DOING!
  mtt_info('Zero outputs not implemented yet!');
  end;
end;

  
structure(3) = inputs;
structure(4) = outputs;
  

  
  






