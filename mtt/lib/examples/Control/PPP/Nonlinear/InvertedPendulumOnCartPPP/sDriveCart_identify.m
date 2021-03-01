function sDriveCart_identify ()

  ## usage:  sDriveCart_identify ()
  ##
  ## 

  ## Identify the Drive/cart friction
  ## 	$Id$	

  system_name = "sDriveCart";	# Name of this system
  input_name = sprintf("%s_input.dat", system_name);
  ## disp("Create programs");
  ## system(sprintf("mtt -q -c -s -stdin %s ode2odes out", system_name)); # Create sim. code
  ## system(sprintf("mtt -q -c -s -stdin %s numpar m", system_name)); # Create sim. code
  ## system(sprintf("mtt -q -c -s -stdin %s def m", system_name)); # Create sim. code

  ## Optimisation parameters
  crite = 1e-5;			# Convergence criterion
  alpha = 0.5;			# Step reduction factor
  max = 30;			# Maximum iterations
  View = 1			# View the optimisation process

  ## Parameters
  global mtt_n_parameters
  mtt_n_parameters = 0;

  eval(sprintf("%s_numpar;", system_name));

  alpha = 0.75;
  criterion = 1e-9;
  max_iterations = 20;

  ## Real data
  disp("Loading data");
  load -force data_020999.dat;
  [N_data,M_data] = size(data_020999);
  M = 10;
  t = data_020999(1:M:N_data,1);
  u = data_020999(1:M:N_data,2);
  y = data_020999(1:M:N_data,3)/100; # convert from cm to m

  gset grid
  gset title ""
  gset xlabel "Time (sec)"
  tu = [t u];
  ty = [t y];
  gplot tu title "input (V)", ty title "output (m)"
  psfig("sDriveCart_yu");


  y_s = [u y];			# u is first o/p of system.
  ## Start time at zero
  t = t-t(1)*ones(size(t));
  
  T_last = 40;
  DT = t(2)-t(1);

  tu = [t u u u u];		# Put same signal on all inputs (only
				# first used
  save -ascii junk.dat tu
  ## zap the octave comments
  system(sprintf("grep -v \'#\' junk.dat > %s; rm -f junk.dat", input_name));

  ## Set up theta
  control = [1 0 0 0];		# Initial control parameters
  unused = 0;			# Unused parameter slot
  r_c = 0;
  parameters = [r_c m_c unused unused unused];
  i_r = 4+1;
  i_m = 4+2;
  state = [0 unused unused 0 0];
  i_v = 4+5+4;
  i_x = 4+5+5;
  i_i = 4+5+1;
  theta_0 = [control parameters state]';

  ## Weighting function - select output, not input
  weight = ones(size(t))*[0 1];

  ## Estimate r only
  free = [i_r i_i i_v i_x];
  disp("Estimate cart friction ...");
  [theta,Theta,Error,Y] = mtt_optimise(system_name,y_s,theta_0,"time",\
				       free,weight,crite,max,alpha,View);

  ## Plot results
#   ix = [its Theta(i_x,:)'];
#   iv = [its Theta(i_v,:)'];
#   ii = [its Theta(i_i,:)'];

#   gplot \
#       ix with linespoints title "x_0",\
#       iv with linespoints title "p_0",\
#       ii with linespoints title "i_0"

#   psfig("sDriveCart_ident_x");

  [N_th,M_th] = size(Theta);
  its = [0:M_th-1]';
  gset grid
  gset title ""
  gset xlabel "Iterations"
  ir = [its Theta(i_r,:)'];
  gplot ir with linespoints title "r"
  psfig("sDriveCart_ident_r");

  r_c = theta(i_r)

endfunction
