function covariables = mttGetCovariables(env,domain,domain_item)
	if isempty(domain)
        covariables.effort = {'effort'} ;
        covariables.flow = {'flow'} ;
        covariables.effort_default = {[]} ;
        covariables.flow_default = {[]} ;
    else
        covariables = getfield(env,'public_domain',{domain},'item',domain_item) ;
    end
    