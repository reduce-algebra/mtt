function mttWriteSystemMapping(model)

sympar = map_system_sympars(model) ;
input  = map_system_inputs(model) ;
invar  = map_system_invars(model) ;
outvar = map_system_outvars(model) ;
state  = map_system_states(model) ;

derivative = differentiate(state) ;

mapping.input = invar ;
if ~isempty(input)
    mapping.input = [mapping.input,input] ;
end
if ~isempty(sympar)
    mapping.input = [mapping.input,sympar] ;
end

mapping.output = outvar ;
mapping.state  = state ;
mapping.derivative = derivative ;

write_get_input(mapping,model) ;
write_get_state(mapping,model) ;

write_put_input(mapping,model) ;
write_put_state(mapping,model) ;
write_put_output(mapping,model) ;
write_put_derivative(mapping,model) ;



function map = map_system_sympars(model)
	mttNotify('...mapping system inputs (symbolic parameters)') ;
    mttWriteNewLine ;

    model_name = mttDetachText(model.source,'/') ;
    
    map = [] ;
    line = 0 ;
    
    number_of_variables = mttGetFieldLength(model,'sympar') ;
    
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
                    map{line} = [current_branch,'__',object_name,'.',strrep(covar{j},'.','__')] ;
                end
            end
            
            if ~isempty(outbond)
                covariables = mttGetCovariables(env,outbond.domain,outbond.domain_item) ;
                covar = [] ;
                
                if outbond.effort
                    covar = covariables.effort ;
                elseif ~outbond.flow
                    covar = covariables.flow ;
                end
                
                for j = 1:length(covar)
                    line = line + 1 ;
                    map{line} = [current_branch,'__',object_name,'.',strrep(covar{j},'.','__')] ;
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
                    map{line} = [current_branch,'__',object_name,'.',strrep(covar{j},'.','__')] ;
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
                    map{line} = [current_branch,'__',object_name,'.',strrep(covar{j},'.','__')] ;
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
    
    
function map = map_system_states(model,root,branch,env)
    is_root_model = nargin==1 ;
    
    if is_root_model
        mttNotify('...mapping system states') ;
        mttWriteNewLine ;
        
        root = model ;
        current_branch = mttDetachText(model.source,'/') ;
        env = model.env ;
    else
        current_branch = branch ;
    end
    
    map = [] ;
    line = 0 ;
    
    if isfield(model,'state')
        assigned_states = [] ;
        counter = 0 ;
        
        port_names = mttGetFieldNames(model.interface,'port') ;
        for j = 1:length(port_names)
            port_name = port_names{j} ;
            port = getfield(model,'interface','port',port_name) ;
            
            if ~isempty(port.assign)
                assignment = port.assign ;
                
                if port.was_generic & ~isempty(port.domain)
                    covariables = mttGetCovariables(env,port.domain,port.domain_item) ;
                    if port.is_effort_state
                        covar = covariables.effort ;
                    else
                        covar = covariables.flow ;
                    end
                    
                    block_size = length(covar) ;
                    for k = 1:length(assignment.state)
                        counter = counter + 1 ;
                        assigned_states{counter} = assignment.state{k} ;
                        
                        for var = 1:block_size
                            line = line + 1 ;
                            map{line} = [current_branch,'___',assignment.state{k},'___',covar{var},'.state'] ;
                        end                        
                    end
                end
            end
        end
        
        number_of_variables = mttGetFieldLength(model,'state') ;
        
        for i = 1:number_of_variables
            variable_name = model.state{i} ;
            
            if ~ismember(variable_name,assigned_states)
                line = line + 1 ;
                map{line} = [current_branch,'___',variable_name,'.state'] ;
            end
        end
    end
    
    
    objects = mttGetFieldNames(model,'obj') ;
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        next_branch = [current_branch,'__',object_name] ;
        
        additional_map = [] ;
        if ~isempty(object.abg)
            additional_map = map_system_states(object,root,next_branch,env) ;
        elseif ~isempty(object.cr)
            additional_map = map_system_states(object.cr,root,next_branch,env) ;
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
    
    
function derivative = differentiate(state)
    mttNotify('...mapping system derivatives') ;
    mttWriteNewLine ;
    
    for i = 1:length(state)
        derivative{i} = strrep(state{i},'.state','.derivative') ;
    end
    
    
function write_get_input(mapping,model)
    filename = [model.source,'_include_get_input.h'] ;
    fid = fopen(filename,'w') ;
    
    mttNotify(['...creating ',filename]) ;
    mttWriteNewLine ;
    
    fprintf(fid,['// Input get-mapping for Ordinary Differential Equations\n']) ;
    fprintf(fid,'\n') ;
    fprintf(fid,['// file: ',filename,'\n']) ;
    fprintf(fid,['// written by MTT on ',datestr(now),'\n']) ;
    
    model_name = mttDetachText(model.source,'/') ;
    
    write_mapping(fid,'_mttInput',mapping.input,model_name,1) ;
   
    fclose(fid) ;
    
    
function write_put_input(mapping,model)
    filename = [model.source,'_include_put_input.h'] ;
    fid = fopen(filename,'w') ;
    
    mttNotify(['...creating ',filename]) ;
    mttWriteNewLine ;
    
    fprintf(fid,['// Input put-mapping for Ordinary Differential Equations\n']) ;
    fprintf(fid,'\n') ;
    fprintf(fid,['// file: ',filename,'\n']) ;
    fprintf(fid,['// written by MTT on ',datestr(now),'\n']) ;
    
    model_name = mttDetachText(model.source,'/') ;
    
    write_mapping(fid,'_mttInput',mapping.input,model_name,0) ;
   
    fclose(fid) ;
    
    
function write_get_state(mapping,model)
    filename = [model.source,'_include_get_state.h'] ;
    fid = fopen(filename,'w') ;
    
    mttNotify(['...creating ',filename]) ;
    mttWriteNewLine ;
    
    fprintf(fid,['// State get-mapping for Ordinary Differential Equations\n']) ;
    fprintf(fid,'\n') ;
    fprintf(fid,['// file: ',filename,'\n']) ;
    fprintf(fid,['// written by MTT on ',datestr(now),'\n']) ;
    
    model_name = mttDetachText(model.source,'/') ;
    
    write_mapping(fid,'_mttState',mapping.state,model_name,1) ;
   
    fclose(fid) ;
    
    
function write_put_state(mapping,model)
    filename = [model.source,'_include_put_state.h'] ;
    fid = fopen(filename,'w') ;
    
    mttNotify(['...creating ',filename]) ;
    mttWriteNewLine ;
    
    fprintf(fid,['// State put-mapping for Ordinary Differential Equations\n']) ;
    fprintf(fid,'\n') ;
    fprintf(fid,['// file: ',filename,'\n']) ;
    fprintf(fid,['// written by MTT on ',datestr(now),'\n']) ;
    
    model_name = mttDetachText(model.source,'/') ;
    
    write_mapping(fid,'_mttState',mapping.state,model_name,0) ;
   
    fclose(fid) ;
    
    
function write_put_output(mapping,model)
    filename = [model.source,'_include_put_output.h'] ;
    fid = fopen(filename,'w') ;
    
    mttNotify(['...creating ',filename]) ;
    mttWriteNewLine ;
    
    fprintf(fid,['// Output put-mapping for Ordinary Differential Equations\n']) ;
    fprintf(fid,'\n') ;
    fprintf(fid,['// file: ',filename,'\n']) ;
    fprintf(fid,['// written by MTT on ',datestr(now),'\n']) ;
    
    model_name = mttDetachText(model.source,'/') ;
    
    write_mapping(fid,'_mttOutput',mapping.output,model_name,0) ;
   
    fclose(fid) ;
    
    
function write_put_derivative(mapping,model)
    filename = [model.source,'_include_put_derivative.h'] ;
    fid = fopen(filename,'w') ;
    
    mttNotify(['...creating ',filename]) ;
    mttWriteNewLine ;
    
    fprintf(fid,['// Derivative put-mapping for Ordinary Differential Equations\n']) ;
    fprintf(fid,'\n') ;
    fprintf(fid,['// file: ',filename,'\n']) ;
    fprintf(fid,['// written by MTT on ',datestr(now),'\n']) ;
    
    model_name = mttDetachText(model.source,'/') ;
    
    write_mapping(fid,'_mttDerivative',mapping.derivative,model_name,0) ;
   
    fclose(fid) ;
    
    
function write_mapping(fid,array_name,var_list,model_name,is_inward_mapping)
    if ~isempty(var_list)
        var_list = sort(var_list) ;
        
        width = 0 ;
        for i = 1:length(var_list)
            width = max(width,length(var_list{i})) ;
        end
    
        tab = char(32*ones(1,3)) ;
        
        fprintf(fid,'\n') ;
        for i = 1:length(var_list)
            variable = var_list{i} ;
            
            if is_inward_mapping
                nominal_width = width ;
                actual_width = length(variable) ;
                
                gap = nominal_width - actual_width ;
                whitespace = char(32*ones(1,gap)) ;
                
                formatted_mapping = [tab,variable,whitespace,' = ',array_name,'[',num2str(i-1),'] ;\n'] ;
            else
                formatted_mapping = [tab,array_name,'[',num2str(i-1),'] = ',variable,' ;\n'] ;
            end
                
            fprintf(fid,formatted_mapping) ;
        end        
    end
