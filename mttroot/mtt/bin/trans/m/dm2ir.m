function [T,ir] = dm2ir(A,B,C,D,E,tmax,tstep);

% Descriptor matrix to impulse response.
% NB At the moment - this assumes that E is unity .....

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  1996/08/10 10:26:00  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


T=[0:tstep:tmax]';
N = length(T);
[Ny,Nu] = size(D);
NN=Ny*Nu;

ir = zeros(N,NN);
i = 0;
for t = T'
  i=i+1;
  ir(i,:) = reshape(C*exp(A*t)*B, 1,NN);
end;

