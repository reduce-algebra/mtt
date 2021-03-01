%% CR for conical tank example

OPERATOR conical;
%% State input.
FOR ALL COMP, rho,g,V_0,V LET
    conical(COMP, rho,g,V_0,effort,1,V,state,1) = rho*g*(12*(V+V_0)/pi)^(1/3);


END;;
