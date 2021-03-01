% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linear constitutive relationship.

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Linear Constitutive Relationship for single port components: R,C,I.
% e = Gain*f (if gain_causality = flow) 
%           f = Gain*e (if gain_causality = effort)
OPERATOR lin;
FOR ALL gain_causality, gain, causality, input, other_causality
SUCH THAT causality = gain_causality
LET lin(gain_causality, gain, other_causality, 1, input, causality, 1)
	 = gain*input;

%Linear CR: e = (1/Gain)*f (if gain_causality = flow) 
%           f = (1/Gain)*e (if gain_causality = effort)
FOR ALL gain_causality, gain, causality, input, other_causality
SUCH THAT causality NEQ gain_causality
LET lin(gain_causality, gain, other_causality, 1, input, causality, 1)
	 = input/gain;


% Linear Constitutive Relationship for AE and AF
% Output = gain * input

% Unicausal form
FOR ALL gain, input, causality
LET lin(gain, causality, 2, input, causality, 1) = gain*input;

%Bicausal form
FOR ALL gain, output, causality
LET lin(gain, causality, 1, output, causality, 2) = output/gain;

% Linear Constitutive Relationship for TF
FOR ALL gain, input, causality, gain_causality, outport, inport
SUCH THAT (
	(causality = gain_causality) AND (outport = 2)
	OR
	(causality NEQ gain_causality) AND (outport = 1)
	)
LET lin(gain_causality, gain, causality, outport, input, causality, inport)
	 = gain*input;

FOR ALL gain, input, causality, gain_causality, outport, inport
SUCH THAT (
	(causality NEQ gain_causality) AND (outport = 2)
	OR
	(causality = gain_causality) AND (outport = 1)
	)
LET lin(gain_causality, gain, causality, outport, input, causality, inport)
	 = input/gain;

END;

