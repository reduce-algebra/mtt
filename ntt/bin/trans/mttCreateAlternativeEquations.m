function ese = mttCreateAlternativeEquations(model)

ese = write_equations(model) ;
ese = ese' ;

filename = [model.source,'_ese.txt'] ;
fid = fopen(filename,'w') ;

fprintf(fid,['// Elementary System Equations\n']) ;
fprintf(fid,'\n') ;
fprintf(fid,['// file: ',filename,'\n']) ;
fprintf(fid,['// written by MTT on ',datestr(now),'\n']) ;
fprintf(fid,'\n\n') ;

fprintf(fid,['ese ',mttDetachText(model.source,'/'),' {']) ;
fprintf(fid,'\n') ;

tab = char(32*ones(1,3)) ;

for i = 1:length(ese)
    fprintf(fid,[tab,ese{i},'\n']) ;
end

fprintf(fid,'}') ;

fclose(fid) ;



function ese = write_equations(model,branch)
    is_root_model = (nargin==1) ;

    if is_root_model
        branch = mttDetachText(model.source,'/') ;
    end
    
%    ese{1} = ' ' ;
%    ese{2} = ['// ESE representation for module: ',branch] ;
%    ese{3} = ' ' ;
%    
%    line = 3 ;

    line = 0 ;
    
    indent = char(32*ones(1,6)) ;

    
    objects = mttGetFieldNames(model,'obj') ;
    
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        here = [branch,':',object_name] ;
        
        switch object.class
        case 'SS',
            
            for j = 1:mttGetFieldLength(object,'interface')
                flow_equation = [] ;
                effort_equation = [] ;
                
                port_name = object.interface(j).name ;
                
                inbond = object.interface(j).in ;
                outbond = object.interface(j).out ;
                
                if ~isempty(inbond)
                    bond = model.bond(inbond) ;
                    
                    extern = [branch,'__',object_name,'___flow'] ;
                    intern = [branch,'___f[',num2str(inbond),']'] ;
                    if bond.flow
                        flow_equation = [intern,' = ',extern,' ;'] ;
                    else
                        flow_equation = [extern,' = ',intern,' ;'] ;
                    end
                    
                    extern = [branch,'__',object_name,'___effort'] ;
                    intern = [branch,'___e[',num2str(inbond),']'] ;
                    if bond.effort
                        effort_equation = [extern,' = ',intern,' ;'] ;
                    else
                        effort_equation = [intern,' = ',extern,' ;'] ;
                    end
                    
                    line = line + 1 ;
                    ese{line} = flow_equation ;
                    
                    line = line + 1 ;
                    ese{line} = effort_equation ;
                end
                
                if ~isempty(outbond)
                    bond = model.bond(outbond) ;
                    
                    extern = [branch,'__',object_name,'___flow'] ;
                    intern = [branch,'___f[',num2str(outbond),']'] ;
                    if bond.flow
                        flow_equation = [extern,' = ',intern,' ;'] ;
                    else
                        flow_equation = [intern,' = ',extern,' ;'] ;
                    end
                    
                    extern = [branch,'__',object_name,'___effort'] ;
                    intern = [branch,'___e[',num2str(outbond),']'] ;
                    if bond.effort
                        effort_equation = [intern,' = ',extern,' ;'] ;
                    else
                        effort_equation = [extern,' = ',intern,' ;'] ;
                    end
                    
                    line = line + 1 ;
                    ese{line} = flow_equation ;
                    
                    line = line + 1 ;
                    ese{line} = effort_equation ;
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
                
                [effort(i),flow(i)] = mttGetBondCausality(model,bond_number(i)) ;
                
                if effort(i)==orientation(i)
                    imposed_effort_bond = bond_number(i) ;
                    imposed_effort = [branch,'___e[',num2str(imposed_effort_bond),']'] ;
                end
                if flow(i)==orientation(i)
                    resultant_flow_bond = bond_number(i) ;
                    resultant_flow = [branch,'___f[',num2str(resultant_flow_bond),']'] ;
                end
            end
            
            
            for i = 1:mttGetFieldLength(object,'interface')
                if bond_number(i)~=imposed_effort_bond
                    line = line + 1 ;
                    derived_effort = [branch,'___e[',num2str(bond_number(i)),']'] ;
                    ese{line} = [derived_effort,' = ',imposed_effort,' ;'] ;
                end
            end
            
            waiting = 1 ;
            offset = char(32*ones(1,length(resultant_flow)+1)) ;
            
            for i = 1:mttGetFieldLength(object,'interface')
                next_flow = [] ;
                
                if bond_number(i)~=resultant_flow_bond
                    next_flow = [branch,'___f[',num2str(bond_number(i)),']'] ;
                    line = line + 1 ;
                    
                    if waiting
                        if orientation(i)
                            ese{line} = [resultant_flow,' = ',next_flow] ;
                        else
                            ese{line} = [resultant_flow,' = -',next_flow] ;
                        end
                        waiting = 0 ;
                    else
                        if orientation(i)
	                        ese{line} = [offset,'+ ',next_flow] ;
                        else
    	                    ese{line} = [offset,'- ',next_flow] ;
                        end
                    end
                end
            end
            ese{line} = [ese{line},' ;'] ;
            
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
                
                [effort(i),flow(i)] = mttGetBondCausality(model,bond_number(i)) ;
                
                if flow(i)~=orientation(i)
                    imposed_flow_bond = bond_number(i) ;
                    imposed_flow = [branch,'___f[',num2str(imposed_flow_bond),']'] ;
                end
                if effort(i)~=orientation(i)
                    resultant_effort_bond = bond_number(i) ;
                    resultant_effort = [branch,'___e[',num2str(resultant_effort_bond),']'] ;
                end
            end
            
            
            for i = 1:mttGetFieldLength(object,'interface')
                if bond_number(i)~=imposed_flow_bond
                    line = line + 1 ;
                    derived_flow = [branch,'___f[',num2str(bond_number(i)),']'] ;
                    ese{line} = [derived_flow,' = ',imposed_flow,' ;'] ;
                end
            end
            
            waiting = 1 ;
            offset = char(32*ones(1,length(resultant_effort)+1)) ;
            
            for i = 1:mttGetFieldLength(object,'interface')
                next_effort = [] ;
                
                if bond_number(i)~=resultant_effort_bond
                    next_effort = [branch,'___e[',num2str(bond_number(i)),']'] ;
                    line = line + 1 ;
                    
                    if waiting
                        if orientation(i)
                            ese{line} = [resultant_effort,' = ',next_effort] ;
                        else
                            ese{line} = [resultant_effort,' = -',next_effort] ;
                        end
                        waiting = 0 ;
                    else
                        if orientation(i)
	                        ese{line} = [offset,'+ ',next_effort] ;
                        else
    	                    ese{line} = [offset,'- ',next_effort] ;
                        end
                    end
                end
            end
            ese{line} = [ese{line},' ;'] ;
            
        otherwise,
            
            if ~isempty(object.cr)
                operators = object.cr.operator ;
                interface = object.cr.interface ;
                port_names = mttGetFieldNames(interface,'port') ;
                
                link_counter = 0 ;
                
                for i = 1:length(port_names)
                    port_name = port_names{i} ;
                    port = getfield(interface,'port',port_name) ;
                    terminal = [branch,'__',object_name,'___',port_name] ;
                    
                    inbond = port.in ;
                    outbond = port.out ;
                    
                    if ~isempty(inbond)
                        bond = model.bond(inbond) ;
                        
                        intern = [branch,'___f[',num2str(inbond),']'] ;
                        if bond.flow
                            link_counter = link_counter + 1 ;
                            link(link_counter) = create_link(0,0,1,port_name,port.is_flow_state) ;
                            
                            if port.is_flow_state
                                flow_equation = [intern,' = ',terminal,'___flow_state ;'] ;
                            else
                                flow_equation = [intern,' = ',terminal,'___flow ;'] ;
                            end
                        else
                            link_counter = link_counter + 1 ;
                            link(link_counter) = create_link(1,0,1,port_name,port.is_flow_state) ;
                            
                            if port.is_flow_state
                                flow_equation = [terminal,'___flow_state = ',intern,' ;'] ;
                            else
                                flow_equation = [terminal,'___flow = ',intern,' ;'] ;
                            end
                        end
                        
                        intern = [branch,'___e[',num2str(inbond),']'] ;
                        if bond.effort
                            link_counter = link_counter + 1 ;
                            link(link_counter) = create_link(1,1,0,port_name,port.is_effort_state) ;
                            
                            if port.is_effort_state
                                effort_equation = [terminal,'___effort_state = ',intern,' ;'] ;
                            else
                                effort_equation = [terminal,'___effort = ',intern,' ;'] ;
                            end
                        else
                            link_counter = link_counter + 1 ;
                            link(link_counter) = create_link(0,1,0,port_name,port.is_effort_state) ;
                            
                            if port.is_effort_state
                                effort_equation = [intern,' = ',terminal,'___effort_state ;'] ;
                            else
                                effort_equation = [intern,' = ',terminal,'___effort ;'] ;
                            end
                        end
                        
                        line = line + 1 ;
                        ese{line} = flow_equation ;
                        
                        line = line + 1 ;
                        ese{line} = effort_equation ;
                    end                                
                    
                    if ~isempty(outbond)
                        bond = model.bond(outbond) ;
                        
                        intern = [branch,'___f[',num2str(outbond),']'] ;
                        if bond.flow
                            link_counter = link_counter + 1 ;
                            link(link_counter) = create_link(1,0,1,port_name,port.is_flow_state) ;
                            
                            if port.is_flow_state
                                flow_equation = [terminal,'___flow_state = ',intern,' ;'] ;
                            else
                                flow_equation = [terminal,'___flow = ',intern,' ;'] ;
                            end
                        else
                            link_counter = link_counter + 1 ;
                            link(link_counter) = create_link(0,0,1,port_name,port.is_flow_state) ;
                            
                            if port.is_flow_state
                                flow_equation = [intern,' = ',terminal,'___flow_state ;'] ;
                            else
                                flow_equation = [intern,' = ',terminal,'___flow ;'] ;
                            end
                        end
                        
                        intern = [branch,'___e[',num2str(outbond),']'] ;
                        if bond.effort
                            link_counter = link_counter + 1 ;
                            link(link_counter) = create_link(0,1,0,port_name,port.is_effort_state) ;
                            
                            if port.is_effort_state
                                effort_equation = [intern,' = ',terminal,'___effort_state ;'] ;
                            else
                                effort_equation = [intern,' = ',terminal,'___effort ;'] ;
                            end
                        else
                            link_counter = link_counter + 1 ;
                            link(link_counter) = create_link(1,1,0,port_name,port.is_effort_state) ;
                            
                            if port.is_effort_state
                                effort_equation = [terminal,'___effort_state = ',intern,' ;'] ;
                            else
                                effort_equation = [terminal,'___effort = ',intern,' ;'] ;
                            end
                        end
                        
                        line = line + 1 ;
                        ese{line} = flow_equation ;
                        
                        line = line + 1 ;
                        ese{line} = effort_equation ;
                    end
                end
                
                number_of_operators = length(operators) ;
                op_counter = 1 ;
                
                matching = 1 ;
                while matching
                    operator = operators(op_counter) ;
                    
                    links = length(link) ;
                    op_links = length(operator.link) ;
                    op_linked = zeros(op_links,1) ;
                    
                    for j = 1:op_links
                        for k = 1:links
                            if compare_links(link(k),operator.link(j))
                                op_linked(j) = k ;
                                break ;
                            end
                        end
                    end
                    
                    input_counter = 0 ;
                    output_counter = 0 ;
                    input = [] ;
                    output = [] ;
                    
                    if all(op_linked)
                        for j = 1:op_links
                            current_link = link(op_linked(j)) ;
                            port_name = current_link.name ;
                            
                            if current_link.is_effort
                                if current_link.is_state
                                    link_name = [branch,'__',object_name,'___',port_name,'___effort_state'] ;
                                else
                                    link_name = [branch,'__',object_name,'___',port_name,'___effort'] ;
                                end
                            end
                            if current_link.is_flow
                                if current_link.is_state
                                    link_name = [branch,'__',object_name,'___',port_name,'___flow_state'] ;
                                else
                                    link_name = [branch,'__',object_name,'___',port_name,'___flow'] ;
                                end
                            end
                            if current_link.is_input
                                input_counter = input_counter + 1 ;
                                input{input_counter} = link_name ;
                            else
                                output_counter = output_counter + 1 ;
                                output{output_counter} = link_name ;
                            end
                        end
                        
                        if input_counter>0
                            input_list = ['[',input{1}] ;
                            for j = 2:input_counter
                                input_list = [input_list,',',input{j}] ;
                            end
                            input_list = [input_list,']'] ;
                        end
                        
                        if output_counter>0
                            output_list = ['[',output{1}] ;
                            for j = 2:output_counter
                                output_list = [output_list,',',output{j}] ;
                            end
                            output_list = [output_list,']'] ;
                        end
                        
                        if input_counter>0
                            line = line + 1 ;
                            ese{line} = [output_list,' = '] ;
                        end
                        
                        line = line + 1 ;
                        ese{line} = [indent,branch,'__',object_name,'___',operator.name] ;
                        
                        if output_counter>0                                
                            line = line + 1 ;
                            ese{line} = [indent,indent,input_list,' ;'] ;
                        end
                        
                        link(op_linked) = [] ;
                    end
                    
                    op_counter = op_counter + 1 ;
                    matching = ~isempty(link) & (op_counter<=number_of_operators) ;
                end
                
                mttAssert(isempty(link),...
                    ['Unattached ports in "cr" implementation in ',here]) ;
            end
        end
    end
    
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        here = [branch,':',object_name] ;
        
        if ~isempty(object.abg)
            for j = 1:mttGetFieldLength(object,'interface')
                inbond = object.interface(j).in ;
                outbond = object.interface(j).out ;
                inmap = object.interface(j).map.in ;
                outmap = object.interface(j).map.out ;
                
                line = line + 1 ;
                ese{line} = ' ' ;
                
                if ~isempty(inbond)
                    bond = model.bond(inbond) ;
                    
                    extern = [branch,'__',object_name,'___f[',num2str(inmap),']'] ;
                    intern = [branch,'___f[',num2str(inbond),']'] ;
                    if bond.flow
                        flow_equation = [intern,' = ',extern,' ;'] ;
                    else
                        flow_equation = [extern,' = ',intern,' ;'] ;
                    end
                    
                    extern = [branch,'__',object_name,'___e[',num2str(inmap),']'] ;
                    intern = [branch,'___e[',num2str(inbond),']'] ;
                    if bond.effort
                        effort_equation = [extern,' = ',intern,' ;'] ;
                    else
                        effort_equation = [intern,' = ',extern,' ;'] ;
                    end
                    
                    line = line + 1 ;
                    ese{line} = flow_equation ;
                    
                    line = line + 1 ;
                    ese{line} = effort_equation ;
                end
                
                if ~isempty(outbond)
                    bond = model.bond(outbond) ;
                    
                    extern = [branch,'__',object_name,'___f[',num2str(outmap),']'] ;
                    intern = [branch,'___f[',num2str(outbond),']'] ;
                    if bond.flow
                        flow_equation = [extern,' = ',intern,' ;'] ;
                    else
                        flow_equation = [intern,' = ',extern,' ;'] ;
                    end
                    
                    extern = [branch,'__',object_name,'___e[',num2str(outmap),']'] ;
                    intern = [branch,'___e[',num2str(outbond),']'] ;
                    if bond.effort
                        effort_equation = [intern,' = ',extern,' ;'] ;
                    else
                        effort_equation = [extern,' = ',intern,' ;'] ;
                    end
                    
                    line = line + 1 ;
                    ese{line} = flow_equation ;
                    
                    line = line + 1 ;
                    ese{line} = effort_equation ;
                end
            end
            next_branch = [branch,'__',object_name] ;
            
            object_ese = write_equations(object,next_branch) ;
            
            ese = [ese, object_ese] ;
            line = length(ese) ;
        end
    end
    
    
function link = create_link(is_input,is_effort,is_flow,name,is_state)
    link.is_input    = is_input ;
    link.is_effort   = is_effort ;
    link.is_flow     = is_flow ;
    link.name        = name ;
    link.is_state    = is_state ;
    
function boolean = compare_links(actual_link,op_link)
    input_is_same  = actual_link.is_input==op_link.is_input ;
    effort_is_same = actual_link.is_effort==op_link.is_effort ;
    flow_is_same   = actual_link.is_flow==op_link.is_flow ;
    name_is_same   = strcmp(actual_link.name,op_link.name) ;
    
    boolean = input_is_same & effort_is_same & flow_is_same & name_is_same ;
    
    
