function model = mttPropagateDomains(model,branch)
    is_root_model = (nargin==1) ;
    
	objects = mttGetFieldNames(model,'obj') ;
    
    for i = 1:length(objects)
        object_name = objects{i} ;
        object = getfield(model,'obj',object_name) ;
        
        if is_root_model
            branch = mttDetachText(model.source,'/') ;
        end
        here = [branch,':',object_name] ;
        
        if ~isempty(object.abg)
            
            for j = 1:mttGetFieldLength(object,'interface')
			    port_name = object.interface(j).name ;
                
                inbond = object.interface(j).in ;
                outbond = object.interface(j).out ;
                inmap = object.interface(j).map.in ;
                outmap = object.interface(j).map.out ;
                
                [inbond_domain,inbond_domain_item]   = mttGetBondDomain(model,inbond) ;
                [outbond_domain,outbond_domain_item] = mttGetBondDomain(model,outbond) ;
                [inmap_domain,inmap_domain_item]     = mttGetBondDomain(object,inmap) ;
                [outmap_domain,outmap_domain_item]   = mttGetBondDomain(object,outmap) ;
                
                [model,inbond_ok]  = mttUpdateBondDomain(model,inbond,inmap_domain,inmap_domain_item) ; 
                [model,outbond_ok] = mttUpdateBondDomain(model,outbond,outmap_domain,outmap_domain_item) ; 
                [object,inmap_ok]  = mttUpdateBondDomain(object,inmap,inbond_domain,inbond_domain_item) ; 
                [object,outmap_ok] = mttUpdateBondDomain(object,outmap,outbond_domain,outbond_domain_item) ;
                
                ok = inbond_ok & outbond_ok & inmap_ok & outmap_ok ;
                mttAssert(ok,['Domain conflict at port "',port_name,'" in ',here]) ;
            end
            
            if is_root_model
                branch = object_name ;
            else
                branch = [branch,'/',object_name] ;
            end
            
            object = mttPropagateDomains(object,branch) ;
            model = setfield(model,'obj',object_name,object) ;
            
        elseif ~isempty(object.cr)
            
            interface = object.cr.interface ;
            port_names = mttGetFieldNames(interface,'port') ;            
            
            for j = 1:length(port_names)
                port_name = port_names{j} ;
                port = getfield(interface,'port',port_name) ;
                
                inbond = port.in ;
                outbond = port.out ;
                
                [model,inbond_ok]  = mttUpdateBondDomain(model,inbond,port.domain,port.domain_item) ;
                [model,outbond_ok] = mttUpdateBondDomain(model,outbond,port.domain,port.domain_item) ; 
                
                ok = inbond_ok & outbond_ok ;
                mttAssert(ok,['Domain conflict at port "',port_name,'" in ',here]) ;
            end
            
        else
            
            number_of_interfaces = mttGetFieldLength(object,'interface') ;
            
            switch object.class
            case {'0','1'},
                index = 0 ;
                finding_domain = 1 ;
                
                while finding_domain
                    index = index + 1 ;
                
                    inbond = object.interface(index).in ;
                    outbond = object.interface(index).out ;
                    
                    if isempty(inbond)
                        bond_number = outbond ;
                    else
                        bond_number = inbond ;
                    end
                    
                    [existing_domain,existing_domain_item] = mttGetBondDomain(model,bond_number) ;
                
                    found_domain = ~isempty(existing_domain) ;
                    finding_domain = ~found_domain & index<number_of_interfaces ;
                end
                
                if found_domain
                    for j = 1:number_of_interfaces
                        inbond = object.interface(j).in ;
                        outbond = object.interface(j).out ;
                        
                        if isempty(inbond)
                            bond_number = outbond ;
                        else
                            bond_number = inbond ;
                        end
                    
                        model = mttUpdateBondDomain(model,bond_number,existing_domain,existing_domain_item) ;
                    end
                end
            end
        end
    end
    
