function mttWriteSystemEquations(model)

[eqn,ini] = format_equations(model) ;
write_equations(eqn,ini,model) ;


function [eqn,ini] = format_equations(model)
    mttNotify('...formating ordinary differential equations') ;
    mttWriteNewLine ;
    
    sse = model.equation ;
    namelist = model.namelist ;
    
    tab = char(32*ones(1,3)) ;
                
    eqn_counter = 0 ;
    ini_counter = 0 ;
    
    eqn = [] ;
    ini = [] ;
    
    for i = 1:length(sse)
        content = [] ;
        indent = 0 ;
        
        if isempty(sse(i).operator)
            Lvar = sse(i).var.LHS ;
            Rvar = sse(i).var.RHS ;
            
            if isnumeric(Lvar) | isnumeric(Rvar)
                if isnumeric(Lvar)
                    name = sse(i).branch.LHS ;
                    if mod(Lvar,2)
                        bond_number = (Lvar+1)/2 ;
                    else
                        bond_number = Lvar/2 ;
                    end
                else
                    name = sse(i).branch.RHS ;
                    if mod(Rvar,2)
                        bond_number = (Rvar+1)/2 ;
                    else
                        bond_number = Rvar/2 ;
                    end
                end
                
                [hierarchy,interface] = mttCutText(name,'___') ;
                level = length(findstr(hierarchy,'__')) ;
                
                [root,hierarchy] = mttCutText(hierarchy,'__') ;
                for j = 1:level
                    [obj{j},hierarchy] = mttCutText(hierarchy,'__') ;
                end
                
                if level==0
                    local_object = model ;
                else
                    local_object = getfield(model,'obj',obj{1}) ;
                    for j = 2:level
                        local_object = getfield(local_object,'obj',obj{j}) ;
                    end
                end
                
                [specified_domain,specified_domain_item] = mttGetBondDomain(local_object,bond_number) ;
                
            else
                [name,covar] = mttCutText(namelist(Lvar{1}).var,'.') ;
                [hierarchy,interface] = mttCutText(name,'___') ;
                level = length(findstr(hierarchy,'__')) ;
                
                [root,hierarchy] = mttCutText(hierarchy,'__') ;
                for j = 1:level
                    [obj{j},hierarchy] = mttCutText(hierarchy,'__') ;
                end
                
                parent_object = model ;
                object = getfield(model,'obj',obj{1}) ;
                
                for j = 2:level
                    parent_object = object ;
                    object = getfield(object,'obj',obj{j}) ;
                end
                
                index = strmatch(interface,{object.interface.name},'exact') ;
                interface_definition = object.interface(index) ;
                
                if isempty(interface_definition.in)
                    bond_number = interface_definition.out ;
                else
                    bond_number = interface_definition.in ;
                end
                
                [specified_domain,specified_domain_item] = mttGetBondDomain(parent_object,bond_number) ;
            end
            
            covariables = mttGetCovariables(model.env,specified_domain,specified_domain_item) ;
            
            dimension = length(covariables.effort) ;
            
            
            
            var = sse(i).var.LHS ;
            branch = sse(i).branch.LHS ;
            
            LHS.name = [] ;
            LHS.is_effort = [] ;
            
            switch class(var)
            case 'double',
                if mod(var,2)
%                    LHS.name = [branch,'[',num2str((var+1)/2),']'] ;
                    LHS.name = [branch,'__',num2str((var+1)/2)] ;
                    LHS.is_effort = 1 ;
                else
%                    LHS.name = [branch,'[',num2str(var/2),']'] ;
                    LHS.name = [branch,'__',num2str(var/2)] ;
                    LHS.is_effort = 0 ;
                end
            case 'cell',
                [name,covar] = mttCutText(namelist(var{1}).var,'.') ;
                LHS.name = name ;
                
                if strcmp(covar,'effort')
                    LHS.is_effort = 1 ;
                else
                    LHS.is_effort = 0 ;
                end
            end
            
            
            var = sse(i).var.RHS ;
            branch = sse(i).branch.RHS ;
            
            RHS.name = [] ;
            RHS.is_effort = [] ;
            
            
            switch class(var)
            case 'double',
                if mod(abs(var(1)),2)
%                    RHS.name{1} = [branch,'[',num2str((abs(var(1))+1)/2),']'] ;
                    RHS.name{1} = [branch,'__',num2str((abs(var(1))+1)/2)] ;
                    RHS.is_effort(1) = 1 ;
                else
%                    RHS.name{1} = [branch,'[',num2str(abs(var(1))/2),']'] ;
                    RHS.name{1} = [branch,'__',num2str(abs(var(1))/2)] ;
                    RHS.is_effort(1) = 0 ;
                end
                
                if var(1)<0
                    RHS.name{1} = ['-',RHS.name{1}] ;
                end
                
                for j = 2:length(var)
                    if mod(abs(var(j)),2)
%                        RHS.name{j} = [branch,'[',num2str((abs(var(j))+1)/2),']'] ;
                        RHS.name{j} = [branch,'__',num2str((abs(var(j))+1)/2)] ;
                    	RHS.is_effort(j) = 1 ;
                    else
%                        RHS.name{j} = [branch,'[',num2str(abs(var(j))/2),']'] ;
                        RHS.name{j} = [branch,'__',num2str(abs(var(j))/2)] ;
                    	RHS.is_effort(j) = 0 ;
                    end
                    
                    if var(j)>0
                        RHS.name{j} = [' + ',RHS.name{j}] ;
                    else
                        RHS.name{j} = [' - ',RHS.name{j}] ;
                    end
                end
                
            case 'cell',
                [name,covar] = mttCutText(namelist(var{1}).var,'.') ;
                RHS.name{1} = name ;
                
                if strcmp(covar,'effort') | strcmp(covar,'effort_state')
                    RHS.is_effort = 1 ;
                else
                    RHS.is_effort = 0 ;
                end
            end
            
            for k = 1:dimension
                if LHS.is_effort
                    covar = covariables.effort{k} ;
                else
                    covar = covariables.flow{k} ;
                end
                
                content = [LHS.name,'.',strrep(covar,'.','__')] ;
                indent = char(32*ones(1,length(content)+3)) ;
                
                for j = 1:length(RHS.name)
                    if RHS.is_effort(j)
                        covar = covariables.effort{k} ;
                    else
                        covar = covariables.flow{k} ;
                    end
                    
                    if j==1
                        if strcmp(RHS.name{1},'0')
                            content = [content,' = ',RHS.name{1}] ;
                        else
                            content = [content,' = ',RHS.name{1},'.',strrep(covar,'.','__')] ;
                        end
                    else
                        content = [content,'\n',indent,RHS.name{j},'.',strrep(covar,'.','__')] ;
                    end
                end
                
                content = [content,' ;'] ;
                
                if ~isempty(content)
                    eqn_counter = eqn_counter + 1 ;
                    eqn{eqn_counter} = content ;
                end
            end
            
        else
            op = [sse(i).operator] ;
            [cr,operator] = mttCutText(op,'___') ;
			
            if ~strcmp(eqn{eqn_counter},'')
                eqn_counter = eqn_counter + 1 ;
                eqn{eqn_counter} = [''] ;
            end
            eqn_counter = eqn_counter + 1 ;
            eqn{eqn_counter} = ['// ',op] ; 
            
            
            [root,hierarchy] = mttCutText(cr,'__') ;
            
            level = length(findstr(cr,'__')) ;
            for j = 1:level
                [obj{j},hierarchy] = mttCutText(hierarchy,'__') ;
            end
            
            object = getfield(model,'obj',obj{1}) ;
            for j = 2:level
                object = getfield(object,'obj',obj{j}) ;
            end
            
            index = strmatch(operator,{object.cr.operator.name},'exact') ;
            cr_definition = object.cr ;
            operator_definition = cr_definition.operator(index) ;
            
            
            
            structlist = [] ;
            if ~isempty(operator_definition.struct)
                struct_names = mttGetFieldNames(operator_definition,'struct') ;
                number_of_structs = length(struct_names) ;
                for i = 1:number_of_structs
                    struct_name = struct_names{i} ;
                    variables = getfield(operator_definition,'struct',struct_name) ;
                    if i==1
                        structlist = variables ;
                    else
                        structlist = [structlist,variables] ;
                    end
                end
            end
            
            
            
            
            reassigned_state_list = [] ;
            counter = 0 ;
            
            
            port_names = mttGetFieldNames(cr_definition.interface,'port') ;
            for j = 1:length(port_names)
                port_name = port_names{j} ;
                port = getfield(cr_definition,'interface','port',port_name) ;
                
                if ~isempty(port.assign)
                    assignment = port.assign ;
                    
                                
                    if port.was_generic & ~isempty(port.domain)
                        covar = mttGetCovariables(model.env,port.domain,port.domain_item) ;
                        if port.is_effort_state
                            covar = covariables.effort ;
                        else
                            covar = covariables.flow ;
                        end
                        
                        for k = 1:length(assignment.state)
                            counter = counter + 1 ;
                            reassigned_state_list.name{counter} = assignment.state{k} ;
                            reassigned_state_list.covar{counter} = covar ;
                        end
                        
                        
                        block_size = length(covar) ;
                        for var = 1:block_size
                            segment = [] ;
                            
                            for k = 1:length(assignment.state)
                                segment{1} = [cr,'___',port_name,'.',strrep(covar{var},'.','__')] ;
                                segment{2} = [' = '] ;
                                segment{3} = [cr,'___',assignment.state{k},'___',strrep(covar{var},'.','__'),'.state ;'] ;
                                
                                ini_counter = ini_counter + 1 ;
                                ini{ini_counter} = [segment{1},segment{2},segment{3}] ;
                            end                        
                        end
                    else
                        
                        for k = 1:length(assignment.state)
                            segment{1} = [cr,'___',port_name,'.',strrep(assignment.covar{k},'.','__')] ;
                            segment{2} = [' = '] ;
                            segment{3} = [cr,'___',assignment.state{k},'.state ;'] ;
                            
                            ini_counter = ini_counter + 1 ;
                            ini{ini_counter} = [segment{1},segment{2},segment{3}] ;
                        end
                    end                        
                end
            end
            
            
            equations = operator_definition.equation ;
            for j = 1:length(equations)
                equation = equations(j) ;
                number_of_chunks = mttGetFieldLength(equation,'chunk') ;
                
                equation.domain = [] ;
                equation.domain_item = [] ;
                
                for k = 1:number_of_chunks
                    chunk = equation.chunk{k} ;
                    
                    switch class(chunk)
                    case 'cell'
                        type = chunk{1} ;
                        index = chunk{2} ;
                        
                        switch type
                        case 'link'
                            port_name = operator_definition.link(index).name ;
			                port = getfield(cr_definition,'interface','port',port_name) ;
                            
                            if port.was_generic & ~isempty(port.domain)
                                if isempty(equation.domain)
                                    equation.domain = port.domain ;
                                    equation.domain_item = port.domain_item ;
                                else
                                    same_domain = equation.domain==port.domain ;
                                    same_domain_item = strcmp(equation.domain_item,port.domain_item) ;
                                    mttAssert(same_domain&same_domain_item,...
                                        ['Attempt to overwrite implicit variables with conflicting domains in "',...
                                            operator_definition.content{j},'"']) ;
                                end
                            end
                        end
                    end
                end
                
                
                covariables = mttGetCovariables(model.env,equation.domain,equation.domain_item) ;
%                if equation.is_effort
%                    covar = covariables.effort ; 
%                else
%                    covar = covariables.flow ; 
%                end
                
                block_size = length(covariables.effort) ;
                
                
                for line = 1:block_size
	                segment = [] ;
                    content = [] ;
                    
                    for k = 1:number_of_chunks
                        chunk = equation.chunk{k} ;
                        
                        switch class(chunk)
                        case 'cell'
                            type = chunk{1} ;
                            index = chunk{2} ;
                            
                            switch type
                            case 'link'
                                port_variable = [cr,'___',operator_definition.link(index).name] ;
                                
                                if strcmp(chunk{3},'generic___effort')
                                    segment{k} = [port_variable,'.',strrep(covariables.effort{line},'.','__')] ;
                                elseif strcmp(chunk{3},'generic___flow')
                                    segment{k} = [port_variable,'.',strrep(covariables.flow{line},'.','__')] ;
                                else
                                    segment{k} = [port_variable,'.',strrep(chunk{3},'.','__')] ;
                                end
                                
%                                if length(chunk)>2
%                                    segment{k} = [port_variable,'.',strrep(chunk{3},'.','__')] ;
%                                else
%                                    segment{k} = [port_variable,'.',strrep(covar{line},'.','__')] ;
%                                end
                                
                            case 'numpar'
                                segment{k} = [cr,'___',cr_definition.numpar{index}] ;
                                
                            case 'sympar'
                                parameter = [cr_definition.parameter{index}] ;
                                if isnumeric(parameter)
                                    segment{k} = num2str(parameter) ;
                                else
                                    segment{k} = [cr_definition.parameter{index}] ;
                                end
                                
                            case 'var'
                                segment{k} = [op,'___',operator_definition.var{index}] ;
                                
                            case 'struct'
                                segment{k} = [op,'___',structlist{index}] ;
                                
                            case 'input'
                                segment{k} = [cr,'___',cr_definition.input{index}] ;
                                
                            case 'state'
                                state = cr_definition.state{index} ;
                                if isempty(reassigned_state_list)
                                    state_reassignment = [] ;
                                else
                                    state_reassignment = strmatch(state,reassigned_state_list.name,'exact') ;
                                end
                                
                                if isempty(state_reassignment)
                                    segment{k} = [cr,'___',state,'.state'] ;
                                else
                                    state_covar = reassigned_state_list.covar{line} ;
                                    segment{k} = [cr,'___',state,'___',state_covar{1},'.state'] ;
                                end
                                
%                                segment{k} = [cr,'___',cr_definition.state{index},'.state'] ;
                                    
                            case 'derivative'
                                state = cr_definition.state{index} ;
                                if isempty(reassigned_state_list)
                                    state_reassignment = [] ;
                                else
                                    state_reassignment = strmatch(state,reassigned_state_list.name,'exact') ;
                                end
                                
                                if isempty(state_reassignment)
                                    segment{k} = [cr,'___',state,'.derivative'] ;
                                else
                                    state_covar = reassigned_state_list.covar{line} ;
                                    segment{k} = [cr,'___',state,'___',state_covar{1},'.derivative'] ;
                                end
                                
%                                segment{k} = [cr,'___',cr_definition.state{index},'.derivative'] ;
                                
                            end
                        otherwise
                            chunk = strrep(chunk,':=','=') ;
                            segment{k} = chunk ;
                        end
                    end
                    
                    content = [tab,segment{1}] ;
                    for k = 2:length(segment)
                        content = [content,segment{k}] ;
                    end
                    content = [content,' ;'] ;
                    
                    eqn_counter = eqn_counter + 1 ;
                    eqn{eqn_counter} = content ;
                end
            end
            
            eqn_counter = eqn_counter + 1 ;
            eqn{eqn_counter} = ['// End of ',op] ; 
            eqn_counter = eqn_counter + 1 ;
            eqn{eqn_counter} = [''] ; 
        end
    end    
    
    eqn = eqn' ;
    ini = ini' ;
    

function write_equations(eqn,ini,model)
    filename = [model.source,'_include_ode.h'] ;
    fid = fopen(filename,'w') ;
    
    mttNotify(['...creating ',filename]) ;
    mttWriteNewLine ;
    
    fprintf(fid,['// Ordinary Differential Equations\n']) ;
    fprintf(fid,'\n') ;
    fprintf(fid,['// file: ',filename,'\n']) ;
    fprintf(fid,['// written by MTT on ',datestr(now),'\n']) ;
    fprintf(fid,'\n\n') ;
    
    tab = char(32*ones(1,3)) ;
    for i = 1:length(ini)
        formatted_equation = [tab,ini{i},'\n'] ;
        fprintf(fid,formatted_equation) ;
    end
    fprintf(fid,'\n') ;
    for i = 1:length(eqn)
        formatted_equation = [tab,eqn{i},'\n'] ;
        fprintf(fid,formatted_equation) ;
    end
    
    fclose(fid) ;
    
