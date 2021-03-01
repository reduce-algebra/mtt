function ok = check_bonds(bonds,n,component);
% check_bonds - check to see correct number (n) of bonds.
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  check_bonds
% err = check_bonds(bonds,n);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.
% Check that there are exactly two bonds.
[n_bonds,cols] = size(bonds);
if n_bonds~=n
  mtt_info(sprintf('MTT error: %s must have %1.0f (not %1.0f) bonds', ...
      component, n, n_bonds));
  ok=0;
else
  ok=1;
end
