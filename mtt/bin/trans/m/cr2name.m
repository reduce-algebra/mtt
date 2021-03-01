function crname = cr2name(name,RHS_number,LHS_cause,RHS_cause,cr,args,port);
% cr2name - Constructs a string for the cr of a component.
% % 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  cr2name
% cr2name(name,RHS_number,LHS_cause,RHS_cause,cr,args);

% Copyright (c) P.J. Gawthrop, 1996.


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.2  1996/08/22  18:31:06  peter
% %% Fixed comment bug.
% %%
% %% Revision 1.1  1996/08/22 13:14:39  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<7
  port=0
end;


if length(args)==0
  a_comma = '';
else
  a_comma = ',';
end;

if length(cr)==0
  cause_name = '';
  lp = '';
  rp = '';
  c_comma = '';
else
  cause_name = cause2name(LHS_cause);
  lp = '(';
  rp = ')';
  c_comma = ',';
end

if port == 0
  port_name = '';
  p_comma = '';
else
  port_name = sprintf('%1.0f',port);
  p_comma = ',';
end;

crname = sprintf('%s%s%s%s%s%s%s%s%s\t%s', ...
    cr,lp, args, a_comma, port_name, p_comma, cause_name, c_comma, ...
    varname(name, RHS_number,RHS_cause),rp);
    
    





