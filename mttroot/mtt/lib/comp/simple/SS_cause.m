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
%DESCRIPTION one-port source sensor component
%DESCRIPTION when the name is [i], acts as ith port of a system.
%DESCRIPTION may be bicausal

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  1996/11/01 12:18:38  peterg
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.

% Check that there is exactly one bonds.
if check_bonds(bonds,1,'SS')==0
  return
end

if (bonds(1)==0)|(bonds(2)==0) % Under causal
  status = -1;
else                          % causal
  status = 0;
end;





