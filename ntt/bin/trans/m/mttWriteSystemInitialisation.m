function mttWriteSystemInitialisation(model)

assignment.numpar = assign_numerical_parameters(model) ;
assignment.sympar = assign_symbolic_parameters(model) ;
assignment.input  = assign_input_variables(model) ;
assignment.invar  = assign_input_covariables(model) ;
assignment.state  = assign_state_variables(model) ;

write_set_numpar(assignment,model) ;
write_set_input(assignment,model) ;
write_set_state(assignment,model) ;



function code = assign_symbolic_parameters(model)
	mttNotify('...assigning symbolic parameters') ;
    mttWriteNewLine ;
    
    model_name = mttDetachText(model.source,'/') ;
    
    code = [] ;
    line = 0 ;
    
    number_of_variables = mttGetFieldLength(model,'sympar') ;
    
    for i = 1:number_of_variables
        variable_name = model.sympar{i} ;
        default = model.sympar_default{i} ;
        
        if isempty(default)
            line = line + 1 ;
            code{line} = [model_name,'___',variable_name,' = 1.0 ;'] ;
        else
            line = line + 1 ;
            code{line} = [model_name,'___',variable_name,' = ',default,' ;'] ;
        end
    end
    
    
function code = assign_numerical_parameters(model,root,branch)
    is_root_model = nargin==1 ;
    
    if is_root_model
        mttNotify('...assigning numerical parameters') ;
        mttWriteNewLine ;
        
        root = model ;
        current_branch = mttDetachText(model.source,'/') ;
    else
        current_branch = branch ;
    end
    
    code = [] ;
    line = 0 ;
    
    number_of_variables = mttGetFieldLength(model,'numpar') ;
	    
    for i = 1:number_of_variables
        variable_name = model.numpar{i} ;
        default = model.numpar_default{i} ;
        
        line = line + 1 ;
        if isempty(default)
            code{line} = [current_branch,'___',variable_name,' = 1.0 ;'] ;
        else
            code{line} = [current_branch,'___',variable_name,' = ',default,' ;'] ;
        end
    end
    
    objects = mttGetFieldNames(model,'obj') ;
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        next_branch = [current_branch,'__',object_name] ;
        
        additional_code = [] ;
        if ~isempty(object.abg)
            additional_code = assign_numerical_parameters(object,root,next_branch) ;
        elseif ~isempty(object.cr)
            additional_code = assign_numerical_parameters(object.cr,root,next_branch) ;
        end
        
        if isempty(code)
            code = additional_code ;
        else
            line = length(code) ;
            for j = 1:length(additional_code)
                if ~ismember(additional_code{j},code)
                    line = line + 1 ;
                    code{line} = additional_code{j} ;
                end
            end
        end
    end
    
    
function code = assign_input_variables(model,root,branch)
    is_root_model = nargin==1 ;
    
    if is_root_model
        mttNotify('...assigning input variables') ;
        mttWriteNewLine ;
        
        root = model ;
        current_branch = mttDetachText(model.source,'/') ;
    else
        current_branch = branch ;
    end

    code = [] ;
    line = 0 ;
    
    number_of_variables = mttGetFieldLength(model,'input') ;
    
    for i = 1:number_of_variables
        variable_name = model.input{i} ;
        default = model.input_default{i} ;
        
        line = line + 1 ;
        if isempty(default)
            code{line} = [current_branch,'___',variable_name,' = 0.0 ;'] ;
        else
            code{line} = [current_branch,'___',variable_name,' = ',default,' ;'] ;
        end
    end
    
    objects = mttGetFieldNames(model,'obj') ;
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        next_branch = [current_branch,'__',object_name] ;
        
        additional_code = [] ;
        if ~isempty(object.abg)
            additional_code = assign_input_variables(object,root,next_branch) ;
        elseif ~isempty(object.cr)
            additional_code = assign_input_variables(object.cr,root,next_branch) ;
        end
        
        if isempty(code)
            code = additional_code ;
        else
            line = length(code) ;
            for j = 1:length(additional_code)
                if ~ismember(additional_code{j},code)
                    line = line + 1 ;
                    code{line} = additional_code{j} ;
                end
            end
        end
    end
    
    
function code = assign_input_covariables(model,root,branch,env)
    is_root_model = nargin==1 ;
    
    if is_root_model
        mttNotify('...assigning input covariables') ;
        mttWriteNewLine ;
        
        root = model ;
        current_branch = mttDetachText(model.source,'/') ;
        env = model.env ;
    else
        current_branch = branch ;
    end

    code = [] ;
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
                    code{line} = [current_branch,'__',object_name,'.',covariable,' = 0.0 ;'] ;
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
                    code{line} = [current_branch,'__',object_name,'.',covariable,' = 0.0 ;'] ;
                end
            end
        end
        
        additional_code = [] ;
        if ~isempty(object.abg)
            additional_code = assign_input_covariables(object,root,next_branch,env) ;
        end
        
        if isempty(code)
            code = additional_code ;
        else
            line = length(code) ;
            for j = 1:length(additional_code)
                if ~ismember(additional_code{j},code)
                    line = line + 1 ;
                    code{line} = additional_code{j} ;
                end
            end
        end
    end
    
    
function code = assign_state_variables(model,root,branch,env)
    is_root_model = nargin==1 ;
    
    if is_root_model
        mttNotify('...assigning state variables') ;
        mttWriteNewLine ;
        
        root = model ;
        current_branch = mttDetachText(model.source,'/') ;
        env = model.env ;
    else
        current_branch = branch ;
    end
    
    code = [] ;
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
                        default = covariables.effort_default ;
                    else
                        covar = covariables.flow ;
                        default = covariables.flow_default ;
                    end
                    
                    block_size = length(covar) ;
                    for k = 1:length(assignment.state)
                        counter = counter + 1 ;
                        assigned_states{counter} = assignment.state{k} ;
                        
                        for var = 1:block_size
                            line = line + 1 ;
                            if isempty(default{var})
                                code{line} = [current_branch,'___',assignment.state{k},'___',covar{var},'.state = 0.0 ;'] ;
                            else
                                code{line} = [current_branch,'___',assignment.state{k},'___',covar{var},'.state = ',default{var},' ;'] ;
                            end
                        end                        
                    end
                end
            end
        end
        
        number_of_variables = mttGetFieldLength(model,'state') ;
        
        for i = 1:number_of_variables
            variable_name = model.state{i} ;
            default = model.state_default{i} ;
            
            if ~ismember(variable_name,assigned_states)
                line = line + 1 ;
                if isempty(default)
                    code{line} = [current_branch,'___',variable_name,'.state = 0.0 ;'] ;
                else
                    code{line} = [current_branch,'___',variable_name,'.state = ',default,' ;'] ;
                end
            end
        end
    end
    
    objects = mttGetFieldNames(model,'obj') ;
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        next_branch = [current_branch,'__',object_name] ;
        
        additional_code = [] ;
        if ~isempty(object.abg)
            additional_code = assign_state_variables(object,root,next_branch,env) ;
        elseif ~isempty(object.cr)
            additional_code = assign_state_variables(object.cr,root,next_branch,env) ;
        end
        
        if isempty(code)
            code = additional_code ;
        else
            line = length(code) ;
            for j = 1:length(additional_code)
                if ~ismember(additional_code{j},code)
                    line = line + 1 ;
                    code{line} = additional_code{j} ;
                end
            end
        end
    end
 
    
function write_set_numpar(assignment,model)
    filename = [model.source,'_include_set_numpar.h'] ;
    fid = fopen(filename,'w') ;
    
    mttNotify(['...creating ',filename]) ;
    mttWriteNewLine ;
    
    fprintf(fid,['// Numerical Parameters for Ordinary Differential Equations\n']) ;
    fprintf(fid,'\n') ;
    fprintf(fid,['// file: ',filename,'\n']) ;
    fprintf(fid,['// written by MTT on ',datestr(now),'\n']) ;
    
    model_name = mttDetachText(model.source,'/') ;
    
    write_assigned_list(fid,[],assignment.numpar,model_name) ;
   
    fclose(fid) ;
    
    
function write_set_input(assignment,model)
    filename = [model.source,'_include_set_input.h'] ;
    fid = fopen(filename,'w') ;
    
    mttNotify(['...creating ',filename]) ;
    mttWriteNewLine ;
    
    fprintf(fid,['// Default Inputs for Ordinary Differential Equations\n']) ;
    fprintf(fid,'\n') ;
    fprintf(fid,['// file: ',filename,'\n']) ;
    fprintf(fid,['// written by MTT on ',datestr(now),'\n']) ;
    
    model_name = mttDetachText(model.source,'/') ;
    
    write_assigned_list(fid,'symbolic_parameters',assignment.sympar,model_name) ;
    write_assigned_list(fid,'input_variables',assignment.input,model_name) ;
    write_assigned_list(fid,'input_covariables',assignment.invar,model_name) ;
   
    fclose(fid) ;
    
    
function write_set_state(assignment,model)
    filename = [model.source,'_include_set_state.h'] ;
    fid = fopen(filename,'w') ;
    
    mttNotify(['...creating ',filename]) ;
    mttWriteNewLine ;
    
    fprintf(fid,['// Initial states for Ordinary Differential Equations\n']) ;
    fprintf(fid,'\n') ;
    fprintf(fid,['// file: ',filename,'\n']) ;
    fprintf(fid,['// written by MTT on ',datestr(now),'\n']) ;
    
    model_name = mttDetachText(model.source,'/') ;
    
    write_assigned_list(fid,[],assignment.state,model_name) ;
   
    fclose(fid) ;
    
    
function write_assigned_list(fid,var_type,var_list,model_name)
    if ~isempty(var_list)
        if ~isempty(var_type)
            fprintf(fid,'\n\n') ;
            fprintf(fid,['// ',var_type]) ;
        end
        fprintf(fid,'\n') ;
    
        var_list = sort(var_list) ;
        
        width = 0 ;
        for i = 1:length(var_list)
            [left,right] = mttCutText(var_list{i},'=') ;
            width = max(width,length(left)) ;
        end
    
        tab = char(32*ones(1,3)) ;
        for i = 1:length(var_list)
            [left,right] = mttCutText(var_list{i},'=') ;
            
            nominal_width = width ;
            actual_width = length(left) ;
            
            gap = nominal_width - actual_width ;
            whitespace = char(32*ones(1,gap)) ;
            
            formatted_assignment = [tab,left,whitespace,' = ',right,'\n'] ;
            fprintf(fid,formatted_assignment) ;
        end
    end
