%% CR for pipe discharge


OPERATOR discharge;
%% Flow input
FOR ALL alpha,beta,F LET
    discharge(alpha,beta,effort,1,F,flow,1) = beta*F^alpha;

%% Effort input
FOR ALL alpha,beta,P LET
    discharge(alpha,beta,flow,1,P,effort,1) = (P/beta)^(1/alpha);

END;;
