function icd = mttCreateSystemMdl_ICD(model)

sympar = map_system_sympars(model) ;
input  = map_system_inputs(model) ;
invar  = map_system_invars(model) ;
outvar = map_system_outvars(model) ;

icd.output_namelist = outvar ;
icd.input_namelist = invar ;
if ~isempty(input)
    icd.input_namelist = [icd.input_namelist,input] ;
end
if ~isempty(sympar)
    icd.input_namelist = [icd.input_namelist,sympar] ;
end

icd.output_namelist = sort(icd.output_namelist) ;
icd.input_namelist = sort(icd.input_namelist) ;



function map = map_system_sympars(model)
	mttNotify('...mapping system inputs (symbolic parameters)') ;
    mttWriteNewLine ;
    
    map = [] ;
    line = 0 ;
    
    number_of_variables = mttGetFieldLength(model,'sympar') ;
    
    model_name = mttDetachText(model.source,'/') ;
    
    for i = 1:number_of_variables
        variable_name = model.sympar{i} ;
        default_value = model.sympar_default{i} ;
        
        if isempty(default_value)
            line = line + 1 ;
            map{line} = [model_name,'___',variable_name] ;
        end
    end
    
    
function map = map_system_inputs(model,root,branch)
    is_root_model = nargin==1 ;
    
    if is_root_model
        mttNotify('...mapping system inputs (input variables)') ;
        mttWriteNewLine ;
        
        root = model ;
        current_branch = mttDetachText(model.source,'/') ;
    else
        current_branch = branch ;
    end

    map = [] ;
    line = 0 ;
    
    number_of_variables = mttGetFieldLength(model,'input') ;
    
    for i = 1:number_of_variables
        variable_name = model.input{i} ;
        
        line = line + 1 ;
        map{line} = [current_branch,'___',variable_name] ;
    end
    
    objects = mttGetFieldNames(model,'obj') ;
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        next_branch = [current_branch,'__',object_name] ;
        
        additional_map = [] ;
        if ~isempty(object.abg)
            additional_map = map_system_inputs(object,root,next_branch) ;
        elseif ~isempty(object.cr)
            additional_map = map_system_inputs(object.cr,root,next_branch) ;
        end
        
        if isempty(map)
            map = additional_map ;
        else
            line = length(map) ;
            for j = 1:length(additional_map)
                if ~ismember(additional_map{j},map)
                    line = line + 1 ;
                    map{line} = additional_map{j} ;
                end
            end
        end
    end
    
    
function map = map_system_invars(model,root,branch,env)
    is_root_model = nargin==1 ;
    
    if is_root_model
        mttNotify('...mapping system inputs (input covariables)') ;
        mttWriteNewLine ;
        
        root = model ;
        current_branch = mttDetachText(model.source,'/') ;
        env = model.env ;
    else
        current_branch = branch ;
    end

    map = [] ;
    line = 0 ;
    
    objects = mttGetFieldNames(model,'obj') ;
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        next_branch = [current_branch,'__',object_name] ;
        
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
                
                for j = 1:length(covar)
                    line = line + 1 ;
                    covariable = strrep(covar{j},'.','__') ;
                    map{line} = [current_branch,'__',object_name,'(',covariable,')'] ;
                end
            end
            
            if ~isempty(outbond)
                covariables = mttGetCovariables(env,outbond.domain,outbond.domain_item) ;
                
                if outbond.effort
                    covar = covariables.effort ;
                elseif ~outbond.flow
                    covar = covariables.flow ;
                end
                
                for j = 1:length(covar)
                    line = line + 1 ;
                    covariable = strrep(covar{j},'.','__') ;
                    map{line} = [current_branch,'__',object_name,'(',covariable,')'] ;
                end
            end
        end
        
        additional_map = [] ;
        if ~isempty(object.abg)
            additional_map = map_system_invars(object,root,next_branch,env) ;
        end
        
        if isempty(map)
            map = additional_map ;
        else
            line = length(map) ;
            for j = 1:length(additional_map)
                if ~ismember(additional_map{j},map)
                    line = line + 1 ;
                    map{line} = additional_map{j} ;
                end
            end
        end
    end
    
    
function map = map_system_outvars(model,root,branch,env)
    is_root_model = nargin==1 ;
    
    if is_root_model
        mttNotify('...mapping system outputs (output covariables)') ;
        mttWriteNewLine ;
        
        root = model ;
        current_branch = mttDetachText(model.source,'/') ;
        env = model.env ;
    else
        current_branch = branch ;
    end

    map = [] ;
    line = 0 ;
    
    objects = mttGetFieldNames(model,'obj') ;
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        next_branch = [current_branch,'__',object_name] ;
        
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
                
                for j = 1:length(covar)
                    line = line + 1 ;
                    covariable = strrep(covar{j},'.','__') ;
                    map{line} = [current_branch,'__',object_name,'(',covariable,')'] ;
                end
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
                
                for j = 1:length(covar)
                    line = line + 1 ;
                    covariable = strrep(covar{j},'.','__') ;
                    map{line} = [current_branch,'__',object_name,'(',covariable,')'] ;
                end
            end
        end
        
        additional_map = [] ;
        if ~isempty(object.abg)
            additional_map = map_system_outvars(object,root,next_branch,env) ;
        end
        
        if isempty(map)
            map = additional_map ;
        else
            line = length(map) ;
            for j = 1:length(additional_map)
                if ~ismember(additional_map{j},map)
                    line = line + 1 ;
                    map{line} = additional_map{j} ;
                end
            end
        end
    end
    