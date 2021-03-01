function [bonds,status] = zero_cause(bonds);
% zero_cause - causality for zero junctions
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  zero_cause
% [bonds,status] = zero_cause(bonds);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Effort
[bonds,e_status] = juncause(bonds,1,1);

%Flow
[bonds,f_status] = juncause(bonds,1,-1);

status = 0;
if (e_status==1)|(f_status==1)       % Over causal
  status = 1;
endif;
if (e_status==-1)|(f_status==-1) % Under causal
  status = -1;
endif;

  
