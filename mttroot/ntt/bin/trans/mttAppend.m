function information = mttAppend(information,field,items)
	if isfield(information,field)
        previous = getfield(information,field) ;
        if isempty(previous)
            information = setfield(information,field,items) ;
        else
            information = setfield(information,field,[previous,items]) ;
        end
    else
        information = setfield(information,field,items) ;
    end            
