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
% %% Revision 1.4  1996/08/15 12:50:51  peter
% %% Put in a conj to undo effect of transpose.
% %%
% %% Revision 1.3  1996/08/15 11:53:44  peter
% %% Now has u0 input vector
% %%
% %% Revision 1.2  1996/08/15 10:24:28  peter
% %% Includes u0 argument.
% %%
% %% Revision 1.1  1996/08/10 14:11:28  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Ny,Nu] = size(D);
[Ny,Nx] = size(C);
N = length(W);

if nargin<7
  U0 = zeros(Nu,1);
  U0(1) = 1;
else
  for i=1:Nu
    U0(i) = u0(i);
  end;
end;

u0 = U0;

[n,m]=size(W);
if m>n
  W=W';
end;

[n,m]=size(u0);
if m>n
  u0=u0';
end;


fr = zeros(N,Ny);
i = 0;
for w = W'
  i = i+1;
  FR = C*( (E*j*w - A) \ B*u0 ) + D*u0
  fr(i,:) = conj(FR');
end;













