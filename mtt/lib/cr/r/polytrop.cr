%SUMMARY polytrop	CR for gas turbine compressor


OPERATOR polytrop;

% Port 1 generates zero flow
FOR ALL Ipressure,temperature,Fpressure,gamma,enthflow
LET polytrop(gamma, flow, 1,
		Fpressure,effort,1,
		enthflow,flow,2,
		temperature,effort,3,
		Ipressure,effort,4)
	 = 0;

% Port 2 generates deltaT
FOR ALL Ipressure,temperature,Fpressure,gamma,enthflow
LET polytrop(gamma, effort, 2,
		Fpressure,effort,1,
		enthflow,flow,2,
		temperature,effort,3,
		Ipressure,effort,4)
	 = temperature*((Ipressure/Fpressure)^(gamma)-1);

% Port 3 generates zero flow
FOR ALL Ipressure,temperature,Fpressure,gamma,enthflow
LET polytrop(gamma, flow, 3,
		Fpressure,effort,1,
		enthflow,flow,2,
		temperature,effort,3,
		Ipressure,effort,4)
	 = 0;

% Port 4 generates zero flow
FOR ALL Ipressure,temperature,Fpressure,gamma,enthflow
LET polytrop(gamma, flow, 4,
		Fpressure,effort,1,
		enthflow,flow,2,
		temperature,effort,3,
		Ipressure,effort,4)
	 = 0;

