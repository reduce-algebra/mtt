function [Y,X] = sm2ir(A,B,C,D,T,u0,x0);
% sm2ir - state matrix to impulse response.
%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  sm2ir
% [Y,X] = sm2ir(A,B,C,D,T,u0,x0);
% A,B,C,D,E - (constrained) state matrices
% T vector of time points
% u0 input gain vector: u = u0*unit impulse.


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.3  1996/12/05 10:17:34  peterg
% %% Put in version control history.
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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

dt = T(2)-T(1);% Assumes fixed interval
##expAdt = expm(A*dt); % Compute matrix exponential
##expAt = one;
i = 0;
x = (B*u0+x0);
for t = T'
  i=i+1;
  if Nx>0
    ##expAt = expm(A*t);
    ##x = expAdt*x;
     x = expm(A*t)*(B*u0+x0);
    X(i,:) = x';
    if Ny>0
      y = C*x;
      Y(i,:) = y';
    end;
  end;
end;






