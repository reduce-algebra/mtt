%DESCRIPTION Sensitivity version of lin

in "$MTT_CRS/r/lin.cr";

% One port version for historical reasons
OPERATOR slin;
FOR ALL gain_causality, gain, causality, input, other_causality
LET slin(gain_causality, gain, other_causality, 1, input, causality, 1)
         = lin(gain_causality, gain, other_causality, 1, input,
	 causality, 1);

% Two port version for sC,sI,sR 

% Port 1 - standard 
FOR ALL COMPONENT, gain_causality, gain, sgain, causality, input, sinput, other_causality
LET slin(COMPONENT,gain_causality, gain, sgain, other_causality, 1, 
       input, causality, 1,
       sinput, causality, 2)
         = lin(COMPONENT,gain_causality, gain, other_causality, 1, 
               input, causality, 1); 


% Port 2 - sensitivity
FOR ALL COMPONENT, gain_causality, gain, sgain, causality, input, sinput, other_causality
SUCH THAT sgain NEQ 0
LET slin(COMPONENT,gain_causality, gain, sgain, other_causality, 2, 
       input, causality, 1,
       sinput, causality, 2)
         = lin(COMPONENT,gain_causality, gain, other_causality, 1, 
               sinput, causality, 1)
         + sgain*df(lin(COMPONENT,gain_causality, gain, other_causality, 1, 
               input, causality, 1), gain); 

%% Don't compute the derivative in this case
FOR ALL COMPONENT, gain_causality, gain, sgain, causality, input, sinput, other_causality
SUCH THAT sgain EQ 0
LET slin(COMPONENT,gain_causality, gain, sgain, other_causality, 2, 
       input, causality, 1,
       sinput, causality, 2)
         = lin(COMPONENT,gain_causality, gain, other_causality, 1, 
               sinput, causality, 1);
         

%% This is the version to go with sEMTF
%% It is the CR passed to the AE3 components

%DESCRIPTION four port component - effort i/o
FOR ALL COMPONENT, gain, input, junk, m_input, dm_input
LET slin(COMPONENT,gain, effort, 2, 
	input, effort, 1,
	junk, flow, 2,
	m_input, effort, 3,
        dm_input,effort, 4)
	 = gain*dm_input*input;

%DESCRIPTION four port component - flow i/o
FOR ALL COMPONENT, gain, input, junk, m_input, dm_input
LET slin(COMPONENT,gain, flow, 2, 
	input, flow, 1,
	junk, effort, 2,
	m_input, effort, 3,
        dm_input,effort, 4)
	 = gain*dm_input*input;

END;;






