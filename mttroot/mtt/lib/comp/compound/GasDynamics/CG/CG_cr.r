%SUMMARY CG	CR two-port C thermal pseudo Bond Graph for gas dynamics


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % $Id$
% % $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



OPERATOR CG;

% Port 1 : temperature
FOR ALL c_v,r,Enthalpy,Stored_Mass,Volume
LET CG(c_v,r, effort, 1,
		Enthalpy,state,1,
		Stored_Mass,state,2,
		Volume,state,3)
	 = Enthalpy/(c_v*Stored_Mass);

% Port 2 : Pressure
FOR ALL c_v,r,Enthalpy,Stored_Mass,Volume
LET CG(c_v,r, effort, 2,
		Enthalpy,state,1,
		Stored_Mass,state,2,
		Volume,state,3)
	 = (R/c_v)*(Enthalpy/Volume);

% Port 3 : (Also) Pressure
FOR ALL c_v,r,Enthalpy,Stored_Mass,Volume
LET CG(c_v,r, effort, 3,
		Enthalpy,state,1,
		Stored_Mass,state,2,
		Volume,state,3)
	 = (R/c_v)*(Enthalpy/Volume);

END;;

