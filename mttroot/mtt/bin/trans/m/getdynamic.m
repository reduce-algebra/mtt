function [index,prefered] = getdynamic(status,system_type);
% Get the index of a dynamic components which is not set.

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


index=0; prefered=0;
s = status'
n_components = length(status);

for i = 1:n_components
  if status(i)==-1 % Undercausal
    eval([ '[comp_type,name,cr,arg] = ', system_type, '_cmp(i);' ]); 
    if strcmp(comp_type,'C')
      index=i;
      prefered=-1;
      break;
    end;
    if strcmp(comp_type,'I')
      index=i;
      prefered=1;
      break;
    end;
  end;
end;
index