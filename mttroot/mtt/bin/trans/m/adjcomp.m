function indices = adjcomp(arrow_end,other_end,components);
% adjcomp: Determines the two components at each end of the bond



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[n,m] = size(components);
one = ones(n,1);

arrow_distance = length2d(one*arrow_end - components(:,1:2));
min_arrow_distance = min(arrow_distance);

other_distance = length2d(one*other_end - components(:,1:2));
min_other_distance = min(other_distance);

arrow_adjacent = arrow_distance==min_arrow_distance*one;
other_adjacent = other_distance==min_other_distance*one;
[index,n] = getindex([arrow_adjacent,other_adjacent],1);

if index(1,2)==1
  indices = index(1:2,1)';
else
  indices = index(2:-1:1,1)';
end;


