function elapsed_time = mttElapseTime(t0)
	current_time = mttGetTime ;
    elapsed_time.cpu = current_time.cpu - t0.cpu ;
    elapsed_time.clock = etime(current_time.clock,t0.clock) ;
