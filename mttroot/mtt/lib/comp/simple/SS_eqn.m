function structure =  SS_eqn(name,bond_number,bonds,direction,cr,args, ...
    structure,filenum);

% Set up globals to count the component inputs and outputs. This relies on
% the named SS (the ports) being in the correct order. Using globals here
% avoids changing the common argument list for all _eqn files for something
% which is only used for named SS components.
global local_u_index
global local_y_index

% SS_eqn - equations for SS component
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  SS_eqn
% structure =  SS_eqn(name,bond_number,bonds,direction,cr,args, ...
%    structure,filenum);


% Copyright (c) P.J. Gawthrop, 1996.

			
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.13  1997/09/18 13:15:15  peterg
% %% Fixed incorrect error message flagging inappropriate flow outputs
% %% -- used to give the effort rather than the flow in the error message.
% %%
% %% Revision 1.12  1997/08/26 07:51:30  peterg
% %% Now counts the local input and outputs by order of appearence rather
% %% than by port number - it therfore handles ports with bicausality correctely.
% %%
% %% Revision 1.11  1997/05/09 08:21:07  peterg
% %% Explicit computation of port number -- avoids str2num
% %%
% %% Revision 1.10  1997/03/22  17:13:03  peterg
% %% Fixed bug for port nos. > 1 digit!
% %%
% %% Revision 1.9  1997/03/22  15:50:59  peterg
% %% Changed %1.0f to %d format.
% %%
% %% Revision 1.8  1996/12/10 16:52:29  peterg
% %% Detect null string using strcmp, not length.
% %% Put filnum argument to mtt_info.
% %%
% %% Revision 1.7  1996/12/07 17:17:40  peterg
% %% Added some ;
% %%
% %% Revision 1.6  1996/12/05 09:49:09  peterg
% %% Explicit computation of port number from string.
% %%
% %% Revision 1.5  1996/12/04 21:27:53  peterg
% %% Replaced str2num by sprintf
% %%
% %% Revision 1.4  1996/08/18  20:06:21  peter
% %% Included zero outputs.
% %%
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
% If its a numbered port:
%     cr contains 'MTT_port'
%     arg contains port number

STDerr = 2; % Standard output

effort_attribute = cr;
flow_attribute = args;

if strcmp(effort_attribute,'')
  effort_attribute = 'external';
end;

if strcmp(flow_attribute,'')
  flow_attribute = 'external';
end;


inputs = structure(3);
outputs = structure(4);
zero_outputs = structure(5);
unknown_inputs = structure(6);

if strcmp(effort_attribute, 'MTT_port') % Its a named port

% Note: we don't have numbered ports now, so the correct indices are deduced
% by incrementing the two globals: local_u_index and local_y_index
% $$$   % Convert string to number
% $$$   % port_number = abs(flow_attribute)-abs('0');
% $$$   % port_number = str2num(flow_attribute);

% $$$   %Compute port number
% $$$   str_port_number = flow_attribute;
% $$$   N_string = length(str_port_number);
% $$$   port_number=0;
% $$$   for i=1:N_string
% $$$     port_number = 10*port_number + abs(str_port_number(i))-abs('0');
% $$$   end;

  % Effort 
  if bonds(1,1)==-1 % Source
    local_u_index = local_u_index + 1;
    fprintf(filenum, '%s := %s_MTTu%d;\n', ...
        varname(name, bond_number,1), name, local_u_index);
  else % Sensor
    local_y_index = local_y_index + 1;
    fprintf(filenum, '%s_MTTy%d := %s;\n', ...
        name, local_y_index, varname(name, bond_number,1));
  end;
  % Flow 
  if bonds(1,2)==1 % Source
    local_u_index = local_u_index + 1;
    fprintf(filenum, '%s := %s_MTTu%d;\n', ...
        varname(name, bond_number,-1), name, local_u_index);
  else % Sensor
    local_y_index = local_y_index + 1;
    fprintf(filenum, '%s_MTTy%d := %s;\n', ...
        name, local_y_index, varname(name, bond_number,-1));
  end;  
  return
end;

% Now do SS which are not ports.
% Effort
if strcmp(effort_attribute, 'external')
  if bonds(1,1)==-1 % Source
    inputs = inputs+1;
    fprintf(filenum, '%s := MTTu(%d,1);\n', ...
	varname(name, bond_number,1),inputs);
  else % Sensor
    outputs = outputs+1;
    fprintf(filenum, 'MTTy(%d,1) := %s;\n', ...
	outputs, varname(name, bond_number,1));
  end;
elseif strcmp(effort_attribute, 'internal')
  % Do nothing
else 
  if bonds(1,1)==-1 % Named or unknown source
    if strcmp(effort_attribute, 'unknown') % Unknown input
      fprintf(filenum, '%s := MTTUi%d;\n', ...
	  varname(name, bond_number,-1), zero_outputs);
    else
      fprintf(filenum, '%s := %s;\n', ...
	  varname(name, bond_number,1), effort_attribute);
    end;
  else % Sensor
    if strcmp(effort_attribute, 'zero') %Zero output
      zero_outputs = zero_outputs + 1;
      fprintf(filenum, 'MTTyz%d := %s;\n', ...
	  zero_outputs, varname(name, bond_number,1));
    else
      mtt_info([effort_attribute, ' not appropriate for an output '],STDerr);
    end;
  end;
end;
  
% Flow
if strcmp(flow_attribute, 'external')
  if bonds(1,2)==1 % Source
    inputs = inputs+1;
    fprintf(filenum, '%s := MTTu(%d,1);\n', varname(name, bond_number,-1),inputs);
  else % Sensor
    outputs = outputs+1;
    fprintf(filenum, 'MTTy(%d,1) := %s;\n', outputs, ...
	varname(name, bond_number,-1));
  end;
elseif strcmp(flow_attribute, 'unknown') % Unknown input
  unknown_inputs = unknown_inputs + 1;
  fprintf(filenum, '%s := MTTUi%d;\n', ...
      varname(name, bond_number,-1), unknown_inputs);
elseif strcmp(flow_attribute, 'internal')
  % Do nothing
else % Named constant
  if bonds(1,2)==1 % Source
    fprintf(filenum, '%s := %s;\n', ...
	varname(name, bond_number,-1), flow_attribute);
  else % Sensor
    if strcmp(flow_attribute, 'zero') %Zero output
      zero_outputs = zero_outputs + 1;
      fprintf(filenum, 'MTTyz%d := %s;\n', ...
	  zero_outputs, varname(name, bond_number,-1));
    else
      mtt_info([flow_attribute, ' not appropriate for an output '], ...
	  STDerr);
    end;
  end;
end;

structure(3) = inputs;
structure(4) = outputs;
structure(5) = zero_outputs;
structure(6) = unknown_inputs;
