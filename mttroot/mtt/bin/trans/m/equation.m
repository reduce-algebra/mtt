function eqn =  equation(name,cr,args,outbond,outcause,outport, ...
                              inbonds,incauses,inports)
% eqn is a string containing the equation
% 
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  printcr
% printcr(name,outport,bond_number,cr,args,RHS_cause,eqnfile


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Find the number of inports
nports = length(inports);

% Set up LHS
LHS = varname(name, outbond, outcause);

% Set up various strings to get correct syntax if some strings are empty
if length(cr)==0
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

if length(args)==0
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
  RHS2 = sprintf('%s\t%s,%s,%1.0f', ...
      RHS2, varname(name, inbonds(i), incauses(i)), ...
      cause2name(incauses(i)), inports(i));
  if i<nports % Add a comma
    RHS2 = sprintf('%s,\n',RHS2);
  else
    RHS2 = sprintf('%s\n',RHS2);
  end;
end;
 
  

% Set up equation
eqn = sprintf('%s := %s%s\t%s;\n', LHS, RHS1, RHS2, rp);


