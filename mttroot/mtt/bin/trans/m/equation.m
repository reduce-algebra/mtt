function eqn =  equation(name,cr,args,outbond,outcause,outport, ...
                              inbonds,incauses,inports)
% eqn is a string containing the equation
% 
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function equations.m
% eqn =  equation(name,cr,args,outbond,outcause,outport, ...
%                              inbonds,incauses,inports)


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.5  1996/12/05  11:26:51  peterg
% %% Null strings now detected with strcmp not length.
% %%
% %% Revision 1.4  1996/09/12 16:42:01  peter
% %% Default now out side this function - need to be none for each
% %% component.
% %%
% %% Revision 1.3  1996/09/12 12:03:58  peter
% %% Added some error checking.
% %% If no constitutive relationship, only add diagonal elementts to
% %% default unity output.
% %%
% %% Revision 1.2  1996/09/10 11:29:47  peter
% %% Removed causality & port info when no constitutive relationship.
% %%
% %% Revision 1.1  1996/09/10 11:11:11  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


inbonds
incauses

% Find the number of inports
nports = length(inbonds)

% Check some arguments
if length(incauses) ~= nports
  error('equation.m: incauses inconsistent with inbonds');
end;

if length(inports) ~= nports
  error('equation.m: inports inconsistent with inbonds');
end;

% Set up LHS
LHS = varname(name, outbond, outcause);

% Set up various strings to get correct syntax if some strings are empty
if strcmp(cr,'')
  cause_name = '';
  port_name = '';
  lp = '';
  rp = '';
  c_comma = '';
else
  cause_name = cause2name(outcause);
  port_name = sprintf('%1.0f', outport');
  lp = '(';
  rp = ')';
  c_comma = ',';
end

if strcmp(args,'')
  a_comma = '';
else
  a_comma = ',';
end;

% Set up first line of RHS
RHS1 = sprintf('%s%s%s%s%s%s%s%s\n', ...
    cr, lp, args, a_comma, cause_name, c_comma, port_name, c_comma);


% Set up rest of RHS - the input variables, causality and ports.
RHS2 = '';
for i=1:nports
  RHS2 = sprintf('%s\t%s', ...
      RHS2, varname(name, inbonds(i), incauses(i)));
  
  if strcmp(cr,'')==0 % add the causality & port info
    RHS2 = sprintf('%s,%s,%1.0f', ...
	RHS2, cause2name(incauses(i)), inports(i));
  end;
  
  if (i<nports) % Add a comma
    RHS2 = sprintf('%s,\n',RHS2);
  else
    RHS2 = sprintf('%s\n',RHS2);
  end;
end;
 
 
% Set up equation
eqn = sprintf('%s := %s%s\t%s;\n', LHS, RHS1, RHS2, rp);


