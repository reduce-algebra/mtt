% Constitutive relation file for Tankp (Tankp_cr.r)
% Generated by MTT at Thu Mar  5 10:30:23 GMT 1998

OPERATOR Tankp; 
%%%% Incompressible %%%%
%Temperature
FOR ALL c_p,c,StoredMass,StoredEnthalpy
LET Tankp(incompressible,c_p,c,effort,1,
	StoredEnthalpy,state,1,
	StoredMass,state,2
	) = StoredEnthalpy/(StoredMass*c_p);

%Pressure
FOR ALL c_p,c,StoredMass,StoredEnthalpy
LET Tankp(incompressible,c_p,c,effort,2,
	StoredEnthalpy,state,1,
	StoredMass,state,2
	) = StoredMass/c;

%%%% Ideal gas %%%%
%Temperature
FOR ALL R,c_p,Volume,StoredMass,StoredEnthalpy
LET Tankp(ideal_gas,R,c_p,Volume,effort,1,
	StoredEnthalpy,state,1,
	StoredMass,state,2
	) = (StoredEnthalpy/(c_p*StoredMass));

%Pressure
FOR ALL R,c_p,Volume,StoredMass,StoredEnthalpy
LET Tankp(ideal_gas,R,c_p,Volume,effort,2,
	StoredEnthalpy,state,1,
	StoredMass,state,2
	) = R*( ( (StoredEnthalpy/(c_p*StoredMass)))/(Volume/StoredMass) );

END;