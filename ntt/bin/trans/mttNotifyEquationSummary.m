function mttNotifyEquationSummary(number_of_equations,number_of_covariables,number_of_interface_variables)
    mttNotify(['   ...model has ',num2str(number_of_equations),' equations']) ;
    mttWriteNewLine ;
    mttNotify(['      with ',num2str(number_of_covariables),' co_variables']) ;
    mttNotify([' and ',num2str(number_of_interface_variables),' interface_variables']) ;
    mttWriteNewLine ;
    
