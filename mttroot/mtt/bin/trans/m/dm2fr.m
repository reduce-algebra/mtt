function  fr = dm2fr(A,B,C,D,E,W)
% fr = dm2fr(A,B,C,D,E,W)
% Descriptor matrix to frequency response.
% A,B,C,D,E - descriptor matrices
% W vector of frequency points


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = length(W);
[Ny,Nu] = size(D);
NN=Ny*Nu;

fr = zeros(N,NN);
i = 0;
for w = W
  i = i+1;
  FR = C*( (E*j*w - A) \ B ) + D;
  fr(i,:) = reshape(FR,1,NN);
end;

