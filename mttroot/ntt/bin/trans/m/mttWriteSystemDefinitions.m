function mttWriteSystemDefinitions(model)

def.structure = define_data_structures(model) ;
def.covar     = define_bond_covariables(model) ;
def.var       = define_interface_covariables(model) ;
def.sympar    = define_symbolic_parameters(model) ;
def.numpar    = define_numerical_parameters(model) ;
def.input     = define_input_variables(model) ;
def.state     = define_state_variables(model) ;
def.opvar     = define_operator_variables(model) ;

write_definitions(def,model) ;


function code = define_data_structures(model)
    mttNotify('...defining data structures') ;
    mttWriteNewLine ;
    
    code = [] ;
    line = 0 ;
    
    tab = char(32*ones(1,3)) ;
    
    line = line + 1 ;
    code{line} = ['typedef struct {'] ;
    
    line = line + 1 ;
    code{line} = [tab,'double state,derivative ;'] ;
    
    line = line + 1 ;
    code{line} = ['} mttState ;'] ;
    
    line = line + 1 ;
    code{line} = '' ;
    
    line = line + 1 ;
    code{line} = ['typedef struct {'] ;
    
    line = line + 1 ;
    code{line} = [tab,'double effort,flow ;'] ;
    
    line = line + 1 ;
    code{line} = ['} mttGenericDomain ;'] ;
    
    line = line + 1 ;
    code{line} = '' ;
    
    domain_names = mttGetFieldNames(model.env,'domain') ;
    for i = 1:length(domain_names)
        domain_name = domain_names{i} ;
        domain = getfield(model.env,'domain',domain_name) ;
        
        public_domain = model.env.public_domain(domain.dom) ;
        item_names = mttGetFieldNames(public_domain,'item') ;
        
        if isempty(domain.item)
            first = 1 ;
            last = length(item_names) ;
        else
            first = strmatch(domain.item,item_names,'exact') ;
            last = first ;
        end
        
        for j = first:last
            item_name = item_names{j} ;
            covariables = getfield(public_domain,'item',item_name) ;
            
            line = line + 1 ;
            code{line} = ['typedef struct {'] ;
            
            for k = 1:length(covariables.effort)
                line = line + 1 ;
                effort_covariable = strrep(covariables.effort{k},'.','__') ;
                flow_covariable = strrep(covariables.flow{k},'.','__') ;
                code{line} = [tab,'double ',effort_covariable,',',flow_covariable,' ;'] ;
            end
            
            definition = ['} mttDomain__',domain_name] ;
            if isempty(domain.item)
                definition = [definition,'__',item_name] ;
            end
            definition = [definition,' ;'] ;
            
            line = line + 1 ;
            code{line} = definition ;
            
            if j<last
                line = line + 1 ;
                code{line} = '' ;
            end
        end
        
        line = line + 1 ;
        code{line} = '' ;
    end

    struct_names = mttGetFieldNames(model.env,'struct') ;
    for i = 1:length(struct_names)
        struct_name = struct_names{i} ;
        struct = getfield(model.env,'struct',struct_name) ;
        
        public_struct = model.env.public_struct(struct.str) ;
        item_names = mttGetFieldNames(public_struct,'item') ;
        
        index = strmatch(struct.item,item_names,'exact') ;
        
        item_name = item_names{index} ;
        variables = getfield(public_struct,'item',item_name,'var') ;
        
        line = line + 1 ;
        code{line} = ['typedef struct {'] ;
        
        for k = 1:length(variables)
            line = line + 1 ;
            variable = strrep(variables{k},'.','__') ;
            code{line} = [tab,'double ',variable,' ;'] ;
        end
        
        definition = ['} ',struct_name,' ;'] ;
        
        line = line + 1 ;
        code{line} = definition ;
        
        if i<length(struct_names)
            line = line + 1 ;
            code{line} = '' ;
        end
    end


function code = define_bond_covariables(model,root,branch)
    is_root_model = nargin==1 ;
    
    if is_root_model
        mttNotify('...defining bond covariables') ;
        mttWriteNewLine ;
        
        root = model ;
        current_branch = mttDetachText(model.source,'/') ;
    else
        current_branch = branch ;
    end
    
    width = 0 ;
    domain_names = mttGetFieldNames(root.env,'domain') ;
    for j = 1:length(domain_names)
        domain_name = domain_names{j} ;
        width = max(width,length(domain_name)) ;
    end
    
    code = [] ;
    line = 0 ;
    
    number_of_bonds = mttGetFieldLength(model,'bond') ;
    for i = 1:number_of_bonds
        current_bond = model.bond(i) ;
        
        specified_domain = current_bond.domain ;
        specified_domain_item = current_bond.domain_item ;
        
        user_domain_identification = mttIdentifyUserDomain(root.env,specified_domain,specified_domain_item) ;
        
        if isempty(user_domain_identification)
            data_structure = ['mttGenericDomain'] ;
        else
            data_structure = ['mttDomain__',user_domain_identification] ;
        end
        
        nominal_width = 14 + width ;
        actual_width = length(data_structure) ;
        gap = nominal_width - actual_width ;
        
        whitespace = char(32*ones(1,gap+3)) ;
        
        line = line + 1 ;
        code{line} = [data_structure,whitespace,current_branch,'__',num2str(i),' ;'] ;
    end
    
    objects = mttGetFieldNames(model,'obj') ;
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        if ~isempty(object.abg)
            next_branch = [current_branch,'__',object_name] ;
            additional_code = define_bond_covariables(object,root,next_branch) ;
            
            if isempty(code)
                code = additional_code ;
            else
                code = [code,additional_code] ;
            end
        end
    end
    
    if line==0
        code = [] ;
    end
    
    
function code = define_interface_covariables(model)
	mttNotify('...defining interface covariables') ;
    mttWriteNewLine ;
    
    width = 0 ;
    domain_names = mttGetFieldNames(model.env,'domain') ;
    for j = 1:length(domain_names)
        domain_name = domain_names{j} ;
        width = max(width,length(domain_name)) ;
    end
    
    code = [] ;
    line = 0 ;
    
    previous_name = model.namelist(1).var ;
    
    number_of_variables = mttGetFieldLength(model,'namelist') ;
    for i = 2:number_of_variables   % .... first variable is reserved !
        variable_name = model.namelist(i).var ;
        [variable_name,extension] = mttCutText(variable_name,'.') ;

        if ~strcmp(variable_name,previous_name)
            previous_name = variable_name ;
            
            specified_domain = model.namelist(i).domain ;
            specified_domain_item = model.namelist(i).domain_item ;
            
            user_domain_identification = mttIdentifyUserDomain(model.env,specified_domain,specified_domain_item) ;

            if isempty(user_domain_identification)
                data_structure = ['mttGenericDomain'] ;
            else
                data_structure = ['mttDomain__',user_domain_identification] ;
            end
            
            nominal_width = 14 + width ;
            actual_width = length(data_structure) ;
            gap = nominal_width - actual_width ;
            
            whitespace = char(32*ones(1,gap+3)) ;
            
            line = line + 1 ;
            code{line} = [data_structure,whitespace,variable_name,' ;'] ;
        end
    end
    

function code = define_symbolic_parameters(model)
	mttNotify('...defining symbolic parameters') ;
    mttWriteNewLine ;

    model_name = mttDetachText(model.source,'/') ;
    
    code = [] ;
    line = 0 ;
    
    number_of_variables = mttGetFieldLength(model,'sympar') ;
    for i = 1:number_of_variables
        variable_name = model.sympar{i} ;
        default_value = model.sympar_default{i} ;
        
        whitespace = char(32*ones(1,3)) ;
        
        if isempty(default_value)
            line = line + 1 ;
            code{line} = ['double',whitespace,model_name,'___',variable_name,' ;'] ;
        end
    end
    
    
function code = define_numerical_parameters(model,root,branch)
    is_root_model = nargin==1 ;
    
    if is_root_model
        mttNotify('...defining numerical parameters') ;
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
        
        whitespace = char(32*ones(1,3)) ;
        
        line = line + 1 ;
        code{line} = ['double',whitespace,current_branch,'___',variable_name,' ;'] ;
    end
    
    objects = mttGetFieldNames(model,'obj') ;
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        next_branch = [current_branch,'__',object_name] ;
        
        additional_code = [] ;
        if ~isempty(object.abg)
            additional_code = define_numerical_parameters(object,root,next_branch) ;
        elseif ~isempty(object.cr)
            additional_code = define_numerical_parameters(object.cr,root,next_branch) ;
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
    
    
function code = define_input_variables(model,root,branch)
    is_root_model = nargin==1 ;
    
    if is_root_model
        mttNotify('...defining input variables') ;
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
        
        whitespace = char(32*ones(1,3)) ;
        
        line = line + 1 ;
        code{line} = ['double',whitespace,current_branch,'___',variable_name,' ;'] ;
    end
    
    objects = mttGetFieldNames(model,'obj') ;
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        next_branch = [current_branch,'__',object_name] ;
        
        additional_code = [] ;
        if ~isempty(object.abg)
            additional_code = define_input_variables(object,root,next_branch) ;
        elseif ~isempty(object.cr)
            additional_code = define_input_variables(object.cr,root,next_branch) ;
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
    
    
function code = define_state_variables(model,root,branch,env)
    is_root_model = nargin==1 ;
    
    if is_root_model
        mttNotify('...defining state variables') ;
        mttWriteNewLine ;
        
        root = model ;
        current_branch = mttDetachText(model.source,'/') ;
        env = model.env ;
    else
        current_branch = branch ;
    end
    
    whitespace = char(32*ones(1,3)) ;
        
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
                    else
                        covar = covariables.flow ;
                    end
                    
                    block_size = length(covar) ;
                    for k = 1:length(assignment.state)
                        counter = counter + 1 ;
                        assigned_states{counter} = assignment.state{k} ;
                        
                        for var = 1:block_size
                            line = line + 1 ;
                            code{line} = ['mttState',whitespace,current_branch,'___',assignment.state{k},'___',covar{var},' ;'] ;
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
                code{line} = ['mttState',whitespace,current_branch,'___',variable_name,' ;'] ;
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
            additional_code = define_state_variables(object,root,next_branch,env) ;
        elseif ~isempty(object.cr)
            additional_code = define_state_variables(object.cr,root,next_branch,env) ;
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
 
    
function code = define_operator_variables(model,root,branch)
    is_root_model = nargin==1 ;
    
    if is_root_model
        mttNotify('...defining operator variables') ;
        mttWriteNewLine ;
        
        root = model ;
        current_branch = mttDetachText(model.source,'/') ;
    else
        current_branch = branch ;
    end
    
    code = [] ;
    
    objects = mttGetFieldNames(model,'obj') ;
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        next_branch = [current_branch,'__',object_name] ;
        
        if ~isempty(object.abg)
            additional_code = define_operator_variables(object,root,next_branch) ;
        elseif ~isempty(object.cr)
            line = 0 ;
            additional_code = [] ;
            
            number_of_operators = mttGetFieldLength(object.cr,'operator') ;
            for j = 1:number_of_operators
                operator = object.cr.operator(j) ;
                
                number_of_vars = mttGetFieldLength(operator,'var') ;
                for k = 1:number_of_vars
                    variable_name = operator.var{k} ;
                    
                    whitespace = char(32*ones(1,3)) ;
                    
                    line = line + 1 ;
                    prefix = [next_branch,'___',operator.name] ;
                    additional_code{line} = ['double',whitespace,prefix,'___',variable_name,'      = 0.0 ;'] ;
                end
                
                struct_names = mttGetFieldNames(operator,'struct') ;
                number_of_structs = length(struct_names) ;
                for k = 1:number_of_structs
                    struct_name = struct_names{k} ;
                    variables = getfield(operator,'struct',struct_name) ;
                    
                    for kv = 1:length(variables)
                        variable_name = variables{kv} ;
                        
                        whitespace = char(32*ones(1,3)) ;
                        
                        line = line + 1 ;
                        prefix = [next_branch,'___',operator.name] ;
                        additional_code{line} = [struct_name,whitespace,prefix,'___',variable_name,' ;'] ;
                    end
                end
            end
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
    
    
function write_definitions(def,model)
    filename = [model.source,'_include_def.h'] ;
    fid = fopen(filename,'w') ;
    
    mttNotify(['...creating ',filename]) ;
    mttWriteNewLine ;
    
    fprintf(fid,['// Definitions for Ordinary Differential Equations\n']) ;
    fprintf(fid,'\n') ;
    fprintf(fid,['// file: ',filename,'\n']) ;
    fprintf(fid,['// written by MTT on ',datestr(now),'\n']) ;
    
    write_definitive_list(fid,'data_structures',def.structure) ;
    write_definitive_list(fid,'bond_covariables',def.covar) ;
    write_definitive_list(fid,'interface_covariables',def.var) ;
    write_definitive_list(fid,'symbolic_parameters',def.sympar) ;
    write_definitive_list(fid,'numerical_parameters',def.numpar) ;
    write_definitive_list(fid,'input_variables',def.input) ;
    write_definitive_list(fid,'state_variables',def.state) ;
    write_definitive_list(fid,'operator_variables',def.opvar) ;
   
    fclose(fid) ;
    
    
function write_definitive_list(fid,var_type,var_list)
    if ~isempty(var_list)
        fprintf(fid,'\n\n') ;
        fprintf(fid,['// ',var_type]) ;
        fprintf(fid,'\n') ;
        
        tab = char(32*ones(1,3)) ;
        for i = 1:length(var_list)
            formatted_declaration = [tab,var_list{i},'\n'] ;
            fprintf(fid,formatted_declaration) ;
        end
    end
