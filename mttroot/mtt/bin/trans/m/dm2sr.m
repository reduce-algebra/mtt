function sr = dm2sr(A,B,C,D,E,T);
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
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[N,M] = size(T);
if M>N
  T = T';
  N = M;
end;

[Ny,Nu] = size(D);
NN=Ny*Nu;

[N_y,N_x] = size(C);
one = eye(N_x);

sr = zeros(N,NN);
i = 0;
for t = T'
  i=i+1;
  sr(i,:) = reshape(C*(1-exp(A*t))*B + D*ones(size(t)), 1,NN);
end;

