function [Y,X] = sm2sr(A,B,C,D,T,u0,x0);
% sm2sr - Constrained-state matrix to step response.
%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  sm2sr
% [Y,X] = sm2sr(A,B,C,D,T,u0,x0);
% A,B,C,D,E - (constrained) state matrices
% T vector of time points
% u0 input gain vector: u = u0*unit step.

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.4  1996/12/05 10:18:52  peterg
% %% Saved (quite old) version which integrates IR to give SR
% %%
% %% Revision 1.3  1996/10/27  10:39:04  peterg
% %% Only compute matrix exponential once.
% %%
% %% Revision 1.2  1996/09/10  16:48:21  peter
% %% Changed ar counts in default settings.
% %%
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

dt = T(2)-T(1);% Assumes fixed interval
expAdt = expm(A*dt); % Compute matrix exponential
i = 0;
expAt = one;

for t = T'
  i=i+1;
  if Nx>0
    x = ( A\(expAt-one) )*B*u0 + expAt*x0;
    expAt = expAt*expAdt;
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

% $$$ % Compute the impulse response
% $$$ [Y,X] = sm2ir(A,B,C,D,T,u0,x0);
% $$$ 
% $$$ % Assume fixed sample interval
% $$$ dT = T(2)-T(1);
% $$$ 
% $$$ % Do an Euler integration on it
% $$$  Y = mtt_euler(Y,dT);
% $$$  
% $$$  if nargout>1
% $$$    X = mtt_euler(X,dT);
% $$$  end;
% $$$  



