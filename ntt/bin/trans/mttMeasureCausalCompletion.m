function model = mttMeasureCausalCompletion(model)
    
    number_of_bonds = mttGetFieldLength(model,'bond') ;

    for i = 1:number_of_bonds
        effort_defined(i) = ~isempty(model.bond(i).effort) ;
        flow_defined(i) = ~isempty(model.bond(i).flow) ;
    end
    partly_defined = effort_defined|flow_defined ;
    fully_defined = effort_defined&flow_defined ;
    
    causal_completion.bonds = number_of_bonds ;
    causal_completion.flows = sum(flow_defined) ;
    causal_completion.efforts = sum(effort_defined) ;
    causal_completion.assignments = sum(partly_defined) ;
    
    unicausal_bonds = 0 ;
    causal_bond = model.bond(fully_defined) ;
    for i = 1:length(causal_bond)
        if causal_bond(i).effort==causal_bond(i).flow
            unicausal_bonds = unicausal_bonds + 1 ;
        end
    end
    causal_completion.unicausal = unicausal_bonds ;
    causal_completion.is_unicausal = causal_completion.assignments==causal_completion.unicausal ;
    
    causal_completion.is_causal = (causal_completion.efforts==causal_completion.bonds) ...
                                & (causal_completion.flows==causal_completion.bonds) ;
    
    object_names = mttGetFieldNames(model,'obj') ;
    number_of_objects = length(object_names) ;
    
    for i = 1:number_of_objects
        object_name = object_names{i} ;
        object = getfield(model,'obj',object_name) ;
        if ~isempty(object.abg)
            object = mttMeasureCausalCompletion(object) ;
            
            causal_completion.bonds         = causal_completion.bonds        + object.causal_completion.bonds ;
            causal_completion.flows         = causal_completion.flows        + object.causal_completion.flows ;
            causal_completion.efforts       = causal_completion.efforts      + object.causal_completion.efforts ;
            causal_completion.assignments   = causal_completion.assignments  + object.causal_completion.assignments ;
            causal_completion.unicausal     = causal_completion.unicausal    + object.causal_completion.unicausal ;
            
            causal_completion.is_unicausal  = causal_completion.is_unicausal & object.causal_completion.is_unicausal ;
            causal_completion.is_causal     = causal_completion.is_causal    & object.causal_completion.is_causal ;
        end
    end
    
    model.causal_completion = causal_completion ;
    
    
