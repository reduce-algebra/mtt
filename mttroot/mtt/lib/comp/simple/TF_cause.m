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
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.

%Causality of TF is same as that of a junction
[bonds,status] = zero_cause(bonds);
