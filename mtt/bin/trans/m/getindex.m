function [index, n, otherindex, m] = getindex(array,value);
% Finds the n indices of the elements of array equal to value
% otherindex contains indeces of the the m other  elements.


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[N,M] = size(array);
n=0; m=0;
for i=1:N
  for j = 1:M
    if array(i,j)==value
      n=n+1;
      index(n,:) = [i j];
    else
      m=m+1;
      otherindex(m,:) = [i j];
    end;
  end;
end;


if (M==1)&(n>0)
  index = index(:,1);
end;

if (M==1)&(m>0)
  otherindex = otherindex(:,1);
end;

% Octave doesn't like empty matrices
if n==0
  index=0;
end;

if m==0
  otherindex=0;
end;



