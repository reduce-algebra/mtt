function counter = mttCountSystemMapping(model)

sympars = count_system_sympars(model) ;
inputs  = count_system_inputs(model) ;
invars  = count_system_invars(model) ;
outvars = count_system_outvars(model) ;
states  = count_system_states(model) ;

counter.input = sympars + inputs + invars ;
counter.output = outvars ;
counter.state  = states ;


function counter = count_system_sympars(model)
    number_of_variables = mttGetFieldLength(model,'sympar') ;
    counter = 0 ;
    
    for i = 1:number_of_variables
        default_value = model.sympar_default{i} ;
        if isempty(default_value)
            counter = counter + 1 ;
        end
    end
    
    
function counter = count_system_inputs(model)
    number_of_variables = mttGetFieldLength(model,'input') ;
    
    objects = mttGetFieldNames(model,'obj') ;
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        additional_variables = 0 ;
        if ~isempty(object.abg)
            additional_variables = count_system_inputs(object) ;
        elseif ~isempty(object.cr)
            additional_variables = count_system_inputs(object.cr) ;
        end
        
        number_of_variables = number_of_variables + additional_variables ;
    end
    
    counter = number_of_variables ;
    
    
function counter = count_system_invars(model,root,env)
    is_root_model = nargin==1 ;
    
    if is_root_model
        root = model ;
        env = model.env ;
    end
    
    number_of_variables = 0 ;
    
    objects = mttGetFieldNames(model,'obj') ;
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        switch object.class
        case {'SS','Se','Sf','De','Df'}
            inbond_number = object.interface.in ;
            outbond_number = object.interface.out ;
            
            inbond = model.bond(inbond_number) ;
            outbond = model.bond(outbond_number) ;
            
            if ~isempty(inbond)
                covariables = mttGetCovariables(env,inbond.domain,inbond.domain_item) ;
                covar = [] ;
                
                if ~inbond.effort
                    if ~strcmp(object.class,'Df')
                        covar = covariables.effort ;
                    end
                elseif inbond.flow
                    if ~strcmp(object.class,'De')
                        covar = covariables.flow ;
                    end
                end
                
                number_of_variables = number_of_variables + length(covar) ;
            end
            
            if ~isempty(outbond)
                covariables = mttGetCovariables(env,outbond.domain,outbond.domain_item) ;
                covar = [] ;
                
                if outbond.effort
                    covar = covariables.effort ;
                elseif ~outbond.flow
                    covar = covariables.flow ;
                end
                
                number_of_variables = number_of_variables + length(covar) ;
            end
        end
        
        additional_variables = 0 ;
        if ~isempty(object.abg)
            additional_variables = count_system_invars(object,root,env) ;
        end
        
        number_of_variables = number_of_variables + additional_variables ;
    end
    
    counter = number_of_variables ;
    
    
function counter = count_system_outvars(model,root,env)
    is_root_model = nargin==1 ;
    
    if is_root_model
        root = model ;
        env = model.env ;
    end

    number_of_variables = 0 ;
    
    objects = mttGetFieldNames(model,'obj') ;
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        switch object.class
        case {'SS','Se','Sf','De','Df'}
            inbond_number = object.interface.in ;
            outbond_number = object.interface.out ;
            
            inbond = model.bond(inbond_number) ;
            outbond = model.bond(outbond_number) ;
            
            if ~isempty(inbond)
                covariables = mttGetCovariables(env,inbond.domain,inbond.domain_item) ;
                covar = [] ;
                
                if inbond.effort
                    covar = covariables.effort ;
                elseif ~inbond.flow
                    covar = covariables.flow ;
                end
                
                number_of_variables = number_of_variables + length(covar) ;
            end
            
            if ~isempty(outbond)
                covariables = mttGetCovariables(env,outbond.domain,outbond.domain_item) ;
                covar = [] ;
                
                if ~outbond.effort
                    if ~strcmp(object.class,'Sf')
                        covar = covariables.effort ;
                    end
                elseif outbond.flow
                    if ~strcmp(object.class,'Se')
                        covar = covariables.flow ;
                    end
                end
                
                number_of_variables = number_of_variables + length(covar) ;
            end
        end
        
        additional_variables = 0 ;
        if ~isempty(object.abg)
            additional_variables = count_system_outvars(object,root,env) ;
        end
        
        number_of_variables = number_of_variables + additional_variables ;
    end
    
    counter = number_of_variables ;
    
    
function counter = count_system_states(model)
    number_of_variables = mttGetFieldLength(model,'state') ;
    
    objects = mttGetFieldNames(model,'obj') ;
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        additional_variables = 0 ;
        if ~isempty(object.abg)
            additional_variables = count_system_states(object) ;
        elseif ~isempty(object.cr)
            additional_variables = count_system_states(object.cr) ;
        end
        
        number_of_variables = number_of_variables + additional_variables ;
    end
    
    counter = number_of_variables ;
