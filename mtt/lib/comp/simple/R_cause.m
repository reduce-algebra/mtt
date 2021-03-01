function [bonds,status] = R_cause(bonds);
% R_cause - Causality function for a (multi-port) unicausal R component
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  R_cause
% [bonds,status] = R_cause(bonds)

%SUMMARY R: R component
%DESCRIPTION Multiport component with no dynamics
%DESCRIPTION Cannot be bicausal

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  1996/08/30 19:05:08  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.
 

% Find the number of ports
[ports,junk] = size(bonds);

% default undercausal status
statuses = -ones(ports,1);

% Force unicausality
for i = 1:ports
  if (bonds(i,1)~=0)&(bonds(i,2)~=0) % Both bonds set
    statuses(i) = bonds(i,1)~=bonds(i,2);
  elseif bonds(i,2)~=0               % Bond 1 set
    bonds(i,1) = bonds(i,2);
    statuses(i) = 0;
  elseif bonds(i,1)~=0               % Bond 2 set
    bonds(i,2) = bonds(i,1);
    statuses(i) = 0;
  end;
end;

if max(statuses)==1
  status = 1;
elseif min(statuses)==-1
  status = -1;
else
  status = 0;
end;
  

