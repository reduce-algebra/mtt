function [bonds,status] = juncause(bonds,jun,cause)
% [bonds,status] = juncause(bonds,jun,cause)

% Causality for  either effort or flow on  either zero or one junctions

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


j =  (3-cause)/2; % j is 1 for effort, 2 for flow

[n_bonds,junk] = size(bonds);
[causing_bond, n,other_bonds,m] = getindex(bonds(:,j),jun);
if n>1 % over causal
  status = 1;
elseif n==1 %causal
  status = 0;
  bonds(other_bonds(:,1),j) = -jun*ones(m,1);
else  % undercausal - try other way
  [causing_bond, n,other_bonds,m] = getindex(bonds(:,j),-jun);
  if n==n_bonds % over causal
    status = 1;
  elseif n==n_bonds-1 %causal
    status = 0;
    bonds(other_bonds(:,1),j) = jun*ones(m,1);
  else  % undercausal
    status = -1;
  end;
end;




