function [Y,X] = dm2sr(A,B,C,D,E,T,u0,x0);
% [Y,X] = dm2sr(A,B,C,D,E,T,u0,x0);
% Descriptor matrix to impulse response.
% NB At the moment - this assumes that E is unity .....
% A,B,C,D,E - descriptor matrices
% T vector of time points
% u0 input gain vector: u = u0*unit step.

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.4  1996/08/15 08:34:08  peter
% %% Added step gain (u0) and initial condition (x0)
% %%
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

Y = zeros(N,Ny);
X = zeros(N,Nx);
i = 0;
for t = T'
  i=i+1;
  if Nx>0
    expAt = expm(A*t);
    x = ( A\(expAt-one) )*B*u0 + expAt*x0;
    X(i,:) = x';
    if Ny>0
      y = C*x + D*u0;
      Y(i,:) = y';
    end;
  elseif Ny>0
    y = D*u0;
    Y(i,:) = y';
  end;
end;

