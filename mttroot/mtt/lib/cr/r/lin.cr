%SUMMARY lin    linear constitutive relationship
%DESCRIPTION Parameter 1 defines input causality relating to parameter 2
%DESCRIPTION value is effort, flow or state
%DESCRIPTION Parameter 2 is the gain corresponding to the causality of
%DESCRIPTION parameter 1.
%DESCRIPTION Supported components:

%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linear constitutive relationship.


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % $Id$
% % $Log$
% % Revision 1.3  1998/07/04 10:47:04  peterg
% % back under RCS
% %
% % Revision 1.2  1998/03/04 15:38:54  peterg
% % Added END statement
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%DESCRIPTION    single port components: R,C,I
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

%DESCRIPTION    two port components: AE, AF
% Linear Constitutive Relationship for AE and AF
% Output = gain * input

% Unicausal form
FOR ALL gain, input, causality
LET lin(gain, causality, 2, input, causality, 1) = gain*input;

%Bicausal form
FOR ALL gain, output, causality
LET lin(gain, causality, 1, output, causality, 2) = output/gain;

%DESCRIPTION   two port component: TF
% Linear Constitutive Relationship for TF
FOR ALL gain_causality, gain, causality, outport, input, same_causality, inport

SUCH THAT 
       ( causality = same_causality ) 
       AND 
       ( inport NEQ outport )
       AND
       (
       ( (causality = gain_causality) AND (outport = 2) )
       OR
       ( (causality NEQ gain_causality) AND (outport = 1) )
       )
LET lin(gain_causality, gain, causality, outport, 
          input, same_causality, inport)
        = gain*input;

FOR ALL gain_causality, gain, causality, outport, 
        input, same_causality, inport
SUCH THAT 
       ( causality = same_causality ) 
       AND       
       ( inport NEQ outport )
       AND
       (
       ( (causality NEQ gain_causality) AND (outport = 2) )
       OR
       ( (causality = gain_causality) AND (outport = 1) )
       )
LET lin(gain_causality, gain, causality, outport, 
         input, same_causality, inport)
        = input/gain;

%% This version in not reliable. I rellly need to pass component names
%% as cr arguments.

%DESCRIPTION    two port component: GY
% Linear Constitutive Relationship for GY

FOR ALL gain, input, causality, gain_causality, other_causality, 
        outport, inport
SUCH THAT 
        (causality NEQ other_causality) 
        AND
        ( inport NEQ outport )
        AND
        (
        ( (causality NEQ gain_causality) AND (outport = 2) )
        OR
        ( (causality NEQ gain_causality) AND (outport = 1) )
        )
LET lin(gain_causality, gain, other_causality, outport, 
        input, causality, inport)
         = input/gain;

FOR ALL gain, input, causality, gain_causality, other_causality, 
        outport, inport
SUCH THAT 
        (causality NEQ other_causality) 
        AND
        ( inport NEQ outport )
        AND
        (
        ( (causality = gain_causality) AND (outport = 2) )
        OR
        ( (causality = gain_causality) AND (outport = 1) )
        )
LET lin(gain_causality, gain, other_causality, outport, 
        input, causality, inport)
         = gain*input;

%DESCRIPTION    three port component: FMR

% Linear Constitutive Relationship for FMR - unicausal case
% Flow modulation multiplies effort on port 1 (or divides flow)

% The 4 possibilities follow...
FOR ALL gain_causality, gain, out_causality, input, in_causality,
        mod_input
SUCH THAT (gain_causality=in_causality) AND (out_causality=flow)
LET lin(gain_causality, gain, out_causality, 1, 
                input, in_causality, 1,
                mod_input, flow, 2)
         = input*gain*mod_input;

FOR ALL gain_causality, gain, out_causality, input, in_causality,
        mod_input
SUCH THAT (gain_causality=in_causality) AND (out_causality=effort)
LET lin(gain_causality, gain, out_causality, 1, 
                input, in_causality, 1,
                mod_input, flow, 2)
         = input*gain/mod_input;

FOR ALL gain_causality, gain, out_causality, input, in_causality,
        mod_input
SUCH THAT (gain_causality NEQ in_causality) AND (out_causality=flow)
LET lin(gain_causality, gain, out_causality, 1, 
                input, in_causality, 1,
                mod_input, flow, 2)
         = input*mod_input/gain;

FOR ALL gain_causality, gain, out_causality, input, in_causality,
        mod_input
SUCH THAT (gain_causality NEQ in_causality) AND (out_causality=effort)
LET lin(gain_causality, gain, out_causality, 1, 
                input, in_causality, 1,
                mod_input, flow, 2)
         = input/(gain*mod_input);

% Linear Constitutive Relationship for FMR - bicausal case
% Deduces the flow on port 2.

% The 2 possibilities follow...
FOR ALL gain,  e_input, f_input
LET lin(effort, gain, flow, 2, 
                e_input, effort, 1,
                f_input, flow, 1)
         = (f_input/e_input)/gain;

%EMTF component - modulation only
% Linear Constitutive Relationship for EMTF
FOR ALL gain_causality, gain, causality, outport, input, same_causality, inport
SUCH THAT 
       ( (causality = gain_causality) AND (outport = 2) )
       OR
       ( (causality NEQ gain_causality) AND (outport = 1) )
LET lin(gain_causality, causality, outport, 
          input, same_causality, inport,
	  gain, effort, 3)
        = gain*input;

FOR ALL gain_causality, gain, causality, outport, 
        input, same_causality, inport
SUCH THAT 
       ( (causality NEQ gain_causality) AND (outport = 2) )
       OR
       ( (causality = gain_causality) AND (outport = 1) )
LET lin(gain_causality, causality, outport, 
         input, same_causality, inport,
	  gain, effort, 3)
        = input/gain;

%EMTF component - modulation and gain
% Linear Constitutive Relationship for EMTF
FOR ALL gain_causality, gain, causality, outport, input,
same_causality, inport, modulation
SUCH THAT 
       ( (causality = gain_causality) AND (outport = 2) )
       OR
       ( (causality NEQ gain_causality) AND (outport = 1) )
LET lin(gain_causality, gain, causality, outport, 
          input, same_causality, inport,
	  modulation, effort, 3)
        = gain*modulation*input;

FOR ALL gain_causality, gain, causality, outport, 
        input, same_causality, inport, modulation
SUCH THAT 
       ( (causality NEQ gain_causality) AND (outport = 2) )
       OR
       ( (causality = gain_causality) AND (outport = 1) )
LET lin(gain_causality, gain, causality, outport, 
         input, same_causality, inport,
	  modulation, effort, 3)
        = input/(gain*modulation);

END;;

