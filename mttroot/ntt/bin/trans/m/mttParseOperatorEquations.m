function operator = mttParseOperatorEquations(operator,cr,cr_name)
global mtt_environment

    operator.equation = [] ;
%    operator.is_used = 0 ;

	numparlist = cr.numpar ;
	symparlist = cr.sympar ;
	varlist    = operator.var ;
	inputlist  = cr.input ;
	statelist  = cr.state ;
    
    structlist = [] ;
    if ~isempty(operator.struct)
        struct_names = mttGetFieldNames(operator,'struct') ;
        number_of_structs = length(struct_names) ;
        for i = 1:number_of_structs
            struct_name = struct_names{i} ;
            variables = getfield(operator,'struct',struct_name) ;
            if i==1
                structlist = variables ;
            else
                structlist = [structlist,variables] ;
            end
        end
    end
    
    
    inlist = [] ;
    outlist = [] ;
    inlink = [] ;
    outlink = [] ;
    
    input_counter = 0 ;
    output_counter = 0 ;
    
    for i = 1:length(operator.link)
        if operator.link(i).is_input
            input_counter = input_counter + 1 ;
            inlist{input_counter} = operator.link(i).name ;
            inlink(input_counter) = i ;
            infree(input_counter) = operator.link(i).is_unconstrained ;
        else
            output_counter = output_counter + 1 ;
            outlist{output_counter} = operator.link(i).name ;
            outlink(output_counter) = i ;
            outfree(output_counter) = operator.link(i).is_unconstrained ;
        end
    end
    
    
    operator.assign = [] ;
    ports_with_state_assignment = [] ;
        
    for i = 1:length(operator.set)
        [port_covariable,state] = mttCutText(operator.set{i},'=>') ;
        mttAssert(~isempty(state),...
            ['"set" declarations must use "=>" in cr ',cr_name]) ;
        
        [port_name,covariable] = mttCutText(port_covariable,'.') ;
        mttAssert(~isempty(covariable),...
            ['"set" declarations must reference effort/flow covariables in cr ',cr_name]) ;
        
        port = strmatch(port_name,outlist,'exact') ;
        ports_with_state_assignment = [ports_with_state_assignment,port] ;
        
        mttAssert(~isempty(port),...
            ['Output port "',port_name,'" not recognised for "set" declaration in cr ',cr_name]) ;
        mttAssert(outfree(port),...
            ['Constrained port variable used for "set" declaration in cr ',cr_name]) ;
        
        actual_port = getfield(cr.interface.port,port_name) ;
        mttAssert(actual_port.is_effort_state | actual_port.is_flow_state,...
            ['"set" declarations must only be used for effort_states or flow_states in cr ',cr_name]) ;
        
        if isempty(actual_port.domain)
            if actual_port.is_effort_state
                covariables = {'effort'} ;
            elseif actual_port.is_flow_state
                covariables = {'flow'} ;
            end
        else
            public_domain = mtt_environment.public_domain(actual_port.domain) ;
            domain_item = getfield(public_domain.item,actual_port.domain_item) ;
            
            if actual_port.is_effort_state
                covariables = domain_item.effort ;
            elseif actual_port.is_flow_state
                covariables = domain_item.flow ;
            end
        end
        
        index = strmatch(covariable,covariables,'exact') ;
        mttAssert(~isempty(index),...
            ['Unrecognised covariable "',covariable,'" used for "set" declaration in cr ',cr_name]) ;
        
        if isfield(operator.assign,port_name)
            assignment = getfield(operator,'assign',port_name) ;
            mttAssert(isempty(assignment.states{index}),...
                ['Repeated covariable "',covariable,'" used for "set" declaration in cr ',cr_name]) ;
        else
            assignment.covar = covariables ;
            assignment.state{length(covariables)} = [] ;
%            assignment.domain = actual_port.domain ;
%            assignment.domain_item = actual_port.domain_item ;
        end
        
        mttAssert(ismember(state,cr.state),...
            ['Unrecognised state "',state,'" used for "set" declaration in cr ',cr_name]) ;
        
        assignment.state{index} = state ;
        operator = setfield(operator,'assign',port_name,assignment) ;
    end
    operator = mttDeleteField(operator,'set') ;
    
    
    port_assignments = mttGetFieldNames(operator,'assign') ;
    number_of_assignments = length(port_assignments) ;
    for i = 1:number_of_assignments
        assignment = getfield(operator,'assign',port_name) ;
        for j = 1:length(assignment.state)
            mttAssert(~isempty(assignment.state{j}),...
                ['Missing covariable "',covariable,'" from "set" declaration in cr ',cr_name]) ;
        end
    end
        
        
    for i = 1:length(operator.content)
        operator.equation(i).chunk = {[]} ;
%        operator.equation(i).was_generic = 1 ;
%        operator.equation(i).domain = [] ;
%        operator.equation(i).domain_item = [] ;
%        operator.equation(i).is_effort = [] ;
%        operator.equation(i).covariable = [] ;
        
        counter = 0 ;
        
        line = operator.content{i} ;
        
        if ~isempty(mttClipText(line))
            [var,loc] = mttFindEquationVariables(line) ;
            
            if loc(1)>1
                front = line(1:loc(1)-1) ;
                counter = counter + 1 ;
                operator.equation(i).chunk{counter} = front ;
            end
            
            last = length(line) ;
            
            for j = 1:length(var)
                [name,component] = mttCutText(var{j},'.') ;
                
                if isempty(component)
                    [name,attribute] = mttCutText(name,'''') ;
                    
                    numpar = strmatch(name,numparlist,'exact') ;
                    sympar = strmatch(name,symparlist,'exact') ;
                    variable = strmatch(name,varlist,'exact') ;
                    struct = strmatch(name,structlist,'exact') ;
                    input = strmatch(name,inputlist,'exact') ;
                    state = strmatch(name,statelist,'exact') ;
                    
                    ok = ~(isempty(numpar)&isempty(sympar)&isempty(variable)&isempty(struct)&isempty(input)&isempty(state)) ;
                    mttAssert(ok,['Variable ',var{j},' not recognised in cr ',cr_name]) ;
                    
                    is_numpar = ~isempty(numpar) ;
                    is_sympar = ~isempty(sympar) ;
                    is_var    = ~isempty(variable) ;
                    is_struct = ~isempty(struct) ;
                    is_input  = ~isempty(input) ;
                    is_state  = ~isempty(state) ;
                    is_derivative = 0 ;
                    
                    if ~isempty(attribute)
                        mttAssert(strcmp(attribute,'dt'),...
                            ['Unrecognised attribute ',attribute,' in cr ',cr_name]) ;
                        mttAssert(is_state,...
                            ['Derivative of non-state variable in cr ',cr_name]) ;
                        is_state = 0 ;
                        is_derivative = 1 ;
                    end
                    
                    counter = counter + 1 ;
                    
                    if is_numpar
                        operator.equation(i).chunk{counter} = {'numpar',numpar} ;
                    end
                    
                    if is_sympar
                        operator.equation(i).chunk{counter} = {'sympar',sympar} ;
                    end
                    
                    if is_var
                        operator.equation(i).chunk{counter} = {'var',variable} ;
                    end
                    
                    if is_struct
                        operator.equation(i).chunk{counter} = {'struct',struct} ;
                    end
                    
                    if is_input
                        operator.equation(i).chunk{counter} = {'input',input} ;
                    end
                    
                    if is_state
                        operator.equation(i).chunk{counter} = {'state',state} ;
                    end
                    
                    if is_derivative
                        operator.equation(i).chunk{counter} = {'derivative',state} ;
                    end
                    
                else
                    
                    if j==1
                        port = strmatch(name,outlist,'exact') ;
                        
                        if ~isempty(ports_with_state_assignment)
                            mttAssert(~any(port==ports_with_state_assignment),...
                                ['Use "set" declaration to assign output port ',name,' to state in cr ',cr_name]) ;
                        end
                        
                        mttAssert(~isempty(port),...
                            ['Output port ',name,' not recognised in cr ',cr_name]) ;
                        mttAssert(outfree(port),...
                            ['Constrained port variable used in cr ',cr_name]) ;
                        
                        counter = counter + 1 ;
                        operator.equation(i).chunk{counter} = {'link',outlink(port),component} ;
                    else
                        port = strmatch(name,inlist,'exact') ;
                        mttAssert(~isempty(port),...
                            ['Input port ',name,' not recognised in cr ',cr_name]) ;
                        mttAssert(infree(port),...
                            ['Constrained port variable used in cr ',cr_name]) ;
                        
                        counter = counter + 1 ;
                        operator.equation(i).chunk{counter} = {'link',inlink(port),component} ;
                    end
                    
                    
%                    equation_domain = mttIdentifyUserDomain(mtt_environment,...
%                        operator.equation(i).domain,....
%                        operator.equation(i).domain_item) ;
                    
                    covariable = component ;
                    port_name = name ;
                    port = getfield(cr.interface.port,port_name) ;
                    
                    if isempty(port.domain)
                        is_effort = strcmp(covariable,'effort') ;
                        is_flow = strcmp(covariable,'flow') ;
                        
                        mttAssert(is_effort|is_flow, ...
                            ['"',covariable,'" is not a generic covariable']) ;
                        
%                        mttAssert(isempty(operator.equation(i).domain),...
%                            ['Generic interface "',port_name,'" referenced in ',equation_domain,' equation']) ;
                    else
                        public_domain = mtt_environment.public_domain(port.domain) ;
                        actual_domain = getfield(public_domain,'item',port.domain_item) ;
                        
                        port_domain = mttIdentifyUserDomain(mtt_environment,port.domain,port.domain_item) ;
                        
                        is_effort = ismember(covariable,actual_domain.effort) ;
                        is_flow = ismember(covariable,actual_domain.flow) ;
                        
                        mttAssert(is_effort|is_flow, ...
                            ['"',covariable,'" is not a covariable defined in domain "',port_domain,'"']) ;
                        
%                        if isempty(equation_domain)
%                            operator.equation(i).was_generic = 0 ;
%                            operator.equation(i).domain = port.domain ;
%                            operator.equation(i).domain_item = port.domain_item ;
                            %                        operator.equation(i).covariable = covariable ;
                            %                    else
                            %                        mttAssert(covariable==operator.equation(i).covariable, ...
                            %                            ['Equation cannot combine different covariables: [',covariable,',',operator.equation(i).covariable,']') ;
%                        end
                    end
                    
%                    if isempty(operator.equation(i).is_effort)
%                        if is_effort
%                            operator.equation(i).is_effort = 1 ;
%                        else
%                            operator.equation(i).is_effort = 0 ;
%                        end
%                    else
%                        mttAssert(operator.equation(i).is_effort==is_effort,...
%                            ['Effort and flow covariables appear in equation: "',operator.content{i},'"']) ;
%                    end
                end
                
                next = loc(j) + length(var{j}) ;
                
                if j<length(var)
                    glue = line(next:loc(j+1)-1) ;
                    
                    counter = counter + 1 ;
                    operator.equation(i).chunk{counter} = glue ;
                    
                    if j==1
                        mttAssert(~isempty(findstr(glue,':=')),...
                            ['Expect ":=" after first variable in cr ',cr_name]) ;
                    end
                else
                    if next<=last
                        back = line(next:last) ;
                        
                        counter = counter + 1 ;
                        operator.equation(i).chunk{counter} = back ;
                    end
                end
            end
        end
    end
    