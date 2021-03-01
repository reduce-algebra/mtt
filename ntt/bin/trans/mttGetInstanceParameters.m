function parameters = mttGetInstanceParameters(parameter_list)
    parameters = mttGetItemList(parameter_list) ;

    for n = 1:length(parameters)
        if mttIsNumericText(parameters{n})
            parameters{n} = str2num(parameters{n}) ;
        else
            mttValidateName(parameters{n}) ;
        end
    end
