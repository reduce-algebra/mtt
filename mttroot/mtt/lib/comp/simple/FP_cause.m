function [bonds,status] = FP_cause(bonds);
% Causality for FP component

%SUMMARY FP: converts thermal pseudobond to true bond and vv
%DESCRIPTION Port [e]: temperature (T) / enthalpy flow (E) bond
%DESCRIPTION Port [s]: temperature (T) / entropy flow (S) bond



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
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



