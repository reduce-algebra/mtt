%%% Sensitivity RS component CR
in "lin.cr";
in "slin.cr";

%% Sensitivity entropy flow
FOR ALL e_r,f_r,de_r,df_r,Temp,dTemp LET
sRS(flow,6,
	e_r,effort,1,
	f_r,flow,2,
	de_r,effort,3,
	df_r,flow,4,
	Temp,effort,5,
	dTemp,effort,6
	) = ((e_r*df_r + de_r*f_r)*Temp - e_r*f_r*dTemp)/(Temp^2);


END;
