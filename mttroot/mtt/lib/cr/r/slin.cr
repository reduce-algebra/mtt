%DESCRIPTION Sensitivity version of lin

% One port version for historical reasons
OPERATOR slin;
FOR ALL gain_causality, gain, causality, input, other_causality
LET slin(gain_causality, gain, other_causality, 1, input, causality, 1)
         = lin(gain_causality, gain, other_causality, 1, input,
	 causality, 1);

% Two port version for sC,sI,sR 

% Port 1 - standard 
FOR ALL gain_causality, gain, sgain, causality, input, sinput, other_causality
LET slin(gain_causality, gain, sgain, other_causality, 1, 
       input, causality, 1,
       sinput, causality, 2)
         = lin(gain_causality, gain, other_causality, 1, 
               input, causality, 1); 


% Port 2 - sensitivity
FOR ALL gain_causality, gain, sgain, causality, input, sinput, other_causality
LET slin(gain_causality, gain, sgain, other_causality, 2, 
       input, causality, 1,
       sinput, causality, 2)
         = lin(gain_causality, gain, other_causality, 1, 
               sinput, causality, 1)
         + sgain*df(lin(gain_causality, gain, other_causality, 1, 
               input, causality, 1), gain); 

END;;

