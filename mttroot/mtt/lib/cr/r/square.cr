%SUMMARY square	square-law constitutive relationship
%DESCRIPTION Parameter 1 defines input causality relating to parameter 2
%DESCRIPTION value is effort or flow
%DESCRIPTION Parameter 2 is the gain r corresponding to the causality of
%DESCRIPTION parameter 1.
%DESCRIPTION Supported components:


%DESCRIPTION	single port components: R

%Square-Law Constitutive Relationship for single port components: R
% output = Gain*input^2*sign(input) {if gain_causality = causality} 
% output = (1/Gain^(1/2))*input^(1/2)*sign(input) 
%		{if gain_causality not= causality} 



OPERATOR square;
FOR ALL gain_causality, gain, causality, input, other_causality
SUCH THAT causality = gain_causality
LET square(gain_causality, gain, other_causality, 1, input, causality, 1)
	 = gain*input^2*sign(input);


FOR ALL gain_causality, gain, causality, input, other_causality
SUCH THAT causality NEQ gain_causality
LET square(gain_causality, gain, other_causality, 1, input, causality, 1)
	 = input^(1/2)*sign(input)/(gain^(1/2));


END;
