%SUMMARY cm: relation for 2-port CM component
%DESCRIPTION Parameter 1 capacitance at separation x_0
%DESCRIPTION Parameter 2 x_0
%DESCRIPTION parameter 3 moving-plate mass

%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


OPERATOR cm;
%Linear electrical bit
FOR ALL c_0,x_0,elec_state,mech_state LET
cm(c_0,x_0,effort,1,
	elec_state,state,1,
	mech_state,state,2
	)
	= elec_state/(c_0*x_0/mech_state);

%Nonlinear mechanical bit
FOR ALL c_0,x_0,elec_state,mech_state LET
cm(c_0,x_0,effort,2,
	elec_state,state,1,
	mech_state,state,2
	)
	= -(c_0*x_0)*((elec_state/mech_state)^2)/2; 

END;;
