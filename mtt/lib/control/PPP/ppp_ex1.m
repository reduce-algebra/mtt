function name = ppp_ex1 (ReturnName)

  ## usage:  ppp_ex1 ()
  ##
  ## PPP example - an unstable, nmp siso system
  ## 	$Id$	


  ## Example name
  name = "Linear unstable non-minimum phase third order system- Laguerre inputs";

  if nargin>0
    return
  endif
  

  ## System - unstable & NMP
  [A,B,C,D] = NMPsystem;
  [n_x,n_u,n_y] = abcddim(A,B,C,D);

  ## Setpoint
  A_w = ppp_aug(0,[]);

  ## Controller

  ##Optimisation horizon
  t = [4.0:0.05:5];

  ## A_u
  A_u = ppp_aug(laguerre_matrix(3,2.0), A_w);

  ## Design and plot
  [ol_poles,cl_poles,ol_zeros,cl_zeros,k_x,k_w,K_x,K_w,cond_uu] = ppp_lin_plot (A,B,C,D,A_u,A_w,t);


  ## Compute exact version
  poles = sort(eig(A_u));	# Desired poles - eigenvalues of A_u
  poles = poles(1:n_x);		# Loose the last one - due to setpoint 
  clp = poly(poles);		# Closed-loop cp
  kk = clp(2:n_x+1)+A(1,:);	# Corresponding gain
  A_c = A-B*kk;			# Closed-loop A
  K_X = ppp_open2closed (A_u,[A_c B*k_w; [0 0 0 0]],[kk -k_w]); # Exact
	
  ## Compute K_x using approx values
  A_c_a = A-B*k_x; 			
  K_X_comp = ppp_open2closed (A_u,[A_c_a B*k_w; [0 0 0 0]],[k_x -k_w]); # Computed Kx

  format bank
  log_cond_uu = log10(cond_uu)
  Exact_closed_loop_poles = poles'
  Approximate_closed_loop_poles = cl_poles
  Exact_k_x = kk
  Approximate_k_x = k_x
  Exact_K_X = K_X
  Approximate_K_X = [K_x -K_w]
  Computed_K_x = K_X_comp
  K_xw_error = Approximate_K_X-K_X
  format
endfunction



