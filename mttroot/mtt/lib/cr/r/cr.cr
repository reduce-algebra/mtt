%SUMMARY cr generic CR
%DESCRIPTION Argument is an algebraic expression with no embeddedwhite space
%DESCRIPTION Only available for one ports just now
%DESCRIPTION effort (or integrated effort) variable must be called mtt_e
%DESCRIPTION flow (or integrated flow) variable must be called mtt_f
%DESCRIPTION For example:
%DESCRIPTION             mtt_e=k*mtt_f
%DESCRIPTION             mtt_f=mtt_e/r

% $Log$

%Copyright (C) 2000 by Peter J. Gawthrop

% Version for one-port components
operator cr;

% We need four versions so that state does not need to be explicitly
% mentioned.
% At the moment, assume only one solution (in fact the first is
chosen)

% Flow input
FOR ALL mtt_cr, input, out_cause
LET cr(mtt_cr,out_cause, 1, input, flow, 1) = sub(mtt_f=input,rhs(first(solve(mtt_cr,mtt_e))));

% Effort input
FOR ALL mtt_cr, input, out_cause
LET cr(mtt_cr,out_cause, 1, input, effort, 1) = sub(mtt_e=input,rhs(first(solve(mtt_cr,mtt_f))));

% Effort output
FOR ALL mtt_cr, input, in_cause
LET cr(mtt_cr,effort, 1, input, in_cause, 1) = sub(mtt_f=input,rhs(first(solve(mtt_cr,mtt_e))));

% Flow output
FOR ALL mtt_cr, input, in_cause
LET cr(mtt_cr,flow, 1, input, in_cause, 1) = sub(mtt_e=input,rhs(first(solve(mtt_cr,mtt_f))));


END;
