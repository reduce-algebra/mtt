function  fr = dm2fr(A,B,C,D,E,W,u0)
% fr = dm2fr(A,B,C,D,E,W,u0)
% Descriptor matrix to frequency response.
% A,B,C,D,E - descriptor matrices
% W vector of frequency points
% u0 input gain vector: u = u0*unit phasor

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  1996/08/10 14:11:28  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Ny,Nu] = size(D);
[Ny,Nx] = size(C);
N = length(W);

if nargin<7
  u0 = zeros(Nu,1);
  u0(1) = 1;
end;

fr = zeros(N,Ny);
i = 0;
for w = W
  i = i+1;
  FR = C*( (E*j*w - A) \ B ) + D;
  fr(i,:) = FR';
end;









