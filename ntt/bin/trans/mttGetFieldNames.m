function namelist = mttGetFieldNames(structure,component)
    namelist = [] ;
    if isfield(structure,component)
        field = getfield(structure,component) ;
        if ~isempty(field)
            namelist = fieldnames(field) ;
        end
    end

