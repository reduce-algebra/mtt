%SUMMARY cr generic CR
%DESCRIPTION Argument is an algebraic expression with no embeddedwhite space
%DESCRIPTION Only available for one ports just now
%DESCRIPTION effort (or integrated effort) variable must be called mtt_e
%DESCRIPTION flow (or integrated flow) variable must be called mtt_f
%DESCRIPTION For example:
%DESCRIPTION             mtt_e=k*mtt_f
%DESCRIPTION             mtt_f=mtt_e/r

% $Log$
% Revision 1.5  2003/01/09 09:57:42  gawthrop
% Added dummy first argument (comp_type) to cr
%
% Revision 1.4  2000/12/28 09:18:38  peterg
% put under RCS
%
% Revision 1.3  2000/10/05 10:13:00  peterg
% New eqn2ass function.
% Started extension to multiports
%
% Revision 1.2  2000/10/03 18:35:04  peterg
% Removed comment bug
%
% Revision 1.1  2000/10/03 18:34:00  peterg
% Initial revision
%

%Copyright (C) 2000 by Peter J. Gawthrop


% Function to convert equation to assignment
OPERATOR eqn2ass;
FOR ALL comp_type, eqn,outlist,inputs 
LET eqn2ass(eqn,outlist,inputs) =
BEGIN
    ass := {}; mtt_ports := 0;
    solutions := solve(eqn,outlist);
    FOR EACH solution IN solutions DO
    BEGIN
       mtt_ports := mtt_ports + 1;
       rh := RHS(solution);
       FOR EACH input IN inputs DO
         rh := sub(input,rh);
       ass := APPEND(ass,{rh});
    END;
    IF mtt_ports EQ 1 THEN
      RETURN FIRST(ass) 
    ELSE
      RETURN ass; 

    %return sub(input,rhs(first(solve(eqn,outlist))));
    % Needs multiplicity warning
END;


OPERATOR cr;

% Version for one-port components

% We need four versions so that state does not need to be explicitly
% mentioned.
% At the moment, assume only one solution (in fact the first is
% chosen)

%%%% This is the Equation version
% Flow input
FOR ALL comp_type, mtt_cr, input, out_cause
LET cr(comp_type,mtt_cr,out_cause, 1, input, flow, 1) 
      = eqn2ass(mtt_cr,mtt_e,{mtt_f=input});

% Effort input
FOR ALL comp_type, mtt_cr, input, out_cause
LET cr(comp_type,mtt_cr,out_cause, 1, input, effort, 1)
    = eqn2ass(mtt_cr,mtt_f,{mtt_e=input});

% Effort output
FOR ALL comp_type, mtt_cr, input, in_cause
LET cr(comp_type,mtt_cr,effort, 1, input, in_cause, 1) 
    = eqn2ass(mtt_cr,mtt_e,{mtt_f=input});

% Flow output
FOR ALL comp_type, mtt_cr, input, in_cause
LET cr(comp_type,mtt_cr,flow, 1, input, in_cause, 1) 
    = eqn2ass(mtt_cr,mtt_f,{mtt_e=input});

%%%% This is the assignment version
% Flow input
FOR ALL comp_type, mtt_cr_e,mtt_cr_f, input, out_cause
LET cr(comp_type,mtt_cr_e,mtt_cr_f,out_cause, 1, input, flow, 1) 
    = sub(mtt_f=input,mtt_cr_f);

% Effort input
FOR ALL comp_type, mtt_cr_e,mtt_cr_f, input, out_cause
LET cr(comp_type,mtt_cr_e,mtt_cr_f,out_cause, 1, input, effort, 1) 
    = sub(mtt_e=input,mtt_cr_e);

% Effort output
FOR ALL comp_type, mtt_cr_e,mtt_cr_f, input, in_cause
LET cr(comp_type,mtt_cr_e,mtt_cr_f,effort, 1, input, in_cause, 1) 
    = sub(mtt_f=input,mtt_cr_f);

% Flow output
FOR ALL comp_type, mtt_cr_e,mtt_cr_f, input, in_cause
LET cr(comp_type,mtt_cr_e,mtt_cr_f,flow, 1, input, in_cause, 1) 
    = sub(mtt_e=input,mtt_cr_e);


%%% Q&D FMR 2 port.
FOR ALL comp_type, mtt_cr_e,mtt_cr_f,input_1,input_2
LET cr(comp_type,mtt_cr_e,mtt_cr_f,flow,1,
	input_1,effort,1,
	input_2,flow,2
	)  = sub(mtt_mod=input_2,sub(mtt_e=input_1,mtt_cr_e));

%% AE amplifier
FOR ALL  mtt_cr, input, out_cause
LET cr(ae,mtt_cr,effort, 2, 
        input, effort, 1)
    = eqn2ass(mtt_cr,mtt_2,{mtt_1=input});

END;
