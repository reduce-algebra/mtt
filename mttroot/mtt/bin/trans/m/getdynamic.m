function [index,prefered] = getdynamic(status,system_type);
% Get the index of a dynamic components which is not set.

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  1996/08/16 12:50:41  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

index=0; prefered=0;
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
