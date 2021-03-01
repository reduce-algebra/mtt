%% CR for pipe discharge


OPERATOR discharge;
%% Flow input
FOR ALL COMP, alpha,beta,F LET
    discharge(COMP, alpha,beta,effort,1,F,flow,1) = beta*F^alpha;

%% Effort input
FOR ALL COMP, alpha,beta,P LET
    discharge(COMP, alpha,beta,flow,1,P,effort,1) = (P/beta)^(1/alpha);

END;;
