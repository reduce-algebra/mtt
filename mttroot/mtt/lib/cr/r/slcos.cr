%SUMMARY slcos	linear constitutive relationship with sin modulation - sensitivity
%DESCRIPTION Parameter 1 defines input causality relating to parameter 2
%DESCRIPTION value is effort, flow or state
%DESCRIPTION Parameter 2 is the gain corresponding to the causality of
%DESCRIPTION parameter 1.
%DESCRIPTION Supported components:


OPERATOR slcos;

%DESCRIPTION four port component - effort i/o
FOR ALL gain, input, junk, m_input, dm_input
LET slcos(gain, effort, 2, 
	input, effort, 1,
	junk, flow, 2,
	m_input, effort, 3,
        dm_input,effort, 4)
	 = -gain*sin(m_input)*dm_input*input;

%DESCRIPTION four port component - flow i/o
FOR ALL gain, input, junk, m_input, dm_input
LET slcos(gain, flow, 2, 
	input, flow, 1,
	junk, effort, 2,
	m_input, effort, 3,
        dm_input,effort, 4)
	 = -gain*sin(m_input)*dm_input*input;

END;;
