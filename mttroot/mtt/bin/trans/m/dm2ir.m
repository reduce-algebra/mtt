function [t,ir] = dm2ir(A,B,C,D,E,tmax,tstep);

% Descriptor matrix to impulse response.
% NB At the moment - this assumes that E is unity .....

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


t=[0:tstep:tmax]';
ir = C*exp(A*t)*B;
