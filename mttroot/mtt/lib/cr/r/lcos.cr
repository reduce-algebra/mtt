%SUMMARY lcos	linear constitutive relationship with cos modulation
%DESCRIPTION Parameter 1 defines input causality relating to parameter 2
%DESCRIPTION value is effort, flow or state
%DESCRIPTION Parameter 2 is the gain corresponding to the causality of
%DESCRIPTION parameter 1.
%DESCRIPTION Supported components:

%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linear constitutive relationship with cos modulation


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


OPERATOR lcos;

%DESCRIPTION three port component: EMTF
FOR ALL gain, input, causality, gain_causality, outport, inport,
	 m_input, m_causality
SUCH THAT (
	(causality = gain_causality) AND (outport = 2)
	OR
	(causality NEQ gain_causality) AND (outport = 1)
	)
LET lcos(gain_causality, gain, causality, outport, 
	input, causality, inport,
	m_input, m_causality, 3)
	 = cos(m_input)*gain*input;

FOR ALL gain, input, causality, gain_causality, outport, inport,
	 m_input, m_causality
SUCH THAT (
	(causality NEQ gain_causality) AND (outport = 2)
	OR
	(causality = gain_causality) AND (outport = 1)
	)
LET lcos(gain_causality, gain, causality, outport, 
	input, causality, inport,
	m_input, m_causality, 3)
	 = input/(cos(m_input)*gain);
