function structure =  SS_eqn(bond_number,bonds,direction,cr,args, ...
                            structure,filenum);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.3  1996/08/09 14:08:04  peter
% %% Empty effort and flow attributes replaced by 'external'.
% %%
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
zero_outputs = structure(5);

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
    if strcmp(effort_attribute, 'zero') %Zero output
      zero_outputs = zero_outputs + 1;
      fprintf(filenum, 'MTTyz%1.0f := %s;\n', ...
	  zero_outputs, varname(bond_number,1));
      fprintf(filenum, '%s := MTTUi%1.0f;\n', ...
	  varname(bond_number,-1), zero_outputs);
    else
      mtt_info([effort_attribute, ' not appropriate for an output ']);
    end;
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
    if strcmp(flow_attribute, 'zero') %Zero output
      zero_outputs = zero_outputs + 1;
      fprintf(filenum, 'MTTyz%1.0f := %s;\n', ...
	  zero_outputs, varname(bond_number,-1));
      fprintf(filenum, '%s := MTTUi%1.0f;\n', ...
	  varname(bond_number,1), zero_outputs);
    else
      mtt_info([effort_attribute, ' not appropriate for an output ']);
    end;
  end;
end;

  
structure(3) = inputs;
structure(4) = outputs;
structure(5) = zero_outputs;  

  
  






