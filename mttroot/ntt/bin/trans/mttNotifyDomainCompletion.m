function mttNotifyDomainCompletion(model)
    
	domain = floor(100*model.domain_completion.assignments/model.domain_completion.bonds) ;
	
    fprintf(['   ...domain allocation is %i%% complete [%i/%i]\n'],...
        domain,model.domain_completion.assignments,model.domain_completion.bonds) ;
