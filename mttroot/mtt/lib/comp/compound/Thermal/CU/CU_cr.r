%SUMMARY CU    Constitutive Relationship for a two port thermo C
%DESCRIPTION Parameter 1: c_v (specific heat at constant volume)
%DESCRIPTION Parameter 2: gamma = c_p/c_v
%DESCRIPTION Parameter 3: mass of (ideal) gas within component.


%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  2000/12/28 10:34:56  peterg
% %% Put under RCS
% %%
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


OPERATOR CU;

%% Integral/Integral causality
Port 1 - Thermal
FOR ALL COMPONENT,  c_v,gamma,m,InternalEnergy,Volume
LET CU(COMPONENT, ideal_gas,c_v,gamma,m,effort,1,
	InternalEnergy, state, 1,
	Volume, state, 2)
         = InternalEnergy/(m*c_v);

Port 2 - Mechanical
FOR ALL COMPONENT,  c_v,gamma,m,InternalEnergy,Volume
LET CU(COMPONENT, ideal_gas,c_v,gamma,m,effort,2,
	InternalEnergy, state, 1,
	Volume, state, 2)
         = (gamma-1)*(InternalEnergy)/Volume;

%% Derivative/Integral causality
Port 1 - Thermal
FOR ALL COMPONENT,  c_v,gamma,m,Temperature,Volume
LET CU(COMPONENT, ideal_gas,c_v,gamma,m,state,1,
	Temperature, effort, 1,
	Volume, state, 2)
         = Temperature*(m*c_v);

Port 2 - Mechanical
FOR ALL COMPONENT,  c_v,gamma,m,Temperature,Volume
LET CU(COMPONENT, ideal_gas,c_v,gamma,m,effort,2,
	Temperature, effort, 1,
	Volume, state, 2)
         = (gamma-1)*(m*c_v)*(Temperature)/Volume;

%% Integral/Derivative causality
Port 1 - Thermal
FOR ALL COMPONENT,  c_v,gamma,m,InternalEnergy,Pressure
LET CU(COMPONENT, ideal_gas,c_v,gamma,m,effort,1,
	InternalEnergy, state, 1,
	Pressure, effort, 2)
         = InternalEnergy/(m*c_v);

Port 2 - Mechanical
FOR ALL COMPONENT,  c_v,gamma,m,InternalEnergy,Pressure
LET CU(COMPONENT, ideal_gas,c_v,gamma,m,state,2,
	InternalEnergy, state, 1,
	Pressure, effort, 2)
         = (gamma-1)*(InternalEnergy)/Pressure;


END;
