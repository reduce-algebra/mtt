function is_complete = mttNotifyEquationSort(sort_iteration,...
    number_of_unsorted_equations,number_of_equations,...
    number_of_known_covariables,number_of_covariables,...
    number_of_known_interface_variables,number_of_interface_variables) ;
	
%	number_of_known_covariables = number_of_known_covariables - 1 ;
	number_of_known_interface_variables = number_of_known_interface_variables - 1 ;
    
    number_of_sorted_equations = number_of_equations - number_of_unsorted_equations ;
    
    sorted = floor(100*number_of_sorted_equations/number_of_equations) ;
    covar = floor(100*number_of_known_covariables/number_of_covariables) ;
    interface_var = floor(100*number_of_known_interface_variables/number_of_interface_variables) ;
    
    fprintf(['   ...%i%% complete [%i/%i]\n'],...
        sorted,number_of_sorted_equations,number_of_equations) ;
    fprintf(['          matching %i%% co_variables [%i/%i] and'],...
        covar,number_of_known_covariables,number_of_covariables) ;
    fprintf([' %i%% interface_variables [%i/%i]\n'],...
        interface_var,number_of_known_interface_variables,number_of_interface_variables) ;
    
    is_complete = (sorted==100) & (covar==100) & (interface_var==100) ;
    
