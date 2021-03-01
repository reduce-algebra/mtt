function field = mttGetField(structure,component)
	field = [] ;
	if isfield(structure,component)
        field = getfield(structure,component) ;
    end
