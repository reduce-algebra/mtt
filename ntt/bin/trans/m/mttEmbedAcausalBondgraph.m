function model = mttEmbedAcausalBondgraph(model,component,system)
    source = model.abg(component) ;
    
    if nargin==2
        is_root_model = 1 ;
        target = model ;
    else
        is_root_model = 0 ;
        target = model.abg(system) ;
    end
    
    source_objects = mttGetFieldNames(source,'obj') ;
    target_objects = mttGetFieldNames(target,'obj') ;
    
    for n = 1:length(target_objects)
        target_object_name = target_objects{n} ;
        target_object = getfield(target,'obj',target_object_name) ;
        
        here = [mttDetachText(target.source,'/'),'/',target_object_name] ;
    
        is_abg_instance = 0 ;
        if ~isempty(target_object.abg)
            is_abg_instance = target_object.abg==component ;
        end
        
        if is_abg_instance
            target_object.sympar = source.sympar ;
            target_object.numpar = source.numpar ;
            target_object.input = source.input ;
            
            target_object.sympar_default = source.sympar_default ;
            target_object.numpar_default = source.numpar_default ;
            target_object.input_default = source.input_default ;
            
            declarations = length(target_object.sympar) ;
            values = length(target_object.parameter) ;
            
            mttAssert(declarations==values,['Mismatched parameters in object ',here]) ;
            
            
            number_of_target_ports = mttGetFieldLength(target_object,'interface') ;

            found_target_port = [] ;            
            target_ports_found = [] ;
            
            for i = 1:number_of_target_ports
                
                target_port_name = target_object.interface(i).name ;
                target_inbond = target_object.interface(i).in ;
                target_outbond = target_object.interface(i).out ;
                
                is_inline = (~isempty(target_inbond) & ~isempty(target_outbond)) ;
                
                next = 0 ;
                found_target_port(i) = 0 ;
                
                matching = 1 ;
                while matching
                    next = next + 1 ;
                    source_object_name = source_objects{next} ;
                    source_object = getfield(source,'obj',source_object_name) ;
                    
                    if ismember(source_object.class,{'SS','Se','Sf','De','Df'})
                        source_port_name = source_object_name ;
                        
                        if is_inline
                            source_interface = getfield(source,'obj',source_port_name,'interface') ;
                            
                            inport_found = 0 ;
                            if ~isempty(source_interface.in)
                                inport_found = strcmp(source_port_name,[target_port_name,'_in']) ;
                            end
                            
                            outport_found = 0 ;
                            if ~isempty(source_interface.out)
                                outport_found = strcmp(source_port_name,[target_port_name,'_out']) ;
                            end
                            
                            found_target_port(i) = inport_found | outport_found ;
                        else
                            found_target_port(i) = strcmp(source_port_name,target_port_name) ;
                        end
                    end
                    
                    if found_target_port(i)
                        if isempty(target_ports_found)
                            target_ports_found = {target_port_name} ;
                        else
                            target_ports_found = [target_ports_found, {target_port_name}] ;
                        end
                        matching = 0 ;
                    else
                        matching = (next<length(source_objects)) ;
                    end
                end
                
                mttAssert(found_target_port(i),...
                    ['Unmatched port "',target_object_name,'[',target_port_name,']"']) ;
                
                source_object = getfield(source,'obj',source_port_name) ;
                source_inbond = source_object.interface.in ;
                source_outbond = source_object.interface.out ;
                source_class = source_object.class ;
                source_domain = source_object.domain ;
                source_domain_item = source_object.domain_item ;
                
                is_inward_compatible = ~xor(isempty(target_inbond),isempty(source_outbond)) ;
                is_outward_compatible = ~xor(isempty(target_outbond),isempty(source_inbond)) ;
                is_compatible = is_inward_compatible & is_outward_compatible ;
                
                mttAssert(is_compatible,...
                    ['Incompatible bond connections at port "',...
                        target_object_name,'[',target_port_name,']"']) ;
                
                target_object = setfield(target_object,'interface',{i},'map','in',source_outbond) ;
                target_object = setfield(target_object,'interface',{i},'map','out',source_inbond) ;
                target_object = setfield(target_object,'interface',{i},'class',source_class) ;
                target_object = setfield(target_object,'interface',{i},'domain',source_domain) ;
                target_object = setfield(target_object,'interface',{i},'domain_item',source_domain_item) ;
            end
            
            number_of_target_ports_found = sum(found_target_port) ;
            mttAssert(number_of_target_ports_found==number_of_target_ports,...
                ['Mismatched ports in "',target_object_name,'"']) ;
            
            for i = 1:length(source_objects)
                source_object_name = source_objects{i} ;
                if ~ismember(source_object_name,target_ports_found)
                    source_object = getfield(source,'obj',source_object_name) ;
                    source_object = mttDeleteField(source_object,'cr_item') ;
                    
                    target_object = setfield(target_object,'obj',source_object_name,source_object) ;
                end
            end
            
            source_bond_list = getfield(source,'bond') ;
            target_object = setfield(target_object,'bond',source_bond_list) ;
            
            target = setfield(target,'obj',target_object_name,target_object) ;
        end
    end
    
    if is_root_model
        model = target ;
    else
        if ~isempty(target.invokes)
	        invoked_abgs = target.invokes ;
            other_abgs = target.invokes(invoked_abgs~=component) ;
            
            if isempty(other_abgs)
                target.invokes = [] ;
            else
                target.invokes = other_abgs ;
            end
        end
        model.abg(system) = target ;
    end
    
    