%% CR for conical tank example - sensitivity

in "conical.cr";

OPERATOR sconical;
%% The actual port (1) 
FOR ALL COMP, rho,g,V_0,V_0s,V,sV LET
    sconical(COMP, rho,g,V_0,V_0s,effort,1,
               V,state,1,
               sV,state,2)
    = conical(COMP, rho,g,V_0,effort,1,V,state,1);

%% The sensitivity port (2) 
FOR ALL COMP, rho,g,V_0,V_0s,V,sV LET
    sconical(COMP, rho,g,V_0,V_0s,effort,2,
               V,state,1,
               sV,state,2)
    = df(conical(COMP, rho,g,V_0,effort,1,V,state,1),V) * sV
    + df(conical(COMP, rho,g,V_0,effort,1,V,state,1),V_0)* V_0s;

END;;
