%SUMMARY powerlaw	powerlaw constitutive relationship
%DESCRIPTION Parameter 1 defines input causality relating to parameter 2
%DESCRIPTION value is effort or flow
%DESCRIPTION Parameter 2 is the gain r corresponding to the causality of
%DESCRIPTION parameter 1.
%DESCRIPTION Supported components:


%DESCRIPTION	single port components: R

%Powerlaw Constitutive Relationship for single port components: R


OPERATOR powerlaw;
FOR ALL gain_causality, gain, power, causality, input, other_causality
SUCH THAT causality = gain_causality
LET powerlaw(gain_causality, gain, power, other_causality, 1, input, causality, 1)
	 = gain*(abs(input)^power)*sign(input);


FOR ALL gain_causality, gain, power, causality, input, other_causality
SUCH THAT causality NEQ gain_causality
LET powerlaw(gain_causality, gain, power, other_causality, 1, input, causality, 1)
	 = ( (abs(input)/gain)^(1/power) )*sign(input);

END;