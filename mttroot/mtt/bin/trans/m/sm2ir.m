function [Y,X] = sm2ir(A,B,C,D,T,u0,x0);
% [Y,X] = sm2ir(A,B,C,D,T,u0,x0);
% Constrained-state matrix to impulse response.
% A,B,C,D,E - (constrained) state matrices
% T vector of time points
% u0 input gain vector: u = u0*unit step.


[Ny,Nu] = size(D);
[Ny,Nx] = size(C);

if max(max(abs(D)))~=0
  mtt_info('D matrix non-zero - ignoring');
end;

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
    x = expAt*(B*u0+x0);
    X(i,:) = x';
    if Ny>0
      y = C*x;
      Y(i,:) = y';
    end;
  end;
end;






