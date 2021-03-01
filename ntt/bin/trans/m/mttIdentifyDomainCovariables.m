function compound_item = mttIdentifyDomainCovariables(item,domain,model)
	domains = mttGetFieldNames(model,'domain') ;
	
	domain_name = domain.source ;
    domain_shortname = mttDetachText(domain_name,'/') ;
    
    item_names = mttGetFieldNames(domain,'item') ;
	
    number_of_bonds = mttGetFieldLength(item,'bond') ;
    
    if number_of_bonds==0
        compound_item.effort = {item.covar.effort} ;
        compound_item.flow = {item.covar.flow} ;
        
   		compound_item.effort_default = {item.covar.effort_default} ;
		compound_item.flow_default = {item.covar.flow_default} ;

    else
        counter = 0 ;
        for k = 1:number_of_bonds
            bond = item.bond(k) ;
            
            [next_domain,next_item] = mttCutText(bond.domain,'::') ;
            if isempty(next_item)
	            mttAssert(ismember(next_item,item_names),...
    	            ['Unrecognised reference "',next_item,'" in domain ',domain_shortname]) ;
            
                next_item = bond.domain ;
                dependent_item = getfield(domain,'item',next_item) ;
                compound_domain = mttIdentifyDomainCovariables(dependent_item,domain,model) ;
            else
                mttAssert(ismember(next_domain,domains),...
                    ['Unrecognised domain reference "',next_domain,'" in domain ',domain_shortname]) ;
                
                next_domain_index = getfield(model,'domain',next_domain,'dom') ;
                next_domain_item_reference = getfield(model,'domain',next_domain,'item') ;
                
                mttAssert(isempty(next_domain_item_reference),...
                    ['Constrained domain reference "',next_domain,'" in domain ',domain_shortname]) ;
                
                actual_domain = model.dom(next_domain_index) ;
                
                actual_domain_name = actual_domain.source ;
                actual_domain_shortname = mttDetachText(actual_domain_name,'/') ;
            
                actual_item_names = mttGetFieldNames(actual_domain,'item') ;
                mttAssert(ismember(next_item,actual_item_names),...
                    ['Unrecognised reference "',next_item,'" in domain ',actual_domain_shortname]) ;
                
                dependent_item = getfield(actual_domain,'item',next_item) ;
                mttAssert(~dependent_item.is_private,...
                    ['No public cross-reference available for "',next_item,'" in domain ',actual_domain_shortname]) ;
                
                compound_domain = mttIdentifyDomainCovariables(dependent_item,actual_domain,model) ;
            end
            
            for i = 1:length(compound_domain.effort)
                counter = counter + 1 ;
                if isempty(bond.name)
                    compound_effort{counter} = compound_domain.effort{i} ;
                    compound_flow{counter} = compound_domain.flow{i} ;
                else
                    compound_effort{counter} = [bond.name,'.',compound_domain.effort{i}] ;
                    compound_flow{counter} = [bond.name,'.',compound_domain.flow{i}] ;
                end
                compound_effort_default{counter} = compound_domain.effort_default{i} ;
                compound_flow_default{counter} = compound_domain.flow_default{i} ;
            end
        end
        
        depth = length(compound_effort) ;
        for n = 1:depth-1
            mttAssert(~ismember(compound_effort{n},{compound_effort{n+1:depth}}),...
                ['Repeated effort variable "',compound_effort{n},'" in domain ',domain_shortname]) ;
            mttAssert(~ismember(compound_flow{n},{compound_flow{n+1:depth}}),...
                ['Repeated flow variable "',compound_flow{n},'" in domain ',domain_shortname]) ;
        end
        
        for n = 1:depth
            mttAssert(~ismember(compound_effort{n},{compound_flow{1:depth}}),...
                ['Ambiguous effort/flow variable "',compound_effort{n},'" in domain ',domain_shortname]) ;
            mttAssert(~ismember(compound_flow{n},{compound_effort{1:depth}}),...
                ['Ambiguous flow/effort variable "',compound_flow{n},'" in domain ',domain_shortname]) ;
        end
        
        mttAssert(~ismember('flow',{compound_effort{1:depth}}),...
            ['Effort variable called "flow" in domain ',domain_shortname]) ;
        mttAssert(~ismember('effort',{compound_flow{1:depth}}),...
            ['flow variable called "effort" in domain ',domain_shortname]) ;
        
		compound_item.effort = compound_effort ;
        compound_item.flow = compound_flow ;
        
		compound_item.effort_default = compound_effort_default ;
		compound_item.flow_default = compound_flow_default ;
    end
	
