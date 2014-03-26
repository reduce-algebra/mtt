%SUMMARY cp    Chemical potential constitutive relationship

% This formula gives the Gibb's free energy for a reaction component
% with given concentration.
% k_e is the corresponding equilibrium constant.

% C version integral causality
FOR ALL  concentration, k_e, RT
LET cp(C,k_e,RT, effort, 1, 
        concentration, state, 1)
         = RT*log(k_e*concentration);

% C version derivative causality
FOR ALL  potential, k_e, RT
LET cp(C,k_e,RT, state, 1, 
        potential, effort, 1)
         = exp(potential/RT)/k_e;

%AE version
FOR ALL  concentration, RT
LET cp(AE,RT,effort,2,concentration,effort,1) 
        = RT*log(concentration);

%AE version with k_e
FOR ALL  concentration, k_e, RT
LET cp(AE,k_e,RT,effort,2,concentration,effort,1) 
        = RT*log(k_e*concentration);
