function [bonds,status] = EBTF_cause(bonds);
% EBTF_cause - causality for a EBTF component
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  EBTF_cause
% [bonds,status] = EBTF_cause(bonds)

%SUMMARY EBTF: transformer component - bicausal on effort
%DESCRIPTION Energy conserving two-port
%DESCRIPTION e_1 f_1 = e_2 f_2 and e_1 and e_2 are both imposed.


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % $Id$
% % $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% Copyright (c) P.J. Gawthrop, 1998.

% Check that there are exactly two bonds.
if check_bonds(bonds,2,'EBTF')==0
  return
end

% Effort must be imposed by both bonds
if (bonds(1,1)==-1)|(bonds(2,1)==-1) % Overcausal
  status = 1;
  return
end;

bonds(1,1) = 1; 
bonds(2,1) = 1;

% Flow bond must have through causality
if (bonds(1,2)==0)&(bonds(2,2)==0) % Undercausal
  status = -1;
  return
end;

if (bonds(1,2)==bonds(2,2))&(bonds(1,2)!=0) % Overcausal
  status = 1;
  return
end;

%Set flow causality
if (bonds(1,2)!=0)
  bonds(2,2) = -bonds(1,2)
else
  bonds(1,2) = -bonds(2,2)
end;
  
status = 0;







