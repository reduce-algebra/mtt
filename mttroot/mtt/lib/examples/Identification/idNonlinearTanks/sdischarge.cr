%% CR file for the sR component. - 2 port.
%% Special version just for this example.

%% CR for non-linear pipe discharge
%% Just do for flow input causality.

in "discharge.cr";

PROCEDURE l_discharge(alpha,beta,P);
BEGIN
  result := sub({x=P},df(discharge(alpha,beta,flow,1,x,effort,1), x));
  return result;
END;

OPERATOR sdischarge;
%% The actual port (1) -- Pressure input
FOR ALL alpha,beta,alpha_s,beta_s,P,sP LET
    sdischarge(alpha,beta,alpha_s,beta_s,flow,1,
               P,effort,1,
               sP,effort,2)
    = discharge(alpha,beta,flow,1,P,effort,1);

%% The sensitivity port (2) -- Pressure input
FOR ALL alpha,beta,alpha_s,beta_s,P,sP LET
    sdischarge(alpha,beta,alpha_s,beta_s,flow,2,
               P,effort,1,
               sP,effort,2)
    =  l_discharge(alpha,beta,P) * sP
    + df(discharge(alpha,beta,flow,1,P,effort,1), alpha)* alpha_s
    + df(discharge(alpha,beta,flow,1,P,effort,1), beta) * beta_s;
END;;
