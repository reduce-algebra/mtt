function model = mttCreateEnvironment(context)
global mtt_env

mttNotify('...setting "env" definition') ;
mttWriteNewLine ;

directory_name = identify_directory_name(context) ;
source_name = identify_source_name(context,directory_name) ;
environment_filename = [source_name,'_env.txt'] ;

model = mttFetchEnvironment(environment_filename) ;
model = establish_path_names(model) ;

mttWriteNewLine ;
mttNotify('...acquiring "domain" source definitions') ;
mttWriteNewLine ;

model = establish_user_domains(model) ;

number_of_domains = mttGetFieldLength(model,'dom') ;
if number_of_domains>0
    for i = 1:number_of_domains
        model.public_domain(i).representation = model.dom(i).representation ;
        model.public_domain(i).source = model.dom(i).source ;
        
        domain = model.dom(i) ;
        item_names = mttGetFieldNames(domain,'item') ;
        for j = 1:length(item_names)
            item_name = item_names{j} ;
            item = getfield(domain,'item',item_name) ;
            
            compound_item = mttIdentifyDomainCovariables(item,domain,model) ;
            model = setfield(model,'public_domain',{i},'item',item_name,compound_item) ;
        end
    end
    model = hide_private_domains(model) ;
end

model = mttDeleteField(model,'dom') ;


mttWriteNewLine ;
mttNotify('...acquiring "struct" source definitions') ;
mttWriteNewLine ;

model = establish_user_structs(model) ;

number_of_structs = mttGetFieldLength(model,'str') ;
if number_of_structs>0
    for i = 1:number_of_structs
        model.public_struct(i).representation = model.str(i).representation ;
        model.public_struct(i).source = model.str(i).source ;
        
        struct = model.str(i) ;
        item_names = mttGetFieldNames(struct,'item') ;
        for j = 1:length(item_names)
            item_name = item_names{j} ;
            item = getfield(struct,'item',item_name) ;
            
            compound_item = mttIdentifyStructVariables(item,struct,model) ;
            model = setfield(model,'public_struct',{i},'item',item_name,compound_item) ;
        end
    end
    model = hide_private_structs(model) ;
end

model = mttDeleteField(model,'str') ;



function directory = identify_directory_name(context)
    mttAssert(ischar(context),'Context must be specified by name') ;
    working_directory  = pwd ;
    working_directory = strrep(working_directory,'\','/') ;
    
    [system_name,local_directory] = mttDetachText(context,'/') ;
    if isempty(system_name)
        local_directory = [] ;
    end
    
    if isempty(local_directory)
        directory = working_directory ;
    else
        directory = mttLocateDirectory(working_directory,local_directory) ;
    end
    
    
function source = identify_source_name(context,directory)
    [context_name,local_directory] = mttDetachText(context,'/') ;
    if isempty(context_name)
        context_name = context ;
        local_directory = [] ;
    end
    source = [directory,'/',context_name] ;
    
    
function model = establish_path_names(model)
	path_names = mttGetFieldNames(model,'path') ;
    
    for n = 1:length(path_names)
        path_name = path_names{n} ;
        path_spec = getfield(model,'path',path_name) ;
        
        [rubbish,working_directory] = mttDetachText(model.source,'/') ;
        
        directory = identify_directory(working_directory,path_spec,model) ;
        
        mttAssert(~isempty(directory),...
            ['Undefined path "',path_name,'"']) ;
        
		model = setfield(model,'path',path_name,directory) ;
    end
    
    
function directory = identify_directory(working_directory,path_spec,model)
	path_names = mttGetFieldNames(model,'path') ;

    if isempty(path_spec)
		directory = [] ;
    else
        if path_spec(1)=='$'
            [path_alias,path_branch] = mttCutText(path_spec,'/') ;
            path_alias(1) = [] ;
            
            mttAssert(ismember(path_alias,path_names),...
                ['Path "',path_alias,'" not recognised']) ;
            
            path_root = getfield(model,'path',path_alias) ;
            
            if isempty(path_branch)
                directory = path_root ;
            else
                directory = [path_root,'/',path_branch] ;
            end
        else
            [local_directory,name] = mttCutText(path_spec,'/') ;
            
            directory_located = 0 ;
            if strcmp(local_directory,'.')
                if isempty(name)
                    directory = working_directory ;
                    directory_located = 1 ;
                else
                    local_directory = name ;
                end
            else
                local_directory = path_spec ;
            end
            
            if ~directory_located
                directory = mttLocateDirectory(working_directory,local_directory) ;
            end
        end
    end
    
    
function model = establish_user_domains(model)
	path_names = mttGetFieldNames(model,'path') ;
    domain_names = mttGetFieldNames(model,'domain') ;
    
    counter = 0 ; 
    
    for n = 1:length(domain_names)
        domain_name = domain_names{n} ;
        domain_spec = getfield(model,'domain',domain_name) ;
        
        [rubbish,working_directory] = mttDetachText(model.source,'/') ;
        [domain_source,domain_item] = mttCutText(domain_spec,'::') ;
        [name,path_spec] = mttDetachText(domain_source,'/') ;
        
        if isempty(name)
            source_name = [working_directory,'/',domain_source] ;
        else
            directory = identify_directory(working_directory,path_spec,model) ;
            source_name = [directory,'/',name] ;
        end
        
        domain_filename = [source_name,'_domain.txt'] ;
        
        domain_index = [] ;
        if isfield(model,'dom')
            existing_doms = {model.dom.source} ;
            domain_index = strmatch(source_name,existing_doms,'exact') ;
        end
        
        if isempty(domain_index)
            counter = counter + 1 ;
            model.dom(counter) = mttFetchDomain(domain_filename) ;
            domain_index = counter ;
        end
        
        domain_spec.dom = domain_index ;
        domain_spec.item = domain_item ;
        model = setfield(model,'domain',domain_name,domain_spec) ;
    end
    
function model = hide_private_domains(model)
	for n = 1:mttGetFieldLength(model,'public_domain')
        dom = model.dom(n) ;
        dom_items = dom.item ;
        
        domain = model.public_domain(n) ;
        domain_items = domain.item ;
        
        item_names = mttGetFieldNames(domain,'item') ;
        
        for j = 1:length(item_names)
            item_name = item_names{j} ;
            is_private(j) = getfield(dom_items,item_name,'is_private') ;
            
            if is_private(j)
                domain_items = mttDeleteField(domain_items,item_name) ;
                
                mttAssert(~isempty(domain_items),...
                    ['No public domains in ',dom.source]) ;
            end
        end
        
        model = setfield(model,'public_domain',{n},'item',domain_items) ;
    end
    
	user_domain_names = mttGetFieldNames(model,'domain') ;
    for i = 1:length(user_domain_names)
        user_domain_name = user_domain_names{i} ;
        user_domain = getfield(model,'domain',user_domain_name) ;
        
        dom = model.dom(user_domain.dom) ;
        if ~isempty(user_domain.item)
            is_private = getfield(dom,'item',user_domain.item,'is_private') ;
            mttAssert(~is_private,...
                ['User-defined domain "',user_domain_name,'" is declared as private']) ;
        end
    end
    
    
function model = establish_user_structs(model)
	path_names = mttGetFieldNames(model,'path') ;
    struct_names = mttGetFieldNames(model,'struct') ;
    
    counter = 0 ; 
    
    for n = 1:length(struct_names)
        struct_name = struct_names{n} ;
        struct_spec = getfield(model,'struct',struct_name) ;
        
        [rubbish,working_directory] = mttDetachText(model.source,'/') ;
        [struct_source,struct_item] = mttCutText(struct_spec,'::') ;
        [name,path_spec] = mttDetachText(struct_source,'/') ;
        
        if isempty(name)
            source_name = [working_directory,'/',struct_source] ;
        else
            directory = identify_directory(working_directory,path_spec,model) ;
            source_name = [directory,'/',name] ;
        end
        
        struct_filename = [source_name,'_struct.txt'] ;
        
        struct_index = [] ;
        if isfield(model,'str')
            existing_strs = {model.str.source} ;
            struct_index = strmatch(source_name,existing_strs,'exact') ;
        end
        
        if isempty(struct_index)
            counter = counter + 1 ;
            model.str(counter) = mttFetchStruct(struct_filename) ;
            struct_index = counter ;
        end
        
        struct_spec.str = struct_index ;
        struct_spec.item = struct_item ;
        model = setfield(model,'struct',struct_name,struct_spec) ;
    end
    
function model = hide_private_structs(model)
	for n = 1:mttGetFieldLength(model,'public_struct')
        str = model.str(n) ;
        str_items = str.item ;
        
        struct = model.public_struct(n) ;
        struct_items = struct.item ;
        
        item_names = mttGetFieldNames(struct,'item') ;
        
        for j = 1:length(item_names)
            item_name = item_names{j} ;
            is_private(j) = getfield(str_items,item_name,'is_private') ;
            
            if is_private(j)
                struct_items = mttDeleteField(struct_items,item_name) ;
                
                mttAssert(~isempty(struct_items),...
                    ['No public structs in ',str.source]) ;
            end
        end
        
        model = setfield(model,'public_struct',{n},'item',struct_items) ;
    end
    
	user_struct_names = mttGetFieldNames(model,'struct') ;
    for i = 1:length(user_struct_names)
        user_struct_name = user_struct_names{i} ;
        user_struct = getfield(model,'struct',user_struct_name) ;
        
        str = model.str(user_struct.str) ;
        if ~isempty(user_struct.item)
            is_private = getfield(str,'item',user_struct.item,'is_private') ;
            mttAssert(~is_private,...
                ['User-defined struct "',user_struct_name,'" is declared as private']) ;
        end
    end
        