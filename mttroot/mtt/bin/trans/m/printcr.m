function  printcr(name,outport,bond_number,cr,args,RHS_cause,eqnfile)
% printcr - prints cr and arguments
% Assumes that the (multiport) component is unicausal.
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



if nargin<7
  eqnfile = 'stdout';
end;

% Find the number of ports
ports = length(RHS_cause);

% Print the CR
if length(cr) == 0 % No CR given - use unity CR
  fprintf(eqnfile, '%s;\n', varname(name,bond_number(outport), RHS_cause(outport)));
else % CR exists
  fprintf(eqnfile, '%s(', cr); % The CR name
  if ports>1 % Multi ports - port no. is first arg of CR
    fprintf(eqnfile, '%1.0f,', outport);
  end;
  fprintf(eqnfile, '%s', args); % Print the arguments
  for port = 1:ports % Print the input causalities and values
    fprintf(eqnfile, '\n\t\t,%s,%s', cause2name(RHS_cause(port)), ...
    varname(name,bond_number(port), RHS_cause(port)));
  end;
fprintf(eqnfile, '\n\t\t);\n');    
end;

