function mttNotifyCausalCompletion(model)
    
	flow = floor(100*model.causal_completion.flows/model.causal_completion.bonds) ;
	effort = floor(100*model.causal_completion.efforts/model.causal_completion.bonds) ;
	unicausal = model.causal_completion.unicausal/model.causal_completion.bonds ;
	
    if model.causal_completion.is_unicausal
	    fprintf(['   ...causality is %i%% complete [%i/%i]: all unicausal\n'],...
            flow,model.causal_completion.assignments,model.causal_completion.bonds) ;
	else
	    fprintf(['   .....flow causality is %i%% complete [%i/%i]\n'],...
            flow,model.causal_completion.flows,model.causal_completion.bonds) ;
	    fprintf(['   ...effort causality is %i%% complete [%i/%i]\n'],...
            effort,model.causal_completion.efforts,model.causal_completion.bonds) ;
	    fprintf(['              => %i bonds are unicausal\n'],...
            model.causal_completion.unicausal) ;
	end
