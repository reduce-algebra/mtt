function name = cr2name(RHS_number,LHS_cause,RHS_cause,cr,args);
cr2name. Construcs a string for the cr of a component.

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
end;

name = sprintf('%s%s%s%s%s%s%s%s', ...
    cr,lp, args, a_comma, cause_name, c_comma, ...
    varname(RHS_number,RHS_cause),rp);
    
    





