%SUMMARY sat_tank Saturation nonlinearity with variable slopes for tank
%DESCRIPTION Parameter 1 is the slope of the "normal" linear part of the CR
%DESCRIPTION Parameter 2 is the "large" slope
%DESCRIPTION Parameter 3 is the lower bound of the state
%DESCRIPTION Parameter 4 is the upper bound of the state


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

OPERATOR sign0;
FOR ALL x
	LET sign0(x) = (sign(x)+1)/2;

OPERATOR sat_tank; 
%Output has effort causality, input is state
FOR ALL k_0, k_1, x_0, x_1, x
LET sat_tank(k_0, k_1, x_0, x_1, effort, 1,
         x, state, 1)
	 = x*k_0 + (x-x_1)*(k_1-k_0)*sign0(x-x_1) + (x-x_0)*(k_1-k_0)*sign0(x_0-x);


