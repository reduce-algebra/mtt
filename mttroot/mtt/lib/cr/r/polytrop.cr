%SUMMARY polytrop	CR for gas turbine compressor


OPERATOR polytrop;

% Port 1 generates zero flow
FOR ALL deltaP,temperature,pressure,k,deltaT
LET polytrop(k, flow, 1,
		deltaP,effort,1,
		deltaT,effort,2,
		temperature,effort,3,
		pressure,effort,4)
	 = 0;

% Port 2 generates deltaT
FOR ALL deltaP,temperature,pressure,k,deltaT
LET polytrop(k, effort, 2,
		deltaP,effort,1,
		deltaT,effort,2,
		temperature,effort,3,
		pressure,effort,4)
	 = temperature*((1-(deltaP/pressure)^((k-1)/k)-1);

% Port 3 generates zero flow
FOR ALL deltaP,temperature,pressure,k,deltaT
LET polytrop(k, flow, 3,
		deltaP,effort,1,
		deltaT,effort,2,
		temperature,effort,3,
		pressure,effort,4)
	 = 0;

% Port 4 generates zero flow
FOR ALL deltaP,temperature,pressure,k,deltaT
LET polytrop(k, flow, 4,
		deltaP,effort,1,
		deltaT,effort,2,
		temperature,effort,3,
		pressure,effort,4)
	 = 0;


