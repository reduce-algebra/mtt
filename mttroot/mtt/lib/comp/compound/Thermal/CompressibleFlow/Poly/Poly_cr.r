% Constitutive relation file for Poly (Poly_cr.r)
% Generated by MTT at Wed Mar 11 11:01:28 GMT 1998

OPERATOR Poly;

% Ideal gas

% Temperature output on port [T2]
FOR ALL COMPONENT,  alpha,P1,P2,T1,Nothing
LET Poly(COMPONENT, alpha,effort,4,
	P1,effort,1,
	P2,effort,2,
	T1,effort,3,
	Nothing,flow,4
	) = T1*(P2/P1)^alpha;



END;
