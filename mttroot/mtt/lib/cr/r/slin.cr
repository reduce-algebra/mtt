%DESCRIPTION Sensitivity version of lin

OPERATOR slin;
FOR ALL gain_causality, gain, causality, input, other_causality
LET slin(gain_causality, gain, other_causality, 1, input, causality, 1)
         = lin(gain_causality, gain, other_causality, 1, input,
	 causality, 1);
END;;

