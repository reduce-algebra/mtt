function [bonds,status] = I_cause(bonds);
% I_cause  - Unicausal multiport C component
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  I_cause
% [bonds,status] = I_cause(bonds)

%SUMMARY I: elementary I component
%DESCRIPTION Single port dynamic component
%DESCRIPTION Preferred integral causality (effort input)
%DESCRIPTION Cannot be bicausal


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.

% Same causal pattern as R component
[bonds,status] = R_cause(bonds);


