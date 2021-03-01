function name = ppp_ex5 (ReturnName)

  ## usage:  ppp_ex5 (ReturnName)
  ##
  ## PPP example -- a 28-state vibrating beam system
  ## 	$Id$	


  ## Example name
  name = "Vibrating beam: 14 state regulation problem with 7 beam velocities as output";

  if nargin>0
    return
  endif
  
  
  ## System - beam
  Beam_numpar;
  [A,B,C,D]=Beam_sm;
  
  ## Redo C and D to reveal ALL velocities
  c = C(1);
  C = zeros(7,14);
  for i = 1:7
    C(i,2*i-1) = c;
  endfor
  D = zeros(7,1);

  e = eig(A);			# Eigenvalues
  N = length(e);
  frequencies = sort(imag(e));
  frequencies = frequencies(N/2+1:N); # Modal frequencies

  ## Controller
  ## Controller design parameters
  t = [0.4:0.01:0.5];		# Optimisation horizon

  Q = ones(7,1); 

  ## Specify input basis functions 
  ##  - damped sinusoids with same frequencies as beam
  damping_ratio = 0.2;		# Damping ratio of inputs
  A_u = damped_matrix(frequencies,0.2*ones(size(frequencies)));
  u_0 = ones(14,1);		# Initial conditions

  A_w = zeros(7,1);		# Setpoint
  W =  zeros(7,1);		# Zero setpoint

  ## Set up an "typical" initial condition
  x_0 = zeros(14,1);
  x_0(2:2:14) = ones(1,7);	# Set initial twist to 1.

  ## Simulation
  [ol_poles,cl_poles] =  ppp_lin_plot (A,B,C,D,A_u,A_w,t,Q,W,x_0);

  

endfunction
