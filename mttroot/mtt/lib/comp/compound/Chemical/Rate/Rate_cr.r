%% CR file for rate-of reaction component RATE

OPERATOR Rate;

% Reaction rate
FOR ALL comp,k,q,h,n,Conc,Temp LET
    Rate(comp,k,q,h,n,flow,1,
         Conc,effort,1,
	 Temp,effort,2
	 ) 
	 = k*Conc^n*e^(-q/Temp);

% Heat
FOR ALL comp,k,q,h,n,Conc,Temp LET
    Rate(comp,k,q,h,n,flow,2,
         Conc,effort,1,
	 Temp,effort,2
	 ) 
	 = k*Conc^n*h*e^(-q/Temp);

END;
