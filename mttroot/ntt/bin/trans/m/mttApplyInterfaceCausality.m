function model = mttApplyInterfaceCausality(model,specified_rule,branch) ;
    is_root_model = (nargin==2) ;
    
	objects = mttGetFieldNames(model,'obj') ;
    
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        if isfield(object,'obj')
            if is_root_model
                branch = object_name ;
            else
                branch = [branch,'/',object_name] ;
            end
            
            object = mttApplyInterfaceCausality(object,specified_rule,branch) ;
            model = setfield(model,'obj',object_name,object) ;
            
        else
            if ~isempty(object.cr)
                if is_root_model
                    branch = mttDetachText(model.source,'/') ;
                end
                here = [branch,':',object_name] ;
                
                port_names = mttGetFieldNames(object.cr.interface,'port') ;
                
                for j = 1:length(port_names)
                    port_name = port_names{j} ;
                    port = getfield(object.cr.interface,'port',port_name) ;
                    
                    inbond = port.in ;
                    outbond = port.out ;
                    
                    for k = 1:mttGetFieldLength(port,'causality')
                        rule = port.causality(k).rule ;
                        definition = port.causality(k).def ;
                        association = port.causality(k).with ;
                        not_applied = ~port.causality(k).applied ;
                        
                        switch rule
                        case 'assert',  is_assertion = 1 ;
                        case 'prefer',  is_assertion = 0 ;
                        otherwise
                            error(['Unrecognised rule "',port_causality.rule,'" in ',here]) ;
                        end
                        
                        apply_rule = strcmp(specified_rule,rule) & not_applied ;
                        if apply_rule
                            
                            switch definition
%                            case 'effort_state',
%                                mttAssert(mttIsEqual(port.is_flow_state,0),...
%                                    ['Attempt to overwrite state assignment at port "',port_name,'" in ',here]) ;
%                                port.is_effort_state = 1 ;
                                
%                            case 'flow_state',
%                                mttAssert(mttIsEqual(port.is_effort_state,0),...
%                                    ['Attempt to overwrite state assignment at port "',port_name,'" in ',here]) ;
%                                port.is_flow_state = 1 ;
                                
                            case {'effort_in_flow_out','flow_in_effort_out','flow_out_effort_in','effort_out_flow_in'}
                                mttAssert(isempty(association),...
                                    ['Over-constraint at port "',port_name,'" in ',here]) ;
                                
                                switch definition
                                case {'effort_in_flow_out','flow_out_effort_in'},
                                    [model,inbond_ok] = mttUpdateBondCausality(model,inbond,1,1,1) ; 
                                    [model,outbond_ok] = mttUpdateBondCausality(model,outbond,0,0,1) ;
                                case {'flow_in_effort_out','effort_out_flow_in'},
                                    [model,inbond_ok] = mttUpdateBondCausality(model,inbond,0,0,1) ; 
                                    [model,outbond_ok] = mttUpdateBondCausality(model,outbond,1,1,1) ;
                                end

                                ok = inbond_ok & outbond_ok ;
                                if is_assertion
                                    mttAssert(ok,['Causal conflict at port "',port_name,'" in ',here]) ;
                                end
                                
                            case 'effort_in'
                                mttAssert(isempty(association),...
                                    ['Over-constraint at port "',port_name,'" in ',here]) ;
                                
                                [model,inbond_ok] = mttUpdateBondCausality(model,inbond,1,[],1) ; 
                                [model,outbond_ok] = mttUpdateBondCausality(model,outbond,0,[],1) ;

                                ok = inbond_ok & outbond_ok ;
                                if is_assertion
                                    mttAssert(ok,['Causal conflict at port "',port_name,'" in ',here]) ;
                                end
                                
                            case 'effort_out'
                                mttAssert(isempty(association),...
                                    ['Over-constraint at port "',port_name,'" in ',here]) ;
                                
                                [model,inbond_ok] = mttUpdateBondCausality(model,inbond,0,[],1) ; 
                                [model,outbond_ok] = mttUpdateBondCausality(model,outbond,1,[],1) ;

                                ok = inbond_ok & outbond_ok ;
                                if is_assertion
                                    mttAssert(ok,['Causal conflict at port "',port_name,'" in ',here]) ;
                                end
                                
                            case 'flow_in'
                                mttAssert(isempty(association),...
                                    ['Over-constraint at port "',port_name,'" in ',here]) ;
                                
                                [model,inbond_ok] = mttUpdateBondCausality(model,inbond,[],0,1) ; 
                                [model,outbond_ok] = mttUpdateBondCausality(model,outbond,[],1,1) ;

                                ok = inbond_ok & outbond_ok ;
                                if is_assertion
                                    mttAssert(ok,['Causal conflict at port "',port_name,'" in ',here]) ;
                                end
                                
                            case 'flow_out'
                                mttAssert(isempty(association),...
                                    ['Over-constraint at port "',port_name,'" in ',here]) ;
                                
                                [model,inbond_ok] = mttUpdateBondCausality(model,inbond,[],1,1) ; 
                                [model,outbond_ok] = mttUpdateBondCausality(model,outbond,[],0,1) ;

                                ok = inbond_ok & outbond_ok ;
                                if is_assertion
                                    mttAssert(ok,['Causal conflict at port "',port_name,'" in ',here]) ;
                                end
                                
                            case 'unicausal',
                                mttAssert(isempty(association),...
                                    ['Over-constraint at port "',port_name,'" in ',here]) ;
                                
                                [model,inbond_ok] = mttUpdateBondCausality(model,inbond,[],[],1) ; 
                                [model,outbond_ok] = mttUpdateBondCausality(model,outbond,[],[],1) ;
                                
                                ok = inbond_ok & outbond_ok ;
                                if is_assertion
                                    mttAssert(ok,['Causal conflict at port "',port_name,'" in ',here]) ;
                                end
                                
                            case {'equicausal','anticausal'}
                                mttAssert(length(association)==1,...
                                    ['Incorrect constraint at port "',port_name,'" in ',here]) ;
                                
                                associated_port_name = association{1} ;
                                associated_port = getfield(cr.interface,'port',associated_port_name) ;
                                
                                associated_inbond = associated_port.in ;
                                associated_outbond = associated_port.out ;
                                
                                mttAsert(xor(isempty(inbond),isempty(outbond)),...
                                    ['Causal rule expects unique bond at port "',port_name,'" in ',here]) ;
                                mttAsert(xor(isempty(associated_inbond),isempty(associated_outbond)),...
                                    ['Causal rule expects unique bond at port "',associated_port_name,'" in ',here]) ;
                                
                                if isempty(associated_inbond)
                                    a = associated_outbond ;
                                else
                                    a = associated_inbond ;
                                end
                                
                                if isempty(inbond)
                                    b = outbond ;
                                else
                                    b = inbond ;
                                end
                                
                                switch definition
                                case 'equicausal',
                                    [model,bond_ok] = mttUpdateBondCausality(model,b,...
                                        model.bond(a).effort,model.bond(a).flow,model.bond(a).unicausal) ; 
                                    [model,associated_bond_ok] = mttUpdateBondCausality(model,a,...
                                        model.bond(b).effort,~model.bond(b).flow,model.bond(b).unicausal) ;
                                case 'anticausal',
                                    [model,bond_ok] = mttUpdateBondCausality(model,b,...
                                        ~model.bond(a).effort,model.bond(a).flow,model.bond(a).unicausal) ; 
                                    [model,associated_bond_ok] = mttUpdateBondCausality(model,a,...
                                        ~model.bond(b).effort,~model.bond(b).flow,model.bond(b).unicausal) ;
                                end
                                
                                ok = bond_ok & associated_bond_ok ;
                                if is_assertion
                                    mttAssert(ok,['Causal conflict between ports "',port_name,...
                                            'and',associated_port_name,'" in ',here]) ;
                                end
                                
                            otherwise,
                                error(['Unrecognised constraint "',definition,'" in ',here]) ;
                            end
                            
                            port.causality(k).applied = 1 ;
                            object = setfield(object,'cr','interface','port',port_name,port) ;
                            model = setfield(model,'obj',object_name,object) ;
                        end                    
                    end
                end
            end
        end
    end
    