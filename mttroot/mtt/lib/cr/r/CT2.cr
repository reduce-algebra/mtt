%SUMMARY CT2    Constitutive Relationship for a two port thermo C
%DESCRIPTION Parameter 1 defines input causality relating to parameter 2
%DESCRIPTION value is effort, flow or state
%DESCRIPTION Parameter 2 is the gain corresponding to the causality of
%DESCRIPTION parameter 1.
%DESCRIPTION Supported components:

%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linear constitutive relationship.

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
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

