function model = mttApplyInterfaceDomains(model,branch) ;
    is_root_model = (nargin==1) ;
    
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
            
            object = mttApplyInterfaceDomains(object,branch) ;
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
                    
                    predefined_domain = port.domain ;
                    predefined_domain_item = port.domain_item ;
                    
                    inbond = port.in ;
                    outbond = port.out ;
                    
                    if isempty(inbond)
                        bond_number = outbond ;
                    else
                        bond_number = inbond ;
                    end
                    
                    [model,ok] = mttUpdateBondDomain(model,bond_number,predefined_domain,predefined_domain_item) ;
                    
                    mttAssert(ok,['Domain conflict at port "',port_name,'" in ',here]) ;
                end
            end
        end
    end
    