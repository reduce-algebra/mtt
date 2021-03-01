%SUMMARY CT2    Constitutive Relationship for a two port thermo C
%DESCRIPTION Parameter 1: c_v (specific heat at constant volume)
%DESCRIPTION Parameter 2: gamma = c_p/c_v
%DESCRIPTION Parameter 3: mass of (ideal) gas within component.
%DESCRIPTION Parameter 4: t_0 -- the temperature at which internal
%DESCRIPTION energy is zero.

%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  1997/12/07 20:45:21  peterg
% %% Initial revision
% %%
% %% Revision 1.1  1996/11/02  10:21:19  peterg
% %% Initial revision
% %%
% %% Revision 1.1  1996/09/12 11:18:26  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


OPERATOR CT2;
Port 1 - Thermal
FOR ALL c_v,gamma,m,t_0,InternalEnergy,Volume
LET CT2(c_v,gamma,m,t_0,effort,1,
	InternalEnergy, state, 1,
	Volume, state, 2)
         = InternalEnergy/(m*c_v);

Port 2 - Mechanical
FOR ALL c_v,gamma,m,t_0,InternalEnergy,Volume
LET CT2(c_v,gamma,m,t_0,effort,2,
	InternalEnergy, state, 1,
	Volume, state, 2)
         = (gamma-1)*(InternalEnergy+c_v*m*t_0)/Volume;

END;
