function [y,u] = ppp_RT_sim (U)

  ## usage:  [y,u] = ppp_RT_sim (U)
  ##
  ## U   PPP weight (column vector)

  global system_name_sim i_ppp_sim x_0_sim y_sim u_sim A_u_sim


  ## Data from previous time - last point not used
  if length(y_sim)>0		# Avoid initial junk
    [n_t_old,junk] = size(y_sim);
    y = y_sim(1:n_t_old-1,:); u = u_sim(1:n_t_old-1,:);
  else
    y=[]; u=[];
  endif

endfunction

