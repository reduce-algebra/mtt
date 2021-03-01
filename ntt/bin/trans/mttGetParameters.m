function [parameters,default_values] = mttGetParameters(parameter_list)
    [parameters,default_values] = mttGetItemList(parameter_list) ;
    
    for n = 1:length(parameters)
        parameter_name = parameters{n} ;
        mttValidateName(parameter_name) ;
    end
    
    for n = 1:length(default_values)
        default_value = default_values{n} ;
        if ~isempty(default_value)
            mttAssert(mttIsNumericText(default_value),...
                'Parameter list contains non-numeric default value') ;
        end
    end
