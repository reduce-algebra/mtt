function user_domain_identification = mttIdentifyUserDomain(environment,domain,domain_item)
    user_domain_identification = [] ;
    
    if ~(isempty(domain) | isempty(domain_item))
        user_domain_names = mttGetFieldNames(environment,'domain') ;
        number_of_user_domains = length(user_domain_names) ;
        
        counter = 0 ;
        
        identifying = 1 ;
        while identifying
            counter = counter + 1 ;
            user_domain_name = user_domain_names{counter} ;
            user_domain = getfield(environment,'domain',user_domain_name) ;
            
            specified_domain = user_domain.dom ;
            specified_domain_item = user_domain.item ;
            
            if domain==specified_domain
                if ~isempty(domain_item)
                    if isempty(specified_domain_item)
                        domain_item_names = mttGetFieldNames(environment.public_domain(domain),'item') ;
                        is_valid_item = ismember(domain_item,domain_item_names) ;
                        if is_valid_item
                            user_domain_identification = [user_domain_name,'__',domain_item] ;
                        end
                    else
                        is_matched_item = strcmp(domain_item,specified_domain_item) ;
                        if is_matched_item
                            user_domain_identification = user_domain_name ;
                        end
                    end
                end
            end
            
            identifying = (counter<number_of_user_domains) & isempty(user_domain_identification) ;
        end
    end
    
