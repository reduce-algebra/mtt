function model = mttCreateCausalBondgraph(model)

model.representation = 'cbg' ;

model = incorporate_interface_definitions(model) ;
model = establish_abg_dependencies(model) ;
model = create_object_hierarchy(model) ;
model = assign_sympar_values(model) ;
model = complete_causal_assignment(model) ;
model = complete_domain_assignment(model) ;
model = overwrite_implicit_domains(model) ;


function model = incorporate_interface_definitions(model)
	mttNotify('...incorporating "cr" definitions') ;
    mttWriteNewLine ;
    
    mttNotify(['   ...processing ',model.source]) ;
    mttWriteNewLine ;
    
    objects = mttGetFieldNames(model,'obj') ;
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        if ~mttIsFoundationClass(object.class)
            mttAssert(xor(isempty(object.abg),isempty(object.cr)),...
                ['"',object_name,'" must exclusively have a "cr" or an "abg" representation']) ;
        end
        
        if isempty(object.cr)
            object = mttDeleteField(object,'cr_item') ;
            model = setfield(model,'obj',object_name,object) ;
        else
            model = mttEmbedInterfaceDefinition(model,object_name) ;
        end
    end
    
    for i = 1:mttGetFieldLength(model,'abg')
        component_type = mttDetachText(model.abg(i).source,'/') ;
        mttNotify(['   ...processing "#',num2str(i),':',component_type,'" ',model.abg(i).source]) ;
        mttWriteNewLine ;
        
        objects = mttGetFieldNames(model.abg(i),'obj') ;
        for j = 1:length(objects)
	        object_name = objects{j} ;
            object = getfield(model,'abg',{i},'obj',object_name) ;
            
    	    if ~mttIsFoundationClass(object.class)
	            mttAssert(xor(isempty(object.abg),isempty(object.cr)),...
        	        ['abg[',num2str(i),']: "',object_name,'" must exclusively have a "cr" or an "abg" representation']) ;
            end
            
            if isempty(object.cr)
                object = mttDeleteField(object,'cr_item') ;
                model = setfield(model,'abg',{i},'obj',object_name,object) ;
            else
                model.abg(i) = mttEmbedInterfaceDefinition(model.abg(i),object_name,model) ;
            end
        end
        model.abg(i).invokes = [] ;
        model.abg(i).invoked_by = [] ;
    end
    model = mttDeleteField(model,'cr') ;
    
    
function model = establish_abg_dependencies(model)
	mttNotify('...establishing "abg" dependencies') ;
    mttWriteNewLine ;
    
    for i = 1:mttGetFieldLength(model,'abg')
        objects = mttGetFieldNames(model.abg(i),'obj') ;
        for j = 1:length(objects)
            object_name = objects{j} ;
            object = getfield(model.abg(i).obj,object_name) ;
            
            if isempty(object.cr)	%... still within object hierarchy
                if ~mttIsFoundationClass(object.class)
                    existing_dependencies = model.abg(i).invokes ;
                    
                    if isempty(existing_dependencies)
                        new_dependency = 1 ;
                    else
                        new_dependency = isempty(find(existing_dependencies==object.abg)) ;
                    end
                    
                    if new_dependency
                        model.abg(i).invokes = [existing_dependencies,object.abg] ;
                    end
                    
                    existing_dependencies = model.abg(object.abg).invoked_by ;
                    if isempty(existing_dependencies)
                        new_dependency = 1 ;
                    else
                        new_dependency = isempty(find(existing_dependencies==i)) ;
                    end
                    
                    if new_dependency
                        model.abg(object.abg).invoked_by = [existing_dependencies,i] ;
                    end
                end
            end
        end
    end
    
    model.invokes = [] ;
    
    objects = mttGetFieldNames(model,'obj') ;
    for j = 1:length(objects)
        object_name = objects{j} ;
        object = getfield(model.obj,object_name) ;
        
        if ~isempty(object.abg)
            if ~mttIsFoundationClass(object.class)
                existing_dependencies = model.invokes ;
                
                if isempty(existing_dependencies)
                    new_dependency = 1 ;
                else
                    new_dependency = isempty(find(existing_dependencies==object.abg)) ;
                end
                
                if new_dependency
                    model.invokes = [existing_dependencies,object.abg] ;
                end
            end
        end
    end
    
    
function model = create_object_hierarchy(model) ;
	mttNotify('...creating object hierarchy') ;
    mttWriteNewLine ;
    
    top_level_model = mttDetachText(model.source,'/') ;
    
    if isfield(model,'abg')
        is_embedded = zeros(1,length(model.abg)) ;
        embedding = 1 ;
    else
        embedding = 0 ;
    end
    
    component = 0 ;

    embedding = isfield(model,'abg') ;
    while embedding
        component = 1 + mod(component,length(model.abg)) ;
        if ~is_embedded(component)            
            if isempty(model.abg(component).invokes)
                number_of_systems = length(model.abg(component).invoked_by) ;
                
                for n = 1:number_of_systems
                    system = model.abg(component).invoked_by(n) ;
                    component_type = mttDetachText(model.abg(component).source,'/') ;
                    system_type = mttDetachText(model.abg(system).source,'/') ;
                    mttNotify(['   ...embedding "#',num2str(component),':',component_type,...
                            '" definition within "#',num2str(system),':',system_type,'" objects']) ;
                    mttWriteNewLine ;
                    
                    model = mttEmbedAcausalBondgraph(model,component,system) ;
                end
                model.abg(component).invoked_by = [] ;
                
                if ~isempty(find(model.invokes==component))
                    component_type = mttDetachText(model.abg(component).source,'/') ;
                    mttNotify(['   ...embedding "#',num2str(component),':',component_type,...
                            '" definition within "',top_level_model,'"']) ;
                    mttWriteNewLine ;
                    
                    model = mttEmbedAcausalBondgraph(model,component) ;
                end
                is_embedded(component) = 1 ;
            end
        end
        embedding = any(~is_embedded) ;
    end
    
    model = mttDeleteField(model,'abg') ;
    model = mttDeleteField(model,'invokes') ;
    
    
function model = assign_sympar_values(model) 
	mttNotify('...assigning "sympar" values') ;
    mttWriteNewLine ;
    
    model_name = mttDetachText(model.source,'/') ;
    current_branch = model_name ;
    
    sympars = model.sympar ;
    defaults = model.sympar_default ;
    
    objects = mttGetFieldNames(model,'obj') ;
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        if ~mttIsPassiveClass(object.class)
            for j = 1:length(object.parameter)
                object_parameter = object.parameter{j} ;
                if ischar(object_parameter)
                    index = strmatch(object_parameter,sympars,'exact') ;
                    
                    new_parameter = 0 ;
                    
                    if isempty(index)
                        new_parameter = 1 ;
                    else
                        default_value = defaults{index} ;
                        if isempty(default_value)
                            new_parameter = 1 ;
                        else
                            object.parameter{j} = default_value ;
                        end
                    end
                    
                    if new_parameter
                        object.parameter{j} = [current_branch,'___',object_parameter] ;
                    end
                end
            end
            
            branch = [model_name,'__',object_name] ;
            object = assign_object_sympar_values(object,branch) ;
            
            model = setfield(model,'obj',object_name,object) ;
        end
    end
    
    
function model = assign_object_sympar_values(model,branch)
    current_branch = branch ;
    
	sympars = model.sympar ;
    parameters = model.parameter ;
    
    if ~isempty(model.abg)
        objects = mttGetFieldNames(model,'obj') ;
        for i = 1:length(objects)
            object_name = objects{i} ;
            object = getfield(model,'obj',object_name) ;
            
            if ~mttIsPassiveClass(object.class)
                for j = 1:length(object.parameter)
                    object_parameter = object.parameter{j} ;
                    if ischar(object_parameter)
                        index = strmatch(object_parameter,sympars,'exact') ;
                        if isempty(index)
                            object.parameter{j} = [current_branch,'___',object_parameter] ;
                        else
                            object.parameter{j} = parameters{index} ;
                        end
                    end
                end
                
                branch = [current_branch,'__',object_name] ;
                object = assign_object_sympar_values(object,branch) ;
                
                model = setfield(model,'obj',object_name,object) ;
            end
        end
    elseif ~isempty(model.cr)
        model.cr.parameter = model.parameter ;
    end
    
    
function model = complete_causal_assignment(model)
    mttWriteNewLine ;
	mttNotify('...summarising model content') ;
    mttWriteNewLine ;
    
    model = mttCountObjects(model) ;
    mttNotifyNumberOfObjects(model) ;
    mttWriteNewLine ;
    model = mttDeleteField(model,'count') ;
    
    model = mttMeasureCausalCompletion(model) ;
	mttNotifyNumberOfBonds(model) ;
    mttWriteNewLine ;
    
    mttWriteNewLine ;
	mttNotify('...analysing predefined causality') ;
    mttWriteNewLine ;
    
	mttNotifyCausalCompletion(model) ;
    mttWriteNewLine ;
    
	if model.causal_completion.is_causal
        mttNotify('...applying CR constraints') ;
        mttWriteNewLine ;
        model = incorporate_cr_rules(model,'assert') ;
    else    
        mttNotify('...completing causality') ;
        mttWriteNewLine ;
        
        iterations = 0 ;
        
        propagating = 1 ;
        while propagating
            iterations = iterations + 1 ;
            previous_causal_completion = model.causal_completion ;
            
            model = mttApplyInterfaceCausality(model,'assert') ;
            model = mttPropagateCausality(model) ;
            model = mttApplyInterfaceCausality(model,'prefer') ;
            model = mttPropagateCausality(model) ;
            model = mttMeasureCausalCompletion(model) ;
            
            is_stable = mttCompareCausalCompletion(model.causal_completion,previous_causal_completion) ;
            propagating = (~is_stable) ;
            
            if propagating
                mttNotify(['...iteration ',num2str(iterations)]) ;
                mttWriteNewLine ;
                mttNotifyCausalCompletion(model) ;
            end
            
            propagating = propagating & (~model.causal_completion.is_causal) ;
        end
    end
    
    
    if ~model.causal_completion.is_causal
        mttWriteNewLine ;
        mttNotify('...causality not complete') ;
        mttWriteNewLine ;
        mttWriteNewLine ;
        
        mttIdentifyUndercausalBonds(model) ;
    end
    
    model = mttDeleteField(model,'causal_completion') ;
    
    
function model = complete_domain_assignment(model)
    mttWriteNewLine ;
	mttNotify('...allocating domain definitions') ;
    mttWriteNewLine ;
    
    model = mttMeasureDomainCompletion(model) ;
    
    iterations = 0 ;
    
    propagating = 1 ;
    while propagating
        iterations = iterations + 1 ;
        previous_domain_completion = model.domain_completion ;
        
        model = mttApplyInterfaceDomains(model) ;
        model = mttPropagateDomains(model) ;
        model = mttMeasureDomainCompletion(model) ;
        
        is_stable = mttCompareDomainCompletion(model.domain_completion,previous_domain_completion) ;
        propagating = (~is_stable) ;
        
        if propagating
            mttNotify(['...iteration ',num2str(iterations)]) ;
            mttWriteNewLine ;
            mttNotifyDomainCompletion(model) ;
        end
        
        propagating = propagating & (~model.domain_completion.is_done) ;
    end
    
    model = mttDeleteField(model,'domain_completion') ;
    
    
function model = overwrite_implicit_domains(model)
    mttWriteNewLine ;
	mttNotify('...overwriting implicit domain definitions') ;
    mttWriteNewLine ;
    
    model = mttOverwriteImplicitDomains(model) ;
    
    
function model = mttOverwriteImplicitDomains(root,model,env)
    is_root_model = nargin==1 ;
    
    if is_root_model
        model = root ;
        env = root.env ;
    end
        
    objects = mttGetFieldNames(model,'obj') ;
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        if ~isempty(object.abg)
            object = mttOverwriteImplicitDomains(model,object,env) ;
        end
        
        if ~isempty(object.cr)
            interface_ports = mttGetFieldNames(object.cr.interface,'port') ;
            for j = 1:length(interface_ports)
                port_name = interface_ports{j} ;
                port = getfield(object.cr.interface,'port',port_name) ;
                
                if isempty(port.domain)
                    if isempty(port.in)
                        bond_number = port.out ;
                    else
                        bond_number = port.in ;
                    end
                    
                    actual_domain = model.bond(bond_number).domain ;
                    actual_domain_item = model.bond(bond_number).domain_item ;
                    
                    port.domain = actual_domain ;
                    port.domain_item = actual_domain_item ;
	                object.cr.interface = setfield(object.cr.interface,'port',port_name,port) ;
                    
                    number_of_operators = mttGetFieldLength(object.cr,'operator') ;
                    for op_counter = 1:number_of_operators
                        operator = object.cr.operator(op_counter) ;
                        
                        matching_links = strmatch(port_name,{operator.link.name},'exact') ;
                        
                        number_of_equations = mttGetFieldLength(operator,'equation') ;
                        
                        for eq_counter = 1:number_of_equations
                            equation = operator.equation(eq_counter) ;
%                            if isempty(equation.domain)
                                
                                number_of_chunks = mttGetFieldLength(equation,'chunk') ;
                                for chunk_counter = 1:number_of_chunks
                                    chunk = equation.chunk{chunk_counter} ;
                                    
                                    if iscell(chunk)
                                        if strcmp(chunk{1},'link')
                                            link = chunk{2} ;
                                            
                                            if any(link==matching_links)
                                                covar = chunk{3} ;
                                                chunk{3} = ['generic___',covar] ;
                                            end
                                        end
	                                    equation.chunk{chunk_counter} = chunk ;
                                    end
                                end
                                operator.equation(eq_counter) = equation ;
%                            end
                        end
                        object.cr.operator(op_counter) = operator ;
                    end
                end
            end
        end
        
        model = setfield(model,'obj',object_name,object) ;
    end
    