%SUMMARY CG	CR two-port C thermal pseudo Bond Graph for gas dynamics


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % $Id$
% % $Log$
% % Revision 1.1  1998/03/04 15:38:16  peterg
% % Initial revision
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



OPERATOR CG;

% Port 1 : temperature
FOR ALL COMP, c_v,r,Enthalpy,Stored_Mass,Volume
LET CG(COMP, c_v,r, effort, 1,
		Enthalpy,state,1,
		Stored_Mass,state,2,
		Volume,state,3)
	 = Enthalpy/(c_v*Stored_Mass);

% Port 2 : Pressure
FOR ALL COMP, c_v,r,Enthalpy,Stored_Mass,Volume
LET CG(COMP, c_v,r, effort, 2,
		Enthalpy,state,1,
		Stored_Mass,state,2,
		Volume,state,3)
	 = (R/c_v)*(Enthalpy/Volume);

% Port 3 : (Also) Pressure
FOR ALL COMP, c_v,r,Enthalpy,Stored_Mass,Volume
LET CG(COMP, c_v,r, effort, 3,
		Enthalpy,state,1,
		Stored_Mass,state,2,
		Volume,state,3)
	 = (R/c_v)*(Enthalpy/Volume);

END;;

