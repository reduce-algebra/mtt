%SUMMARY delta_h	CR for gas turbine compressor


OPERATOR delta_h;

% Port 1 - generates delta h
FOR ALL c_p,Temperature,Massflow,DeltaT
LET delta_h(c_p, flow, 1,
		Temperature,effort,1,
		Massflow,flow,2,
		DeltaT,effort,3)
	 = Massflow*c_p*DeltaT;

% Port 2 - generates zero effort
FOR ALL c_p,Temperature,Massflow,DeltaT
LET delta_h(c_p, effort, 2,
		Temperature,effort,1,
		Massflow,flow,2,
		DeltaT,effort,3)
	 = 0;

% Port 3 - generates zero effort
FOR ALL c_p,Temperature,Massflow,DeltaT
LET delta_h(c_p, flow,3,
		Temperature,effort,1,
		Massflow,flow,2,
		DeltaT,effort,3)
	 = 0;



