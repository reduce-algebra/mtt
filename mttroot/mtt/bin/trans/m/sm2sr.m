function [Y,X] = sm2sr(A,B,C,D,T,u0,x0);
% [Y,X] = sm2sr(A,B,C,D,T,u0,x0);
% Constrained-state matrix to impulse response.
% A,B,C,D,E - (constrained) state matrices
% T vector of time points
% u0 input gain vector: u = u0*unit step.

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  1996/08/19 15:34:29  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[Ny,Nu] = size(D);
[Ny,Nx] = size(C);

if nargin<6
  u0 = zeros(Nu,1);
  u0(1) = 1;
end;

if nargin<7
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






