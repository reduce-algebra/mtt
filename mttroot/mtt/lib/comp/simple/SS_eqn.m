function structure =  SS_eqn(name,bond_number,bonds,direction,cr,args, ...
    structure,filenum);
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

if strcmp(effort_attribute, 'MTT_port') % Its a numbered port
  % Convert string to number
  port_number = abs(flow_attribute)-abs('0');

  % Effort 
  if bonds(1,1)==-1 % Source
    fprintf(filenum, '%s := %s_MTTu%d;\n', ...
        varname(name, bond_number,1), name, port_number);
  else % Sensor
    fprintf(filenum, '%s_MTTy%d := %s;\n', ...
        name, port_number, varname(name, bond_number,1));
  end;
  % Flow 
  if bonds(1,2)==1 % Source
    fprintf(filenum, '%s := %s_MTTu%d;\n', ...
        varname(name, bond_number,-1), name, port_number);
  else % Sensor
    fprintf(filenum, '%s_MTTy%d := %s;\n', ...
        name, port_number, varname(name, bond_number,-1));
  end;  
  return
end;


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
else % named constant
  if bonds(1,1)==-1 % Source
    fprintf(filenum, '%s := %s;\n', ...
	varname(name, bond_number,1), effort_attribute);
  else % Sensor
    if strcmp(effort_attribute, 'zero') %Zero output
      zero_outputs = zero_outputs + 1;
      fprintf(filenum, 'MTTyz%d := %s;\n', ...
	  zero_outputs, varname(name, bond_number,1));
      fprintf(filenum, '%s := MTTUi%d;\n', ...
	  varname(name, bond_number,-1), zero_outputs);
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
      fprintf(filenum, '%s := MTTUi%d;\n', ...
	  varname(name, bond_number,1), zero_outputs);
    else
      mtt_info([effort_attribute, ' not appropriate for an output '], STDerr);
    end;
  end;
end;

