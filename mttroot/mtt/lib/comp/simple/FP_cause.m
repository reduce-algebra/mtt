function [bonds,status] = FP_cause(bonds);
% Causality for FP component

%SUMMARY FP: converts true bond to a pseudo bond with power flow as flow
%DESCRIPTION Port [f]: True bond with a flow covariable
%DESCRIPTION Port [p]: Pseudo bond with power (ef) as flow variable



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.2  1998/06/29 09:56:24  peterg
% %% Changed name to FP from ES
% %%
% %% Revision 1.1  1998/06/29 09:56:02  peterg
% %% Initial revision
% %%
% %% Revision 1.1  1997/09/04  08:34:53  peterg
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1997.

status = -1;

% Check that there are exactly two bonds.
if check_bonds(bonds,2,'FP')==0
  return
end

% Same causality as TF
[bonds,status] = TF_cause(bonds);



