function sr = dm2sr(A,B,C,D,E,T,u0,x0);
% sr = dm2sr(A,B,C,D,E,T);
% Descriptor matrix to impulse response.
% NB At the moment - this assumes that E is unity .....
% A,B,C,D,E - descriptor matrices
% T vector of time points

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.3  1996/08/11 19:33:24  peter
% %% Replaced exp by expm - whoops!
% %%
% %% Revision 1.2  1996/08/11 10:37:40  peter
% %% Corrected mistake in step-response calculation.
% %%
% %% Revision 1.1  1996/08/11 09:42:40  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Ny,Nu] = size(D);
[Ny,Nx] = size(C);

if nargin<7
  u0 = zeros(Nu,1);
  u0(1) = 1;
end;

if nargin<8
  x0 = zeros(Nx,1);
end;

[N,M] = size(T);
if M>N
  T = T';
  N = M;
end;

one = eye(Nx);

sr = zeros(N,Ny);
i = 0;
for t = T'
  i=i+1;
  expAt = expm(A*t);
  SR = C*( ( A\(expAt-one) )*B*u0 + expAt*x0) + D*u0;
  sr(i,:) =SR';
end;

