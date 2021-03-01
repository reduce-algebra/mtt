function model = mttDeleteField(structure,field_name)
    if isfield(structure,field_name)
        model = rmfield(structure,field_name) ;
    else
        model = structure ;
    end
