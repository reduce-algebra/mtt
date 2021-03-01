function model = mttPropagateCausality(model,branch)
    is_root_model = (nargin==1) ;
    
	objects = mttGetFieldNames(model,'obj') ;
    
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        if is_root_model
            branch = mttDetachText(model.source,'/') ;
        end
        here = [branch,':',object_name] ;
        
        if isfield(object,'obj')
            
            for i = 1:mttGetFieldLength(object,'interface')
                port_name = object.interface(i).name ;
                
                inbond = object.interface(i).in ;
                outbond = object.interface(i).out ;
                inmap = object.interface(i).map.in ;
                outmap = object.interface(i).map.out ;
                
                [inbond_effort,inbond_flow,inbond_unicausal] = mttGetBondCausality(model,inbond) ;
                [outbond_effort,outbond_flow,outbond_unicausal] = mttGetBondCausality(model,outbond) ;
                [inmap_effort,inmap_flow,inmap_unicausal] = mttGetBondCausality(object,inmap) ;
                [outmap_effort,outmap_flow,outmap_unicausal] = mttGetBondCausality(object,outmap) ;
                
                [model,inbond_ok] = mttUpdateBondCausality(model,inbond,inmap_effort,inmap_flow,inmap_unicausal) ; 
                [model,outbond_ok] = mttUpdateBondCausality(model,outbond,outmap_effort,outmap_flow,outmap_unicausal) ; 
                [object,inmap_ok] = mttUpdateBondCausality(object,inmap,inbond_effort,inbond_flow,inbond_unicausal) ; 
                [object,outmap_ok] = mttUpdateBondCausality(object,outmap,outbond_effort,outbond_flow,outbond_unicausal) ; 
                
                ok = inbond_ok & outbond_ok & inmap_ok & outmap_ok ;
                mttAssert(ok,['Causal conflict at port "',port_name,'" in ',here]) ;
            end
            
            if is_root_model
                branch = object_name ;
            else
                branch = [branch,'/',object_name] ;
            end
            
            object = mttPropagateCausality(object,branch) ;
            model = setfield(model,'obj',object_name,object) ;
            
        else
            number_of_interfaces = mttGetFieldLength(object,'interface') ;
            
            switch object.class
            case {'Se','Sf','De','Df'}
                for i = 1:number_of_interfaces
                    port_name = object.interface(i).name ;
                    
                    inbond = object.interface(i).in ;
                    outbond = object.interface(i).out ;
                    
                    mttAssert(xor(isempty(inbond),isempty(outbond)),...
                        ['"',object.class,'" objects must have exactly one attached bond in ',here]) ;
                    
                    switch object.class
                    case {'Se','De'},
                        [model,ok] = mttUpdateBondCausality(model,outbond,[],1,1) ; % Constraint
                        [model] = mttUpdateBondCausality(model,outbond,1,[],1) ; 	% Preference
                    case {'Sf','Df'},
                        [model,ok] = mttUpdateBondCausality(model,outbond,0,[],1) ; % Constraint
                        [model] = mttUpdateBondCausality(model,outbond,[],0,1) ; 	% Preference
                    end
                    
                    mttAssert(ok,['Causal constraint violation at port "',port_name,'" in ',here]) 
                end
                
            case '0',
                mttAssert(number_of_interfaces>1,...
                    ['Less than two interfaces at 0-junction ',here]) ;
                
                imposed_effort = [] ;
                resultant_flow = [] ;
                
                for j = 1:number_of_interfaces
                    inbond = object.interface(j).in ;
                    outbond = object.interface(j).out ;
                    
                    if isempty(inbond)
                        bond(j) = outbond ;
                        orientation(j) = 0 ;
                    else
                        bond(j) = inbond ;
                        orientation(j) = 1 ;
                    end
                    
                    [effort,flow,unicausal] = mttGetBondCausality(model,bond(j)) ;
                    
                    if ~isempty(effort)
	                    if effort==orientation(j)
		                    mttAssert(isempty(imposed_effort),...
    	                        ['Over-determined effort at 0-junction ',here]) ;
                            imposed_effort = bond(j) ;
                        end
                    end
                    
                    if ~isempty(flow)
	                    if flow==orientation(j)
		                    mttAssert(isempty(resultant_flow),...
    	                        ['Over-determined flow at 0-junction ',here]) ;
                            resultant_flow = bond(j) ;
                        end
                    end
                end
                
                for j = 1:number_of_interfaces
                    if ~isempty(imposed_effort)
                        if bond(j)~=imposed_effort
                            model = mttUpdateBondCausality(model,bond(j),~orientation(j),[],[]) ;
                        end
                    end
                    
                    if ~isempty(resultant_flow)
                        if bond(j)~=resultant_flow
                            model = mttUpdateBondCausality(model,bond(j),[],~orientation(j),[]) ;
                        end
                    end
                end
                
            case '1',
                mttAssert(number_of_interfaces>1,...
                    ['Less than two interfaces at 1-junction ',here]) ;
                
                imposed_flow = [] ;
                resultant_effort = [] ;
                
                for j = 1:number_of_interfaces
                    inbond = object.interface(j).in ;
                    outbond = object.interface(j).out ;
                    
                    if isempty(inbond)
                        bond(j) = outbond ;
                        orientation(j) = 0 ;
                    else
                        bond(j) = inbond ;
                        orientation(j) = 1 ;
                    end

                    [effort,flow,unicausal] = mttGetBondCausality(model,bond(j)) ;
                    
                    if ~isempty(effort)
	                    if effort~=orientation(j)
		                    mttAssert(isempty(resultant_effort),...
    	                        ['Over-determined effort at 1-junction ',here]) ;
                            resultant_effort = bond(j) ;
                        end
                    end
                    
                    if ~isempty(flow)
	                    if flow~=orientation(j)
		                    mttAssert(isempty(imposed_flow),...
    	                        ['Over-determined flow at 1-junction ',here]) ;
                            imposed_flow = bond(j) ;
                        end
                    end
                end
                
                for j = 1:number_of_interfaces
                    if ~isempty(resultant_effort)
                        if bond(j)~=resultant_effort
                            model = mttUpdateBondCausality(model,bond(j),orientation(j),[],[]) ;
                        end
                    end
                    
                    if ~isempty(imposed_flow)
                        if bond(j)~=imposed_flow
                            model = mttUpdateBondCausality(model,bond(j),[],orientation(j),[]) ;
                        end
                    end
                end
            end
        end
    end
    
