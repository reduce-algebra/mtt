function [bonds,status] = C_cause(bonds);
% C_cause - Unicausal multiport C component
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  C_cause
% [bonds,status] = C_cause(bonds)

%SUMMARY C: elementary C component
%DESCRIPTION Single port dynamic component
%DESCRIPTION Preferred integral causality (flow input)
%DESCRIPTION Cannot be bicausal



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  1996/11/01 12:35:36  peterg
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.

% Unicausal multiport C component
% Same causal pattern as R component

% [bonds,status] = R_cause(bonds);

% Set causality to preferred if not already set.
% Find the number of ports
[ports,junk] = size(bonds);

% default undercausal status
statuses = -ones(ports,1);

% Force unicausality but DONT set if not already set
preferred = -1;
for i = 1:ports
  if (bonds(i,1)~=0)&(bonds(i,2)~=0) % Both bonds set
    statuses(i) = bonds(i,1)~=bonds(i,2);
  elseif bonds(i,2)~=0               % Bond 1 set
    bonds(i,1) = bonds(i,2);
    statuses(i) = 0;
  elseif bonds(i,1)~=0               % Bond 2 set
    bonds(i,2) = bonds(i,1);
    statuses(i) = 0;
  else				# Don't set
#    bonds(i,1) = preferred;
#    bonds(i,2) = preferred;
#    statuses(i) = 0;
  end;
end;

if max(statuses)==1
  status = 1;
elseif min(statuses)==-1
  status = -1;
else
  status = 0;
end;


