function model = mttMeasureDomainCompletion(model)
    
    number_of_bonds = mttGetFieldLength(model,'bond') ;

    for i = 1:number_of_bonds
        domain_defined(i) = ~isempty(model.bond(i).domain) ;
    end
    
    domain_completion.bonds = number_of_bonds ;
    domain_completion.assignments = sum(domain_defined) ;
    
    domain_completion.is_done = (domain_completion.bonds==domain_completion.assignments) ;
    
    object_names = mttGetFieldNames(model,'obj') ;
    number_of_objects = length(object_names) ;
    
    for i = 1:number_of_objects
        object_name = object_names{i} ;
        object = getfield(model,'obj',object_name) ;
        if ~isempty(object.abg)
            object = mttMeasureDomainCompletion(object) ;
            
            domain_completion.bonds       = domain_completion.bonds       + object.domain_completion.bonds ;
            domain_completion.assignments = domain_completion.assignments + object.domain_completion.assignments ;
            
            domain_completion.is_done     = domain_completion.is_done     & object.domain_completion.is_done ;
        end
    end
    
    model.domain_completion = domain_completion ;
    
    
