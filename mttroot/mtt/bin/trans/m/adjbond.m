function [index,distance] = adjbond(point,arrow_end,other_end);
% adjbond:  Determines the bond closest to the point 
%  [index,distance] = adjbond(point,arrow_end,other_end);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[n,m] = size(other_end);
one = ones(n,1);
arrow_distance = length2d(one*point - arrow_end);
min_arrow_distance = min(arrow_distance);

other_distance = length2d(one*point - other_end);
min_other_distance = min(other_distance);

min_distance = min([arrow_distance; other_distance]);

adjacent = [arrow_distance, other_distance] == min_distance*[one one];
[index,n] = getindex(adjacent,1);
distance = min_distance;

