function N = mttGetFieldLength(structure,vector)
    N = 0 ;
    if isfield(structure,vector)
        N = length(getfield(structure,vector)) ;
    end
