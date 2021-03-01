function err = ppp_error(par)

  ## usage:  err = error (par)
  ##
  ## 

  global ppp_y_0 ppp_sim_command ppp_par ppp_i_par ppp_x0 ppp_sim ppp_u
  
  pars = ppp_par;
  pars(ppp_i_par) = par;
  
  y = sidSimpleExtruder_ssim(ppp_x0,pars,ppp_sim,ppp_u);
  
  [N,n_y] = size(y);

  Err = y - ppp_y_0;
  err = sum(diag(Err'*Err))/N
endfunction