function [bonds,status] = C2_cause(bonds);
% C2_cause - Unicausal multiport C2 C2omponent
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  C2_cause
% [bonds,status] = C2_cause(bonds)

%SUMMARY C2: elementary C component with two ports
%DESCRIPTION Two port dynamic component
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


