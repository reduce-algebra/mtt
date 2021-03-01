function [bonds,status] = TF_cause(bonds);
% TF_cause - causality for a TF component
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  TF_cause
% [bonds,status] = TF_cause(bonds)

%SUMMARY TF: elementary transformer component
%DESCRIPTION Energy conserving two-port
%DESCRIPTION e_1 = f(e_2); f_1 = f(f_2)


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  1996/11/01 12:05:54  peterg
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.

% Check that there are exactly two bonds.
if check_bonds(bonds,2,'TF')==0
  return
end


%Causality of TF is same as that of a junction
[bonds,status] = zero_cause(bonds);
