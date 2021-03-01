function is_stable = mttCompareCausalCompletion(current,previous)
	is_stable_flow = current.flows==previous.flows ;
    is_stable_effort = current.efforts==previous.efforts ;
    is_stable = is_stable_flow & is_stable_effort ;


