function ppp_RT_sim_compute (U)

  ## usage:  [y,u] = ppp_RT_sim_compute (U)
  ##
  ## U   PPP weight (column vector)

  global system_name_sim i_ppp_sim x_0_sim y_sim u_sim A_u_sim simpar_sim

  ## System details -- defines simulation within ol interval
  par = eval(sprintf("%s_numpar;", system_name_sim));
  t = [0:simpar_sim.dt:simpar_sim.last];
  n_t = length(t);
  [n_x,n_y,n_u] = eval(sprintf("%s_def", system_name_sim));
  [n_U,junk] = size(A_u_sim);

  ## Set up u_star
  u_star = ppp_ustar(A_u_sim,1,t,0,0,n_u-n_U);

  ## Simulate
  par(i_ppp_sim(:,3)) = U;		# Update the simulation ppp weights
  [y_sim,x] = eval(sprintf("%s_sim(x_0_sim, par, simpar_sim, u_star);", \
			   system_name_sim));
  x_0_sim  = x(n_t,:)';		# Extract state for next time
  u_sim = u_star(:,1:n_U)*U;
endfunction

