function  oneeqn(name,LHS_number,LHS_cause,RHS_number,RHS_cause,cr,args, ...
    eqnfile);
% oneeqn - prints a single equation
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  oneeqn
% oneeqn(name,LHS_number,LHS_cause,RHS_number,RHS_cause,cr,args,eqnfile)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if nargin<7
  eqnfile = 'stdout';
end;


fprintf(eqnfile, '%s := %s;\n', ...
    varname(name, LHS_number,LHS_cause), ...
    cr2name(name,RHS_number,LHS_cause,RHS_cause,cr,args));
