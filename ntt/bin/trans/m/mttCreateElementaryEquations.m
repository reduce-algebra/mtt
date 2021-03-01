function model = mttCreateElementaryEquations(model,sorter_on)

model.representation = 'ese' ;

[model,ese,namelist] = specify_equations(model) ;
if sorter_on
    [sse,counter] = sort_equations(ese,model,namelist) ;
else
    sse = ese ;
    counter = 0 ;
end

model.equation = sse ;
model.sorted_equations = counter ;
model.namelist = namelist ;



function [model,ese,namelist] = specify_equations(model,branch,root_namelist)
    is_root_model = (nargin==1) ;

    if is_root_model
        mttNotify('...specifying equations') ;
    	mttWriteNewLine ;
        
        branch = mttDetachText(model.source,'/') ;
        
        name_counter = 1 ;
        namelist(name_counter).var = '0' ;
        namelist(name_counter).domain = [] ;
        namelist(name_counter).domain_item = [] ;
    else
        namelist = root_namelist ;
        name_counter = length(namelist) ;
    end
        
    mttNotify(['   ...processing ',branch]) ;
   	mttWriteNewLine ;
       
    objects = mttGetFieldNames(model,'obj') ;
    
    line = 0 ;
    
    for n = 1:length(objects)
        object_name = objects{n} ;
        object = getfield(model,'obj',object_name) ;
        
        here = [branch,':',object_name] ;
        
        switch object.class
        case {'SS','Se','Sf','De','Df'},
            
            for j = 1:mttGetFieldLength(object,'interface')
                flow_equation = [] ;
                effort_equation = [] ;
                
                terminal = [branch,'__',object_name] ;
                
                inbond = object.interface(j).in ;
                outbond = object.interface(j).out ;
                
                if ~isempty(inbond)
                    bond = model.bond(inbond) ;
                    [specified_domain,specified_domain_item] = mttGetBondDomain(model,inbond) ;
                    
                    new_name = 0 ;
                    
                    line = line + 1 ;
                    if bond.flow
                        if strcmp(object.class,'De')
                            ese(line) = specify_ese(branch,[2*inbond],branch,{1},[]) ;
                        else
                            ese(line) = specify_ese(branch,[2*inbond],branch,{name_counter+1},[]) ;
                            new_name = 1 ;
                        end
                    else
                        ese(line) = specify_ese(branch,{name_counter+1},branch,[2*inbond],[]) ;
                        new_name = 1 ;
                    end
                    
                    if new_name
                        name_counter = name_counter + 1 ;
                        namelist(name_counter).var = [terminal,'.flow'] ;
                        namelist(name_counter).domain = specified_domain ;
                        namelist(name_counter).domain_item = specified_domain_item ;
                    end
                    
                	new_name = 0 ;
                
                    line = line + 1 ;
                    if bond.effort
                        ese(line) = specify_ese(branch,{name_counter+1},branch,[2*inbond-1],[]) ;
                        new_name = 1 ;
                    else
                        if strcmp(object.class,'Df')
                            ese(line) = specify_ese(branch,[2*inbond-1],branch,{1},[]) ;
                        else
                            ese(line) = specify_ese(branch,[2*inbond-1],branch,{name_counter+1},[]) ;
	                        new_name = 1 ;
                        end
                    end
                    
                    if new_name
                        name_counter = name_counter + 1 ;
                        namelist(name_counter).var = [terminal,'.effort'] ;
                        namelist(name_counter).domain = specified_domain ;
                        namelist(name_counter).domain_item = specified_domain_item ;
                    end
                end
                               
                if ~isempty(outbond)
                    bond = model.bond(outbond) ;
                    [specified_domain,specified_domain_item] = mttGetBondDomain(model,outbond) ;
                    
                    new_name = 0 ;
                    
                    if bond.flow
                        if ~strcmp(object.class,'Se')
                            line = line + 1 ;
                            ese(line) = specify_ese(branch,{name_counter+1},branch,[2*outbond],[]) ;
                            new_name = 1 ;
                        end
                    else
                        line = line + 1 ;
                        ese(line) = specify_ese(branch,[2*outbond],branch,{name_counter+1},[]) ;
                        new_name = 1 ;
                    end
                    
                    if new_name
                        name_counter = name_counter + 1 ;
                        namelist(name_counter).var = [terminal,'.flow'] ;
                        namelist(name_counter).domain = specified_domain ;
                        namelist(name_counter).domain_item = specified_domain_item ;
                    end
                    
                    new_name = 0 ;
                    
                    if bond.effort
                        line = line + 1 ;
                        ese(line) = specify_ese(branch,[2*outbond-1],branch,{name_counter+1},[]) ;
                        new_name = 1 ;
                    else
                        if ~strcmp(object.class,'Sf')
                            line = line + 1 ;
                            ese(line) = specify_ese(branch,{name_counter+1},branch,[2*outbond-1],[]) ;
                            new_name = 1 ;
                        end
                    end
                    
                    if new_name
                        name_counter = name_counter + 1 ;
                        namelist(name_counter).var = [terminal,'.effort'] ;
                        namelist(name_counter).domain = specified_domain ;
                        namelist(name_counter).domain_item = specified_domain_item ;
                    end
                end
            end
            
        case '0',
            
            imposed_effort = [] ;
            resultant_flow = [] ;
            
            for i = 1:mttGetFieldLength(object,'interface')
                inbond = object.interface(i).in ;
                outbond = object.interface(i).out ;
                
                if isempty(inbond)
                    bond_number(i) = outbond ;
                    orientation(i) = 0 ;
                else
                    bond_number(i) = inbond ;
                    orientation(i) = 1 ;
                end
                
                [effort,flow] = mttGetBondCausality(model,bond_number(i)) ;
                
                if effort==orientation(i)
                    imposed_effort = 2*bond_number(i)-1 ;
                end
                if flow==orientation(i)
                    resultant_flow = 2*bond_number(i) ;
                    resultant_orientation = orientation(i) ;
                end
            end
            
            for i = 1:mttGetFieldLength(object,'interface')
                effort = 2*bond_number(i)-1 ;
                if effort~=imposed_effort
                    derived_effort = effort ;
                    
                    line = line + 1 ;
                    ese(line) = specify_ese(branch,derived_effort,branch,imposed_effort,[]) ;
                end
            end
            
            flow_summation = [] ;
            for i = 1:mttGetFieldLength(object,'interface')
                flow = 2*bond_number(i) ;
                
                if flow~=resultant_flow
                    impinging_flow = flow ;
                    
                    if orientation(i)
                        if resultant_orientation
                            flow_summation = [ flow_summation, -impinging_flow ] ;
                        else
                            flow_summation = [ flow_summation, impinging_flow ] ;
                        end
                    else
                        if resultant_orientation
                            flow_summation = [ flow_summation, impinging_flow ] ;
                        else
                            flow_summation = [ flow_summation, -impinging_flow ] ;
                        end
                    end
                end
            end
            
            line = line + 1 ;
            ese(line) = specify_ese(branch,resultant_flow,branch,flow_summation,[]) ;
            
        case '1',
            
            imposed_flow = [] ;
            resultant_effort = [] ;
            
            for i = 1:mttGetFieldLength(object,'interface')
                inbond = object.interface(i).in ;
                outbond = object.interface(i).out ;
                
                if isempty(inbond)
                    bond_number(i) = outbond ;
                    orientation(i) = 0 ;
                else
                    bond_number(i) = inbond ;
                    orientation(i) = 1 ;
                end
                
                [effort,flow] = mttGetBondCausality(model,bond_number(i)) ;
                
                if flow~=orientation(i)
                    imposed_flow = 2*bond_number(i) ;
                end
                if effort~=orientation(i)
                    resultant_effort = 2*bond_number(i)-1 ;
                    resultant_orientation = orientation(i) ;
                end
            end
            
            for i = 1:mttGetFieldLength(object,'interface')
                flow = 2*bond_number(i) ;
                if flow~=imposed_flow
                    derived_flow = flow ;
                    
                    line = line + 1 ;
                    ese(line) = specify_ese(branch,derived_flow,branch,imposed_flow,[]) ;
                end
            end
            
            effort_summation = [] ;            
            for i = 1:mttGetFieldLength(object,'interface')
                effort = 2*bond_number(i)-1 ;
                
                if effort~=resultant_effort
                    impinging_effort = effort ;
                    
                    if orientation(i)
                        if resultant_orientation
                            effort_summation = [ effort_summation, -impinging_effort ] ;
                        else
                            effort_summation = [ effort_summation, impinging_effort ] ;
                        end
                    else
                        if resultant_orientation
                            effort_summation = [ effort_summation, impinging_effort ] ;
                        else
                            effort_summation = [ effort_summation, -impinging_effort ] ;
                        end
                    end
                end
            end
            
            line = line + 1 ;
            ese(line) = specify_ese(branch,resultant_effort,branch,effort_summation,[]) ;
            
        otherwise,
            
            if ~isempty(object.cr)
                interface = object.cr.interface ;
                port_names = mttGetFieldNames(interface,'port') ;
                number_of_ports = length(port_names) ;
                
                link_counter = 0 ;
                
                for i = 1:number_of_ports
                    port_name = port_names{i} ;
                    port = getfield(interface,'port',port_name) ;
                    terminal = [branch,'__',object_name,'___',port_name] ;
                    
                    inbond = port.in ;
                    outbond = port.out ;
                    
                    if ~isempty(inbond)
                        bond = model.bond(inbond) ;
                        [specified_domain,specified_domain_item] = mttGetBondDomain(model,inbond) ;
                        
                        name_counter = name_counter + 1 ;
                        if port.is_flow_state
                            namelist(name_counter).var = [terminal,'.flow_state'] ;
                        else
                            namelist(name_counter).var = [terminal,'.flow'] ;
                        end
                        namelist(name_counter).domain = specified_domain ;
                        namelist(name_counter).domain_item = specified_domain_item ;
                        
                        line = line + 1 ;
                        link_counter = link_counter + 1 ;
                        if bond.flow
                            ese(line) = specify_ese(branch,[2*inbond],branch,{name_counter},[]) ;
                            link(link_counter) = create_link(0,0,1,port_name,port.is_flow_state) ;
                        else
                            ese(line) = specify_ese(branch,{name_counter},branch,[2*inbond],[]) ;
                            link(link_counter) = create_link(1,0,1,port_name,port.is_flow_state) ;
                        end
                        
                        name_counter = name_counter + 1 ;
                        if port.is_effort_state
                            namelist(name_counter).var = [terminal,'.effort_state'] ;
                        else
                            namelist(name_counter).var = [terminal,'.effort'] ;
                        end
                        namelist(name_counter).domain = specified_domain ;
                        namelist(name_counter).domain_item = specified_domain_item ;
                        
                        line = line + 1 ;
                        link_counter = link_counter + 1 ;
                        if bond.effort
                            ese(line) = specify_ese(branch,{name_counter},branch,[2*inbond-1],[]) ;
                            link(link_counter) = create_link(1,1,0,port_name,port.is_effort_state) ;
                        else
                            ese(line) = specify_ese(branch,[2*inbond-1],branch,{name_counter},[]) ;
                            link(link_counter) = create_link(0,1,0,port_name,port.is_effort_state) ;
                        end
                    end
                    
                    if ~isempty(outbond)
                        bond = model.bond(outbond) ;
                        [specified_domain,specified_domain_item] = mttGetBondDomain(model,outbond) ;
                        
                        name_counter = name_counter + 1 ;
                        if port.is_flow_state
                            namelist(name_counter).var = [terminal,'.flow_state'] ;
                        else
                            namelist(name_counter).var = [terminal,'.flow'] ;
                        end
                        namelist(name_counter).domain = specified_domain ;
                        namelist(name_counter).domain_item = specified_domain_item ;
                        
                        line = line + 1 ;
                        link_counter = link_counter + 1 ;
                        if bond.flow
                            ese(line) = specify_ese(branch,{name_counter},branch,[2*outbond],[]) ;
                            link(link_counter) = create_link(1,0,1,port_name,port.is_flow_state) ;
                        else
                            ese(line) = specify_ese(branch,[2*outbond],branch,{name_counter},[]) ;
                            link(link_counter) = create_link(0,0,1,port_name,port.is_flow_state) ;
                        end
                        
                        name_counter = name_counter + 1 ;
                        if port.is_effort_state
                            namelist(name_counter).var = [terminal,'.effort_state'] ;
                        else
                            namelist(name_counter).var = [terminal,'.effort'] ;
                        end
                        namelist(name_counter).domain = specified_domain ;
                        namelist(name_counter).domain_item = specified_domain_item ;
                        
                        line = line + 1 ;
                        link_counter = link_counter + 1 ;
                        if bond.effort
                            ese(line) = specify_ese(branch,[2*outbond-1],branch,{name_counter},[]) ;
                            link(link_counter) = create_link(0,1,0,port_name,port.is_effort_state) ;
                        else
                            ese(line) = specify_ese(branch,{name_counter},branch,[2*outbond-1],[]) ;
                            link(link_counter) = create_link(1,1,0,port_name,port.is_effort_state) ;
                        end
                    end
                end
                
                
                input_mask = zeros(number_of_ports,1) ;
                output_mask = zeros(number_of_ports,1) ;
                
                number_of_links = link_counter ;
                linked = zeros(number_of_links,1) ;
                
                operators = object.cr.operator ;
                number_of_operators = length(operators) ;
                
                object.cr.used_operator = zeros(1,number_of_operators) ;
                
                op_counter = 0 ;
                
                matching = 1 ;
                while matching
                    op_counter = op_counter + 1 ;
                    operator = operators(op_counter) ;
                    
                    full_operator_name = [branch,'__',object_name,'___',operator.name] ;
                    
                    number_of_op_links = length(operator.link) ;
                    op_linked = zeros(number_of_op_links,1) ;
                    
                    for j = 1:number_of_op_links
                        k = 0 ;
                        comparing = 1 ;
                        while comparing
                            k = k + 1 ;
                            if compare_links(link(k),operator.link(j))
                                op_linked(j) = k ;
                                comparing = 0 ;
                            end
                            comparing = comparing & (k<number_of_links) ;
                        end
                    end
                    
                    
                    input_counter = 0 ;
                    output_counter = 0 ;
                    input = [] ;
                    output = [] ;
                    
                    if all(op_linked)
                        object.cr.used_operator(op_counter) = 1 ;
                        
                        interface = object.cr.interface ;
                        assigned_ports = mttGetFieldNames(operator,'assign') ;
                        for j = 1:length(assigned_ports)
                            port_name = assigned_ports{j} ;
                            next = getfield(operator.assign,port_name) ;
                            
                            actual_port = getfield(interface,'port',port_name) ;
                            if ~isempty(actual_port.assign)
                                previous = actual_port.assign ;
                                
                                for k = 1:length(next.covar)
                                    covar = next.covar{k} ;
                                    index = strmatch(covar,previous.covar,'exact') ;
                                    
                                    if ~isempty(index)
                                        mttAssert(strcmp(next.state{k},previous.state{k}),...
                                            ['Conflicting state assignments for port "',port_name,'.',covar,'" in ',here]) ;
                                    else
                                        actual_port.assign.state{index} = next.state{k} ;
                                    end
                                end
                            else
                                actual_port.assign = next ;
                            end
                            interface = setfield(interface,'port',port_name,actual_port) ;
                        end
%                        operator = mttDeleteField(operator,'assign') ;
                            
%                        object.cr.operator(op_counter) = operator ;
                        object.cr.interface = interface ;
                        model = setfield(model,'obj',object_name,object) ;
                        
                        
                        for j = 1:number_of_op_links
                            k = op_linked(j) ;
                            
                            linked(k) = 1 ;
                            link(k).is_unconstrained = operator.link(j).is_unconstrained ;
                            
                            current_link = link(k) ;
                            port_name = current_link.name ;
                            
                            port_index = strmatch(port_name,port_names,'exact') ;
                            
                            terminal = [branch,'__',object_name,'___',port_name] ;
                            
                            if current_link.is_effort
                                if current_link.is_state
                                    link_name{j} = [terminal,'.effort_state'] ;
                                else
                                    link_name{j} = [terminal,'.effort'] ;
                                end
                            end
                            if current_link.is_flow
                                if current_link.is_state
                                    link_name{j} = [terminal,'.flow_state'] ;
                                else
                                    link_name{j} = [terminal,'.flow'] ;
                                end
                            end
                            
                            matched_name_counter = strmatch(link_name{j},{namelist.var},'exact') ;
                            if current_link.is_input
                                input_mask(port_index) = 1 ;
                                
                                if current_link.is_unconstrained
                                    input_counter = input_counter + 1 ;
                                    input{input_counter} = matched_name_counter ;
                                end
                            else
                                mttAssert(~output_mask(port_index),...
                                    ['Over-determined output "',port_name,'" in operator ',full_operator_name]) ;
                                
                                output_mask(port_index) = 1 ;
                                
                                if current_link.is_unconstrained & ~current_link.is_state
                                    output_counter = output_counter + 1 ;
                                    output{output_counter} = matched_name_counter ;
                                end
                            end
                        end
                        
                        line = line + 1 ;
                        ese(line) = specify_ese(branch,output,branch,input,full_operator_name) ;
                        
                        for j = 1:number_of_op_links
                            k = op_linked(j) ;
                            current_link = link(k) ;
                            
                            matched_name_counter = strmatch(link_name{j},{namelist.var},'exact') ;
                            if ~current_link.is_input
                                if ~current_link.is_unconstrained
                                    line = line + 1 ;
                                    ese(line) = specify_ese(branch,{matched_name_counter},branch,{1},[]) ;
                                end
                            end
                        end
                    end
                    
                    
                    unused_inputs = ~all(input_mask) ;
                    unused_outputs = ~all(output_mask) ;
                    still_counting = op_counter<number_of_operators ;
                    
                    matching = (unused_inputs | unused_outputs) & (op_counter<number_of_operators) ;
                end
                
                mttAssert(all(input_mask),...
                    ['Unattached input(s) in "cr" implementation in ',here]) ;
                mttAssert(all(output_mask),...
                    ['Unattached output(s) in "cr" implementation in ',here]) ;
                mttAssert(all(linked),...
                    ['Unattached ports in "cr" implementation in ',here]) ;
            end
        end
    end
    
    for n = 1:length(objects)
        object_name = objects{n} ;
        object = getfield(model,'obj',object_name) ;
        
        here = [branch,':',object_name] ;
        
        
        if ~isempty(object.cr)
            operators = object.cr.operator ;
            number_of_operators = length(operators) ;
            
            object.cr = mttDeleteField(object.cr,'operator') ;
            used_counter = 0 ;
            
            for op_counter = 1:number_of_operators
                operator = operators(op_counter) ;
                if object.cr.used_operator(op_counter)
                    used_counter = used_counter + 1 ;
                    used_operator = operator ;
                    
%                    used_operator = mttDeleteField(used_operator,'is_used') ;
                    used_operator = mttDeleteField(used_operator,'assign') ;
                    object.cr.operator(used_counter) = used_operator ;
                end
            end
        end
        
        
        if ~isempty(object.abg)
            next_branch = [branch,'__',object_name] ;
            for j = 1:mttGetFieldLength(object,'interface')
                inbond = object.interface(j).in ;
                outbond = object.interface(j).out ;
                inmap = object.interface(j).map.in ;
                outmap = object.interface(j).map.out ;
                interface_class = object.interface(j).class ;
                
                if ~isempty(inbond)
                    bond = model.bond(inbond) ;
                    
                    line = line + 1 ;
                    if bond.flow
                        if strcmp(interface_class,'Se')
	                        ese(line) = specify_ese(branch,[2*inbond],next_branch,{1},[]) ;
                        else
	                        ese(line) = specify_ese(branch,[2*inbond],next_branch,[2*inmap],[]) ;
                        end
                    else
                        ese(line) = specify_ese(next_branch,[2*inmap],branch,[2*inbond],[]) ;
                    end
                    
                    line = line + 1 ;
                    if bond.effort
                        ese(line) = specify_ese(next_branch,[2*inmap-1],branch,[2*inbond-1],[]) ;
                    else
                        if strcmp(interface_class,'Sf')
                            ese(line) = specify_ese(branch,[2*inbond-1],next_branch,{1},[]) ;
                        else
                            ese(line) = specify_ese(branch,[2*inbond-1],next_branch,[2*inmap-1],[]) ;
                        end
                    end
                end
                
                if ~isempty(outbond)
                    bond = model.bond(outbond) ;
                    
                    line = line + 1 ;
                    if bond.flow
                        if strcmp(interface_class,'De')
                            ese(line) = specify_ese(next_branch,[2*outmap],branch,{1},[]) ;
                        else
                            ese(line) = specify_ese(next_branch,[2*outmap],branch,[2*outbond],[]) ;
                        end
                    else
                        ese(line) = specify_ese(branch,[2*outbond],next_branch,[2*outmap],[]) ;
                    end
                    
                    line = line + 1 ;
                    if bond.effort
                        ese(line) = specify_ese(branch,[2*outbond-1],next_branch,[2*outmap-1],[]) ;
                    else
                        if strcmp(interface_class,'Df')
                            ese(line) = specify_ese(next_branch,[2*outmap-1],branch,{1},[]) ;
                        else
                            ese(line) = specify_ese(next_branch,[2*outmap-1],branch,[2*outbond-1],[]) ;
                        end
                    end
                end
            end

            [object,object_ese,object_namelist] = specify_equations(object,next_branch,namelist) ;
            model = setfield(model,'obj',object_name,object) ;
            
            ese = [ese, object_ese] ;
            line = length(ese) ;
            
			namelist = object_namelist ;
        end
        
        object.cr = mttDeleteField(object.cr,'used_operator') ;
        model = setfield(model,'obj',object_name,object) ;
    end
    
    
function equation = specify_ese(LHS_branch,LHS_var,RHS_branch,RHS_var,operator)
    equation.branch.LHS = LHS_branch ;
    equation.branch.RHS = RHS_branch ;
    equation.var.LHS = LHS_var ;
    equation.var.RHS = RHS_var ;
    equation.operator = operator ;
    
    
function [branchlist,branchbond] = identify_branches(model,branch)
    is_root_model = (nargin==1) ;
    
    if is_root_model
        branch = mttDetachText(model.source,'/') ;
        branchlist{1} = branch ;
        branchbond = length(model.bond) ;
        counter = 1 ;
    else
        branchlist = [] ;
        branchbond = 0 ;
        counter = 0 ;
    end

    objects = mttGetFieldNames(model,'obj') ;
    
    for n = 1:length(objects)
        object_name = objects{n} ;
        
        object = getfield(model,'obj',object_name) ;
        next_branch = [branch,'__',object_name] ;
        [next_branchlist,next_branchbond] = identify_branches(object,next_branch) ;
        
        counter = counter + 1 ;
        branchlist{counter} = next_branch ;

        if isfield(object,'bond')
            branchbond(counter) = length(object.bond) ;
        else
            branchbond(counter) = 0 ;
        end
        
        for i = 1:length(next_branchlist)
            counter = counter + 1 ;
            branchlist{counter} = next_branchlist{i} ;
            branchbond(counter) = next_branchbond(i) ;
        end
    end
    
    
function [sse,sorted_equations] = sort_equations(ese,model,namelist)
    mttWriteNewLine ;
    mttNotify('...sorting equations') ;
    mttWriteNewLine ;
    
    [branchlist,branchbond] = identify_branches(model) ;
    lastvar = cumsum(2*branchbond) ;
    offsetvar = lastvar - 2*branchbond ;
    
    number_of_equations = length(ese) ;
%    number_of_covariables = length(namelist) - 1 ;
%    number_of_interface_variables = max(lastvar) ;
    number_of_covariables = max(lastvar) ;
    number_of_interface_variables = length(namelist) - 1 ;
    
    mttNotifyEquationSummary(number_of_equations,number_of_covariables,number_of_interface_variables) ;
    
    for i = 1:length(ese)
        if isempty(ese(i).operator)
            var = ese(i).var.LHS ;
            switch class(var)
            case 'double',
                branch_index = strmatch(ese(i).branch.LHS,branchlist,'exact') ;
                info(i).LHS = abs(var) + offsetvar(branch_index) ;
            case 'cell',
                info(i).LHS = ese(i).var.LHS ;
            end
            
            var = ese(i).var.RHS ;
            switch class(var)
            case 'double',
                branch_index = strmatch(ese(i).branch.RHS,branchlist,'exact') ;
                for j = 1:length(var)
                    info(i).RHS(j) = abs(var(j)) + offsetvar(branch_index) ;
                end
            case 'cell',
                info(i).RHS = ese(i).var.RHS ;
            end
        else
            info(i).LHS = ese(i).var.LHS ;
            info(i).RHS = ese(i).var.RHS ;
        end
    end
    
    
    var_known = zeros(max(lastvar),1) ;
    name_known = zeros(length(namelist),1) ;
    name_known(1) = 1 ;
    
    log = ones(length(ese),1) ;
    map = zeros(length(ese),1) ;
    
    counter = 0 ;
    
    for i = 1:length(ese)
        if log(i) & isempty(ese(i).operator)
            left = info(i).LHS ;
            right = info(i).RHS ;
                
            if isnumeric(left) & iscell(right)
                name = namelist(right{1}).var ;
                is_object_interface = ~isempty(findstr(name,'___')) ;
                
                ok = 1 ;
                if is_object_interface
                    is_effort_state = ~isempty(findstr(name,'.effort_state')) ;
                    is_flow_state = ~isempty(findstr(name,'.flow_state')) ;
                    ok = is_effort_state | is_flow_state ;
                end
                
                if ok
                    log(i) = 0 ;
                    counter = counter + 1 ;
                    map(counter) = i ;
                    
                    var_known(left) = 1 ;
                    name_index = strmatch(name,{namelist.var},'exact') ;
                    name_known(name_index) = 1 ;
                end
            end
            
            if iscell(left) & iscell(right)
                if right{1}==1
                    log(i) = 0 ;
                    counter = counter + 1 ;
                    map(counter) = i ;
                    
                    name = namelist(left{1}).var ;
                    name_index = strmatch(name,{namelist.var},'exact') ;
                    name_known(name_index) = 1 ;
                end
            end
        end
    end
    
    previous_var_known = var_known ;
    previous_name_known = name_known ;
    
    sort_iteration = 0 ;
    
    sorting = 1 ;
    while sorting
        sort_iteration = sort_iteration + 1 ;
        
        for i = 1:length(ese)
            if log(i) & isempty(ese(i).operator)
                left = info(i).LHS ;
                right = info(i).RHS ;
                
                if isnumeric(right)
                    if all(var_known(right))
                        log(i) = 0 ;
                        counter = counter + 1 ;
                        map(counter) = i ;
                        
                        if isnumeric(left)
                            var_known(left) = 1 ;
                        else
                            name = namelist(left{1}).var ;
                            name_index = strmatch(name,{namelist.var},'exact') ;
                            name_known(name_index) = 1 ;
                        end
                    end
                else
                    name = namelist(right{1}).var ;
                    name_index = strmatch(name,{namelist.var},'exact') ;
                    if name_known(name_index)
                        is_object_interface = ~isempty(findstr(name,'___')) ;
                        
                        if is_object_interface
                            log(i) = 0 ;
                            counter = counter + 1 ;
                            map(counter) = i ;
                            
                            var_known(left) = 1 ;
                        end
                    end
                end
            end
        end
        
        for i = 1:length(ese)
            if log(i) & ~isempty(ese(i).operator)
                left = info(i).LHS ;
                right = info(i).RHS ;
                
                indices = [] ;
                for j = 1:length(right)
                    name = namelist(right{j}).var ;
                    indices(j) = strmatch(name,{namelist.var},'exact') ;
                end
                
                if all(name_known(indices))
                    log(i) = 0 ;
                    counter = counter + 1 ;
                    map(counter) = i ;
                    for j = 1:length(left)
                        name = namelist(left{j}).var ;
                        name_index = strmatch(name,{namelist.var},'exact') ;
                        name_known(name_index) = 1 ;
                    end
                end
            end
        end
        
        same_vars_known = sum(var_known)==sum(previous_var_known) ;
        same_names_known = sum(name_known)==sum(previous_name_known) ;
        
        previous_var_known = var_known ;
        previous_name_known = name_known ;
        
        sorting = ~(same_vars_known & same_names_known) ;
        
        if sorting
            mttNotify(['...iteration ',num2str(sort_iteration)]) ;
            mttWriteNewLine ;
%            is_complete = ...
%                mttNotifyEquationSort(sort_iteration,...
%	             sum(log),number_of_equations,...
%                sum(name_known),number_of_covariables,...
%                sum(var_known),number_of_interface_variables) ;
            is_complete = ...
                mttNotifyEquationSort(sort_iteration,...
	            sum(log),number_of_equations,...
                sum(var_known),number_of_covariables,...
                sum(name_known),number_of_interface_variables) ;
            
            sorting = sorting & ~is_complete ;
        end
    end

    for i = 1:length(ese)
        if log(i) & isempty(ese(i).operator)
            left = info(i).LHS ;
            right = info(i).RHS ;
                
            if iscell(left) & isnumeric(right)
                name = namelist(left{1}).var ;
                is_object_interface = ~isempty(findstr(name,'___')) ;
                    
                if ~is_object_interface
                    if var_known(right)
                        log(i) = 0 ;
                        counter = counter + 1 ;
                        map(counter) = i ;
                        
                        name_index = strmatch(name,{namelist.var},'exact') ;
                        name_known(name_index) = 1 ;
                    end
                end
            end
        end
    end
    
    sorted_equations = counter ;
    
    if sorted_equations<number_of_equations
	    mttWriteNewLine ;
        mttNotify(['...unable to sort equations completely']) ;
	    mttWriteNewLine ;
        mttNotifyEquationSortProblems(name_known,namelist) ;
    end
    
    for i = 1:length(ese)
        if log(i)
            counter = counter + 1 ;
            map(counter) = i ;
        end
    end
    
    mttAssert(counter==length(ese),'Sort algorithm has failed! Seek expert assistance!') ;
    
	for i = 1:length(ese)
    	sse(i) = ese(map(i)) ;
    end
    
    
function link = create_link(is_input,is_effort,is_flow,name,is_state)
    link.is_input    = is_input ;
    link.is_effort   = is_effort ;
    link.is_flow     = is_flow ;
    link.name        = name ;
    link.is_state    = is_state ;
    
    link.is_unconstrained = [] ;
    
    
function boolean = compare_links(actual_link,op_link)
    input_is_same  = actual_link.is_input==op_link.is_input ;
    effort_is_same = actual_link.is_effort==op_link.is_effort ;
    flow_is_same   = actual_link.is_flow==op_link.is_flow ;
    name_is_same   = strcmp(actual_link.name,op_link.name) ;
    
    boolean = input_is_same & effort_is_same & flow_is_same & name_is_same ;
    
