function [bonds,status] = cicause(bonds,default);
% cicause - Sets causality for C & I components
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  cicause
% [bonds,status] = cicause(bonds,default)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.



if (norm(bonds)>1)
  if (bonds(1)==-bonds(2)) % Over causal
    status = 1;
  else                       % Causal
    status = 0;
  end;
elseif norm(bonds)==0 % Acausal
  % bonds = default*[1 1]; %Set integral causality
  % status = 0;
  status = -1;
else % Set causality 
  % Effort
  if bonds(1)==0
    status = 0;
    bonds(1) = bonds(2);
  end;

  % Flow
  if bonds(2)==0
    status = 0;
    bonds(2) = bonds(1);
  end;

end;
