%SUMMARY lsin	linear constitutive relationship with sin modulation
%DESCRIPTION Parameter 1 defines input causality relating to parameter 2
%DESCRIPTION value is effort, flow or state
%DESCRIPTION Parameter 2 is the gain corresponding to the causality of
%DESCRIPTION parameter 1.
%DESCRIPTION Supported components:

%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linear constitutive relationship with sin modulation


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.2  1998/03/04 17:51:37  peterg
% %% Added END
% %%
% %% Revision 1.1  1996/11/02 10:18:25  peterg
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


OPERATOR lsin;

%DESCRIPTION three port component: EMTF
FOR ALL comp_type, gain, input, causality, gain_causality, outport, inport,
	 m_input, m_causality
SUCH THAT (
	(causality = gain_causality) AND (outport = 2)
	OR
	(causality NEQ gain_causality) AND (outport = 1)
	)
LET lsin(comp_type, gain_causality, gain, causality, outport, 
	input, causality, inport,
	m_input, m_causality, 3)
	 = sin(m_input)*gain*input;

FOR ALL comp_type, gain, input, causality, gain_causality, outport, inport,
	 m_input, m_causality
SUCH THAT (
	(causality NEQ gain_causality) AND (outport = 2)
	OR
	(causality = gain_causality) AND (outport = 1)
	)
LET lsin(comp_type, gain_causality, gain, causality, outport, 
	input, causality, inport,
	m_input, m_causality, 3)
	 = input/(sin(m_input)*gain);

END;;
