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
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.

% Unicausal multiport C component
% Same causal pattern as R component

[bonds,status] = R_cause(bonds);


