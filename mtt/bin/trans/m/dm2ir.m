function ir = dm2ir(A,B,C,D,E,T);
% ir = dm2ir(A,B,C,D,E,T);
% Descriptor matrix to impulse response.
% NB At the moment - this assumes that E is unity .....
% A,B,C,D,E - descriptor matrices
% T vector of time points

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.3  1996/08/10 14:16:04  peter
% %% Now has T vector input - it was tmax & tstep
% %%
% %% Revision 1.2  1996/08/10 11:49:39  peter
% %% Fixed multi-input/output problem
% %%
% %% Revision 1.1  1996/08/10 10:26:00  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[N,M] = size(T);
if M>N
  T = T';
  N = M;
end;

[Ny,Nu] = size(D);
NN=Ny*Nu;

ir = zeros(N,NN);
i = 0;
for t = T'
  i=i+1;
  ir(i,:) = reshape(C*expm(A*t)*B, 1,NN);
end;

