function model = mttFetchInterfaceDefinition(filename)

mttAssert(exist(filename)==2,...
    ['File "',filename,'" not found']) ;

mttNotify(['   ...processing ',filename]) ;
mttWriteNewLine ;

model.representation = 'cr' ;
model.source = mttCutText(filename,'_cr.txt') ;
content = mttReadFile(filename) ;
statements = mttExtractStatements(content) ;

number_of_statements = length(statements) ;
crs = [] ;

next = 0 ;

parsing = 1 ;
while parsing
    next = next + 1 ;
    statement = statements{next} ;
    [keyword,line] = mttSeparateText(statement) ;
    
    switch keyword
    case 'cr',
        cr_name = mttCutText(line,'[') ;
        mttValidateName(cr_name) ;
        
        if ~isempty(crs)
            mttAssert(~ismember(cr_name,crs),...
                ['"cr ',cr_name,'" has already been declared']) ;
        end
        
        cr_parameter_list = mttExtractText(line,'[',']') ;
        [cr_parameters,cr_defaults] = mttGetParameters(cr_parameter_list) ;
        
        [cr,next] = fetch_cr(statements,next,cr_name,cr_parameters,cr_defaults) ;
        
        mttCheckInterfaceDeclarations(cr) ;
        mttCheckStateDeclarations(cr) ;
        
        model = setfield(model,'item',cr_name,cr) ;
        
        if isempty(crs)
            crs = {cr_name} ;
        else
            crs = [crs,{cr_name}] ;
        end
    case '{',
        error('Unexpected "{" found') ;
    case '}',
        error('Unexpected "}" found') ;
    otherwise,
        error(['Unrecognised top-level keyword "',keyword,'"']) ;
    end
    
    if next==number_of_statements
        parsing = 0 ;
    end
end


       
function [cr,next] = fetch_cr(statements,next,cr_name,cr_parameters,cr_defaults)
	unit_name = 'cr' ;
	here = [cr_name,'/',unit_name] ;
    
    cr = [] ;
    number_of_statements = length(statements) ;
    
    cr.sympar = cr_parameters ;
    cr.numpar = [] ;
    cr.input = [] ;
    cr.state = [] ;
    
    cr.sympar_default = cr_defaults ;
    cr.numpar_default = [] ;
    cr.input_default = [] ;
    cr.state_default = [] ;

    op_counter = 0 ;
    interface_declared = 0 ;
	open = 0 ;
    
	parsing = 1 ;
    while parsing
        next = next + 1 ;
        statement = statements{next} ;
        [keyword,line] = mttSeparateText(statement) ;
        
        switch keyword
        case 'interface',
            mttAssert(open,...
                ['"interface" declaration must be contained inside {...} in ',here]) ;
            mttAssert(~interface_declared,...
                '"interface" declaration must be unique') ;
            mttAssert(isempty(line),...
                ['Unexpected text after "interface" declaration in ',here]) ;
            
            [interface,next] = fetch_interface(statements,next,cr_name) ;
            cr.interface = interface ;
            interface_declared = 1 ;
            
        case 'operator',
            mttAssert(interface_declared,...
                ['"operator" declaration must follow "interface" in ',here]) ;
            mttAssert(open,...
                ['"operator" declaration must be contained inside {...} in ',here]) ;
            
            op_counter = op_counter + 1 ;
            [operator,next] = fetch_operator(statements,next,cr,cr_name) ;
            
            if ~isfield(operator,'content')
                operator.content = [] ;
            end
            cr.operator(op_counter) = operator ;
            
        case 'input',
            mttAssert(open,...
                ['"input" declarations must be contained inside {...} in ',here]) ;
            
            input_parameter_list = line ;
            [input_parameters,input_defaults] = mttGetParameters(input_parameter_list) ;
            
            cr = mttAppend(cr,'input',input_parameters) ;
            cr = mttAppend(cr,'input_default',input_defaults) ;
            
        case 'numpar',
            mttAssert(open,...
                ['"numpar" declarations must be contained inside {...} in ',here]) ;
            
            numerical_parameter_list = line ;
            [numerical_parameters,numerical_defaults] = mttGetParameters(numerical_parameter_list) ;
            
            cr = mttAppend(cr,'numpar',numerical_parameters) ;
            cr = mttAppend(cr,'numpar_default',numerical_defaults) ;
            
        case 'state',
            mttAssert(open,...
                ['"state" declarations must be contained inside {...} in ',here]) ;
            
            state_parameter_list = line ;
            [state_parameters,state_defaults] = mttGetParameters(state_parameter_list) ;
            
            cr = mttAppend(cr,'state',state_parameters) ;
            cr = mttAppend(cr,'state_default',state_defaults) ;
            
        case '{',
            mttAssert(~open,['Unmatched "{" in ',here]) ;
            open = 1 ;
        case '}',
            mttAssert(open,['Unmatched "}" in ',here]) ;
			open = 0 ;
        otherwise,
            error(['Unrecognised keyword "',keyword,'" in ',here]) ;
        end
        
        mttAssert(~(open & (next==number_of_statements)),...
            ['Missing "}" in ',here]) ;
        
        if (~open) | (next==number_of_statements)
			parsing = 0 ;
        end
    end
    
    interface_ports = mttGetFieldNames(cr.interface,'port') ;
    interface_ports_with_state = [] ;
    
    counter = 0 ;
    for i = 1:length(interface_ports)
        port_name = interface_ports{i} ;
        interface_port = getfield(cr.interface,'port',port_name) ;
        if interface_port.is_effort_state | interface_port.is_flow_state
            counter = counter + 1 ;
            interface_ports_with_state{counter} = port_name ;
        end
    end
    
    mttAssert(op_counter>0,...
        ['No operator defined in ',here]) ;
    
    assigned_ports = [] ;
    
    for i = 1:length(cr.operator)
        if i==1
            operator_names{1} = cr.operator(i).name ;
        else
            operator_name = cr.operator(i).name ;
            mttAssert(~ismember(operator_name,operator_names),...
                ['Repeated operator name "',operator_name,'" in ',here]) ;
            operator_names{i} = operator_name ;
        end
        
        newly_assigned_ports = mttGetFieldNames(cr.operator(i),'assign') ;
        if isempty(assigned_ports)
            assigned_ports = newly_assigned_ports ;
        else
            if ~isempty(newly_assigned_ports)
                assigned_ports = [assigned_ports, newly_assigned_ports] ;
            end
        end
    end
    
    for i = 1:length(interface_ports_with_state)
        interface_port = interface_ports_with_state{i} ;
        
        mttAssert(ismember(interface_port,assigned_ports),...
            ['Missing "set" declaration for port "',interface_port,'" in ',here]) ;
    end
    
    
    
    
function [interface,next] = fetch_interface(statements,next,cr_name)
global mtt_environment
	unit_name = 'interface' ;
    here = [cr_name,'/',unit_name] ;
    
    domain_names = mttGetFieldNames(mtt_environment,'domain') ;
    
    interface = [] ;
    number_of_statements = length(statements) ;
    
    counter = 0 ;
    constraint = [] ;
    
    open = 0 ;
	parsing = 1 ;
    while parsing
        next = next + 1 ;
        statement = statements{next} ;
        [keyword,line] = mttSeparateText(statement) ;
        
        switch keyword
        case 'port',
            ports = mttGetItemList(line) ;
            for n = 1:length(ports)
                identifier = mttCutText(ports{n},'[') ;
                qualifier = mttExtractText(ports{n},'[',']') ;
                [name.domain,name.domain_item] = mttCutText(qualifier,'::') ;
                
                name.port = identifier ;
                mttValidateName(name.port) ;
                
                if isempty(name.domain) | isempty(mtt_environment)
                    interface = setfield(interface,'port',name.port,'domain',[]) ;
                    interface = setfield(interface,'port',name.port,'domain_item',[]) ;
                    interface = setfield(interface,'port',name.port,'was_generic',1) ;
                else
                    mttAssert(ismember(name.domain,domain_names),...
                        ['Unrecognised domain "',name.domain,'"']) ;
                    dom = getfield(mtt_environment,'domain',name.domain,'dom') ;
                    item = getfield(mtt_environment,'domain',name.domain,'item') ;
                    
                    if isempty(item)
                        public_domain = getfield(mtt_environment,'public_domain',{dom}) ;
                        item_names = mttGetFieldNames(public_domain,'item') ;
                        
                        mttAssert(ismember(name.domain_item,item_names),...
                            ['Item "',name.domain_item,'" not found in public domain "',name.domain,'"']) ;
                        item_name = name.domain_item ;
                    else
                        mttAssert(isempty(name.domain_item),...
                            ['Item unspecified in public domain "',name.domain,'"']) ;
                        item_name = item ;
                    end
                    
                    interface = setfield(interface,'port',name.port,'domain',dom) ;
                    interface = setfield(interface,'port',name.port,'domain_item',item_name) ;
                    interface = setfield(interface,'port',name.port,'was_generic',0) ;
                end
                interface = setfield(interface,'port',name.port,'is_effort_state',0) ;
                interface = setfield(interface,'port',name.port,'is_flow_state',0) ;
                interface = setfield(interface,'port',name.port,'assign',[]) ;
            end
            
        case {'assert','prefer'},
            counter = counter + 1 ;
            constraint{counter} = statement ;
            
        case '{',
            mttAssert(~open,['Unmatched "{" in ',here]) ;
            open = 1 ;
        case '}',
            mttAssert(open,['Unmatched "}" in ',here]) ;
			open = 0 ;
        otherwise,
            error(['Unrecognised_keyword "',keyword,'" in ',here]) ;
        end
        
        mttAssert(~(open & (next==number_of_statements)),...
            ['Missing "}" in ',here]) ;
        
        if (~open) | (next==number_of_statements)
			parsing = 0 ;
        end
    end
    
    
    interface_ports = mttGetFieldNames(interface,'port') ;
    number_of_constraints = length(constraint) ;
    
    for i = 1:number_of_constraints
        [keyword,assignment] = mttSeparateText(constraint{i}) ;
        [namelist,definition] = mttCutText(assignment,'=>') ;
        
        mttAssert(~isempty(keyword),...
            ['Rule "',constraint{i},'" has no context in cr ',cr_name]) ;
                
        if ~isempty(namelist)
            first = 1 ;
            last = length(namelist) ;
            if namelist([first,last])=='[]'
                ports = mttGetItemList(mttExtractText(namelist,'[',']')) ;
            else
                ports = {namelist} ;
            end
        end
        
        mttAssert(~isempty(ports),...
            ['Rule "',constraint{i},'" has no association in cr ',cr_name]) ;
        mttAssert(~isempty(definition),...
            ['Rule "',constraint{i},'" not defined in cr ',cr_name]) ;
        
		for j = 1:length(ports)
            port_name = ports{j} ;
            mttValidateName(port_name) ;
            
            other_ports = [] ;
            counter = 0 ;
            for k = 1:length(ports)
                if j~=k
                    counter = counter + 1 ;
                    other_ports{counter} = ports{k} ;
                end
            end
            
            mttAssert(ismember(port_name,interface_ports),...
                ['Unreferenced port "',port_name,'" in cr ',cr_name]) ;
            
            port = getfield(interface,'port',port_name) ;
            
            switch definition
            case 'effort_state',
                mttAssert(mttIsEqual(port.is_flow_state,0),...
                    ['Attempt to overwrite state assignment at port "',port_name,'" in ',here]) ;
                port.is_effort_state = 1 ;
                
            case 'flow_state',
                mttAssert(mttIsEqual(port.is_effort_state,0),...
                    ['Attempt to overwrite state assignment at port "',port_name,'" in ',here]) ;
                port.is_flow_state = 1 ;
                
            otherwise,
                rule_number = 1 + mttGetFieldLength(port,'causality') ;
                
                port.causality(rule_number).rule = keyword ;
                port.causality(rule_number).def = definition ;
                port.causality(rule_number).with = other_ports ;
                port.causality(rule_number).applied = 0 ;
            end
            
            interface = setfield(interface,'port',port_name,port) ;
        end
    end
        
    
function [operator,next] = fetch_operator(statements,next,cr,cr_name)
	unit_name = 'operator' ;
    here = [cr_name,'/',unit_name] ;
    
    interface = [] ;
    number_of_statements = length(statements) ;
    
    statement = statements{next} ;
    [keyword,line] = mttSeparateText(statement) ;
    
    operator = mttGetOperatorContext(line,cr,cr_name) ;
    
    operator.content = [] ;
    operator.var = [] ;
    operator.var_default = [] ;
    operator.struct = [] ;
    operator.set = [] ;
    
    counter = 0 ;
    
    open = 0 ;
	parsing = 1 ;
    while parsing
        next = next + 1 ;
        statement = statements{next} ;
        [keyword,line] = mttSeparateText(statement) ;
        
        switch keyword
        case '{',
            mttAssert(~open,['Unmatched "{" in ',here]) ;
            open = 1 ;
            
        case '}',
            mttAssert(open,['Unmatched "}" in ',here]) ;
			open = 0 ;
            
        case 'set',
            mttAssert(open,...
                ['"set" declarations must be contained inside {...} in ',here]) ;
            
            operator = mttAppend(operator,'set',{line}) ;
            
        case 'var',
            mttAssert(open,...
                ['"var" declarations must be contained inside {...} in ',here]) ;
            
            variable_list = line ;
            [variables,defaults] = mttGetParameters(variable_list) ;
            
            operator = mttAppend(operator,'var',variables) ;
            operator = mttAppend(operator,'var_default',defaults) ;
            
        case 'struct',
            mttAssert(open,...
                ['"struct" declarations must be contained inside {...} in ',here]) ;
            
            [struct_name,variable_list] = mttSeparateText(line) ;
            [variables,defaults] = mttGetParameters(variable_list) ;
            
            mttAssert(mttIsEmptyCellArray(defaults),...
                ['"struct" declarations cannot have default values in ',here]) ;
            
            operator.struct = mttAppend(operator.struct,struct_name,variables) ;
            
        otherwise,
            counter = counter + 1 ;
            operator.content{counter} = statement ;
        end
        
        mttAssert(~(open & (next==number_of_statements)),...
            ['Missing "}" in ',here]) ;
        
        if (~open) | (next==number_of_statements)
			parsing = 0 ;
        end
    end
    
    cr_ports = mttGetFieldNames(cr.interface,'port') ;
    for i = 1:length(operator.var)
        current_var = operator.var{i} ;
        mttAssert(~ismember(current_var,cr.numpar),...
            ['Variable "',current_var,'" redeclares CR numerical parameter in ',cr_name]) ;
        mttAssert(~ismember(current_var,cr.sympar),...
            ['Variable "',current_var,'" redeclares CR parameter in ',cr_name]) ;
        mttAssert(~ismember(current_var,cr_ports),...
            ['Variable "',current_var,'" redeclares CR port in ',cr_name]) ;
    end
    
    operator = mttParseOperatorEquations(operator,cr,cr_name) ;

    
function context = mttGetOperatorContext(line,cr,cr_name)
    index = sort([findstr(line,'|'),findstr(line,'<'),findstr(line,'>')]) ;
    assignment = findstr(line,':=') ;

    mttAssert(length(assignment)==1,...
        ['Operator declaration must contain a unique ":=" assignment in cr ',cr_name]) ;
    mttAssert(length(index)>0,...
        ['Operator declaration without ports in cr ',cr_name]) ;
    
    left_side = index(index<assignment) ;
    right_side = index(index>assignment) ;
    
    mttAssert(length(left_side)>0,...
        ['Operator declaration without input ports in cr ',cr_name]) ;
    mttAssert(length(right_side)>0,...
        ['Operator declaration without output ports in cr ',cr_name]) ;
    mttAssert(mod(length(left_side),2)==0 & mod(length(right_side),2)==0,...
        ['Operator declaration has mismatched tags in cr ',cr_name]) ;
    
    context.name = mttClipText(line(assignment+2:right_side(1)-1)) ;
    mttAssert(~isempty(context.name),...
        ['Operator declaration is anonymous in cr ',cr_name]) ;
    
    mttValidateName(context.name) ;
    
    
    counter = 0 ;
    
    for i = 1:length(index)/2
        counter = counter + 1 ;
        link = [] ;
        
        right = 2*i ;
        left = right - 1 ;
        
        if index(right)<assignment
            link.is_input = 0 ;
        elseif index(left)>assignment
            link.is_input = 1 ;
        end
        
        
        recognised = 1 ;
        switch line(index([left,right]))
        case '|>',
            link.is_flow = 1 ;
            link.is_effort = 0 ;
        case '<|',
            link.is_flow = 0 ;
            link.is_effort = 1 ;
        case '<>',
            link.is_flow = 1 ;
            link.is_effort = 1 ;
        otherwise,
            recognised = 0 ;
        end
        
        mttAssert(recognised,...
            ['Unrecognised tags in operator ',context.name,' (cr ',cr_name,')']) ;
        
        port_declaration = line(index(left):index(right)) ;
        port = line(index(left)+1:index(right)-1) ;
        mttAssert(~isempty(port),...
            ['Empty port in operator ',context.name,' (cr ',cr_name,')']) ;
            
        [port_name,qualifier] = mttCutText(port,'=') ;
        
        link.name = port_name ;

        if isempty(qualifier)
            link.is_unconstrained = 1 ;
        else
            link.is_unconstrained = 0 ;
            mttAssert(strcmp(qualifier,'0'),...
                ['Non-zero port constraint in operator ',context.name,' (cr ',cr_name,')']) ;
        end
        
        context.link(counter) = link ;
    end
    
    
    cr_port_names = mttGetFieldNames(cr.interface,'port') ;
    
    check.is_input = [] ;
    check.is_output = [] ;
    check.is_effort = [] ;
    check.is_flow = [] ;
    
    for j = 1:length(cr_port_names)
        port_check(j) = check ;
    end    
    
    for i = 1:counter
        port_name = context.link(i).name ;
        mttAssert(ismember(port_name,cr_port_names),...
            ['Operator declaration uses undefined port "',port_name,'" in cr ',cr_name]) ;
        
        index = strmatch(port_name,cr_port_names,'exact') ;
        
        mttAssert(~mttIsEqual(port_check(index).is_input,context.link(i).is_input),...
            ['Operator declaration has repeated input ports in cr ',cr_name]) ;
        mttAssert( mttIsEqual(port_check(index).is_output,context.link(i).is_input),...
            ['Operator declaration has repeated output ports in cr ',cr_name]) ;
        mttAssert(~mttIsEqual(port_check(index).is_flow,context.link(i).is_flow),...
            ['Operator declaration has repeated flow in cr ',cr_name]) ;
        mttAssert(~mttIsEqual(port_check(index).is_effort,context.link(i).is_effort),...
            ['Operator declaration has repeated effort in cr ',cr_name]) ;
        
        port_check(index).is_input = context.link(i).is_input ;
        port_check(index).is_output = ~context.link(i).is_input ;
        port_check(index).is_flow = context.link(i).is_flow ;
        port_check(index).is_effort = context.link(i).is_effort ;
    end
    
    for j = 1:length(cr_port_names)
        mttAssert(~isempty(port_check(j).is_input),...
            ['Operator declaration has missing input ports in cr ',cr_name]) ;
        mttAssert(~isempty(port_check(j).is_output),...
            ['Operator declaration has missing output ports in cr ',cr_name]) ;
        mttAssert(~isempty(port_check(j).is_flow),...
            ['Operator declaration has missing flow in cr ',cr_name]) ;
        mttAssert(~isempty(port_check(j).is_effort),...
            ['Operator declaration has missing effort in cr ',cr_name]) ;
    end    
