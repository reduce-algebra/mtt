function structure = mttSetFieldDefault(structure,component,value)
    undefined = 0 ;
    if isfield(structure,component)
        undefined = isempty(getfield(structure,component)) ;
    else
        undefined = 1 ;
    end
        
    if undefined
        structure = setfield(structure,component,value) ;
    end
