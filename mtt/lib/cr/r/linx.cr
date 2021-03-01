%%% linx - cr for single port I and C with an initial state x_0



%DESCRIPTION    linear cr for single port I and C with an initial state x0
%DESCRIPTION    only adds x0 if in integral causality


OPERATOR linx;

%% Input causality as specified
%Linear Constitutive Relationship for single port components: C,I.
% e = Gain*f (if gain_causality = flow) 
%           f = Gain*e (if gain_causality = effort)

FOR ALL gain_causality, gain, causality, input, other_causality
SUCH THAT (causality = gain_causality) AND (causality = state)
LET linx(gain_causality, gain, x0, other_causality, 1, input, causality, 1)
         = gain*(input + x0);


FOR ALL gain_causality, gain, causality, input, other_causality
SUCH THAT (causality = gain_causality) AND (causality NEQ state)
LET linx(gain_causality, gain, x0, other_causality, 1, input, causality, 1)
         = gain*(input);

%% Input causality not as specified
%Linear CR: e = (1/Gain)*f (if gain_causality = flow) 
%           f = (1/Gain)*e (if gain_causality = effort)

FOR ALL gain_causality, gain, x0, causality, input, other_causality
SUCH THAT (causality NEQ gain_causality) AND  (causality = state)
LET linx(gain_causality, gain, x0, other_causality, 1, input, causality, 1)
         = (input+x0)/gain;

FOR ALL gain_causality, gain, x0, causality, input, other_causality
SUCH THAT (causality NEQ gain_causality) AND  (causality NEQ state)
LET linx(gain_causality, gain, x0, other_causality, 1, input, causality, 1)
         = (input)/gain;




END;;
