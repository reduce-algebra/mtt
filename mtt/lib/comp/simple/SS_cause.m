function [bonds,status] = SS_cause(bonds)
% SS_cause = causality for an SS component
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  SS_cause
% [bonds,status] = SS_cause(bonds)

%SUMMARY SS: source-sensor component
%DESCRIPTION multi-port source sensor component
%DESCRIPTION when the name is [name], acts as port `name' of a system.
%DESCRIPTION may be bicausal

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.2  1996/11/01 14:41:14  peterg
% %% Check correct bonds
% %%
% %% Revision 1.1  1996/11/01 12:18:38  peterg
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.

## Check that there is exactly one bonds.
##if check_bonds(bonds,1,'SS')==0
##  return
##end

disp("Starting SS_cause");

[n_bonds,junk] = size(bonds);
Status=zeros(n_bonds,1);
for i=1:n_bonds
  if (bonds(i,1)==0)|(bonds(i,2)==0) % Under causal
    Status(i) = -1;
  else                          % causal
    Status(i) = 0;
 end;
end;
status=min(Status);







