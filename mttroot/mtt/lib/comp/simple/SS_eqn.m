function structure =  SS_eqn(name,Bond_number,Bonds,Direction,cr,args, ...
    structure,filenum);

disp("SS_eqn");
name,Bond_number,Bonds,Direction

% Set up globals to count the component inputs and outputs. This relies on
% the named SS (the ports) being in the correct order. Using globals here
% avoids changing the common argument list for all _eqn files for something
% which is only used for named SS components.
global local_u_index
global local_y_index
global at_top_level

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
% %% Revision 1.23  1998/12/03 16:46:16  peterg
% %% Deblanked attributes so that zero attribute works.
% %%
% %% Revision 1.22  1998/07/28 19:05:46  peterg
% %% Fixed a few bugs.
% %%
% %% Revision 1.21  1998/07/28 14:21:31  peterg
% %% Vector SS ports.
% %%
% %% Revision 1.20  1998/07/08 14:42:52  peterg
% %% Removed the annoying info message - it causes problems with big
% %% systems
% %%
% %% Revision 1.19  1998/07/08 11:33:54  peterg
% %% Replace mtt_info by mtt_error when appropriate
% %%
% %% Revision 1.18  1998/07/08 11:30:45  peterg
% %% Removed second (fileID) argument from mtt_info
% %%
% %% Revision 1.17  1998/07/04 07:15:44  peterg
% %% Back under RCS
% %%
% %% Revision 1.16  1998/04/11 19:07:16  peterg
% %% Now do named ports as ordinary ports iff at top level.
% %% --- not yet complete, need to pass necesssary info though to this
% %%     function
% %%
% %% Revision 1.15  1997/12/16 19:16:07  peterg
% %% Added unknown input to the effort part.
% %%
% %% Revision 1.14  1997/12/16 18:25:19  peterg
% %% Added unknown_input attribure to flow -- effort still needs doing
% %%
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

if (strcmp(cr,"SS"))		# Then its the standard file
  a = split(args,",")
  [N,M]=size(a);
  if (N~=2)			# Must have 2 arguments
    mtt_error(sprintf("SS should have 2 args not %i", N));
  end;

  effort_attribute = deblank(a(1,:));
  flow_attribute   = deblank(a(2,:));

else				# Old style file
  effort_attribute = cr;
  flow_attribute = args;
				# mtt_info(sprintf("SS component: Hmm... looks like an old-style label file"));
end;

% Default attributes
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
  
n_bonds = length(Bond_number)	# Multi port?
for i=1:n_bonds			# Loop over all the bonds
  bond_number = Bond_number(i);
  bonds = Bonds(i,:);
  direction = Direction(i,:);
  
 Named_Port = name(1)=="[";	
 if Named_Port
   sname = name(2:length(name)); #Strip the []
 else
   sname = name;
 end;
  
   if Named_Port&&~at_top_level % It's a named port
    % Effort 
    if bonds(1,1)==-1 % Source
      local_u_index = local_u_index + 1
      fprintf(filenum, "%s := %s_MTTu%d;\n", ...
              varname(sname, bond_number,1), sname, local_u_index);
    else % Sensor
      local_y_index = local_y_index + 1
      fprintf(filenum, "%s_MTTy%d := %s;\n", ...
              sname, local_y_index, varname(sname, bond_number,1));
    end;
    % Flow 
    if bonds(1,2)==1 % Source
      local_u_index = local_u_index + 1
      fprintf(filenum, "%s := %s_MTTu%d;\n", ...
              varname(sname, bond_number,-1), sname, local_u_index);
    else % Sensor
      local_y_index = local_y_index + 1
      fprintf(filenum, "%s_MTTy%d := %s;\n", ...
              sname, local_y_index, varname(sname, bond_number,-1));
    end;  
  else				# Now do SS which are not ports
    % Effort
    if strcmp(effort_attribute, "external")
      if bonds(1,1)==-1 % Source
	inputs = inputs+1;
	fprintf(filenum, "%s := MTTu(%d,1);\n", ...
		varname(sname, bond_number,1),inputs);
      else % Sensor
	outputs = outputs+1;
	fprintf(filenum, "MTTy(%d,1) := %s;\n", ...
		outputs, varname(sname, bond_number,1));
      end;
    elseif strcmp(effort_attribute, "unknown") % Unknown input
      unknown_inputs = unknown_inputs + 1;
      fprintf(filenum, "%s := MTTUi%d;\n", ...
	      varname(sname, bond_number,1), unknown_inputs);
    elseif strcmp(effort_attribute, "internal")
      % Do nothing
    else 
      if bonds(1,1)==-1 % Named or unknown source
	fprintf(filenum, "%s := %s;\n", ...
		varname(sname, bond_number,1), effort_attribute);
      else % Sensor
	if strcmp(effort_attribute, "zero") %Zero output
	  zero_outputs = zero_outputs + 1;
	  fprintf(filenum, "MTTyz%d := %s;\n", ...
		  zero_outputs, varname(sname, bond_number,1));
	else
	  mtt_error([effort_attribute, " not appropriate for an output "]);
	end;
      end;
    end;
    
    % Flow
    if strcmp(flow_attribute, "external")
      if bonds(1,2)==1 % Source
	inputs = inputs+1
	fprintf(filenum, "%s := MTTu(%d,1);\n", varname(sname, bond_number,-1),inputs);
      else % Sensor
	outputs = outputs+1
	fprintf(filenum, "MTTy(%d,1) := %s;\n", outputs, ...
		varname(sname, bond_number,-1));
      end;
    elseif strcmp(flow_attribute, "unknown") % Unknown input
      unknown_inputs = unknown_inputs + 1
      fprintf(filenum, "%s := MTTUi%d;\n", ...
	      varname(sname, bond_number,-1), unknown_inputs);
    elseif strcmp(flow_attribute, "internal")
      % Do nothing
    else % Named constant
      if bonds(1,2)==1 % Source
	fprintf(filenum, "%s := %s;\n", ...
		varname(sname, bond_number,-1), flow_attribute);
      else % Sensor
	if strcmp(flow_attribute, "zero") %Zero output
	  zero_outputs = zero_outputs + 1
	  fprintf(filenum, "MTTyz%d := %s;\n", ...
		  zero_outputs, varname(sname, bond_number,-1));
	else
	  mtt_error([flow_attribute, " not appropriate for an output "]);
	end;
      end;
    end;
  end;
  structure(3) = inputs;
  structure(4) = outputs;
  structure(5) = zero_outputs;
  structure(6) = unknown_inputs;
  
end;
