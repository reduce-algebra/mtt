function name = ppp_ex3 (Return_Name)

  ## usage:  Name = ppp_ex3 (Return_Name)
  ##
  ## PPP example: Uncoupled 5x5 system
  ##  	$Id$	




  ## Example name
  name = "Uncoupled NxN system - n first order systems";

  if nargin>0
    return
  endif
  
  ## System - N uncoupled integrators
  N = 3
  A = -0.0*eye(N);
  B = eye(N);
  C = eye(N);
  D = zeros(N,N);

  t =[4:0.1:5];			# Optimisation horizon
  ## Create composite matrices
  A_u = [];			# Initialise
  A_w = [];			# Initialise

  for i=1:N			
    ## Setpoint - constant
    a_w = ppp_aug(0,[]);
    A_w = [A_w;a_w];

    ## Controller
    a_u = ppp_aug(-i,a_w);
    A_u = [A_u; a_u];
 endfor
  
  A_u = [-diag([1:N])]

  Q = ones(N,1);		# Equal output weightings
  W = ones(N,1);		# Setpoints are all unity

  ## Design and simulate
  [k_x,k_w,K_x,K_w,Us0,J_uu,J_ux,J_uw,J_xx,J_xw,J_ww,y_u] = ppp_lin(A,B,C,D,A_u,A_w,t);
  # [ol_poles,cl_poles,ol_zeros,cl_zeros,k_x,k_w,K_x,K_w] = \
  #     ppp_lin_plot(A,B,C,D,A_u,A_w,t,Q,W);

  Approximate_K_x = K_x#(1:2:2*N,:)
  A_c = A-B*k_x;
  Closed_Loop_Poles = eig(A-B*k_x)
  ## Now try out the open/closed loop theory
#   A_u = -diag(1:N);		# Full A_u matrix
#   A_c = -diag(1:N);		# Ideal closed-loop
#   k_x = diag(1:N);		# Ideal feedback
  KK = ppp_open2closed (ppp_inflate(A_u),A_c,k_x);
  Exact_K_x_tilde = KK
  

endfunction

