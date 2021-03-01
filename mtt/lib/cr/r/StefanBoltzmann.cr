%SUMMARY StefanBoltzmann: Stefan-Boltzmann radiation law.	
%DESCRIPTION Parameter 1: Stefan-Boltzmann constant
%DESCRIPTION Parameter 2: Area of radiating surface



OPERATOR StefanBoltzmann;


FOR ALL sigma,Area,input
LET StefanBoltzmann(sigma,Area,flow, 1, 
	input, effort, 1)
	 = sigma*area*input^4;


