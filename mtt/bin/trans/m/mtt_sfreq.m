function [w,y,y_theta] = mtt_sfreq(system_name,theta,free);
  ## usage: [w,y,y_theta] = mtt_sfreq(system_name,theta,free);
  ##
  ## Frequency response with name system_name and parameter vector theta
  ## The order of components in theta is determined in system_numpar.txt:
  ## y_theta contains the corresponding sensitivity functions
  ## Assumes system generated by the sBG approach
  ## Copyright (C) 1999 by Peter J. Gawthrop

  ## 	$Id$	

  ## Assumes SISO system 

  global mtt_n_parameters mtt_parameters # Global "argc argv"
  global mtt_w # Frequencies (if not specified in simpar file
 N = length(theta);

  eval(sprintf("[nx,ny,nu,nz,nyz] = %s_def;", system_name));
  if nargin<3
    free = 1;
  endif
  
  y_theta = [];

  if length(free)==0
    free=1;			# Make the loop happen once to get y and X
  endif
  
  [n,m]  = size(free);
  if m==1
    free = free';
  endif
  
  
  eval(sprintf("%s_simpar;", system_name)); # Read the "simulation"
					    # parameters
  if exist("mttwmin")		# Compute frequency range
    w = logspace(mttwmin,mttwmax,mttwsteps)'; # Frequency range
  else				# use global mtt_w
    w = mtt_w;
  endif
  
  y_theta = [];
  mtt_n_parameters = 1+N;
  mtt_parameters(2:1+N) = theta; # The actual parameters
  for i = free
    mtt_parameters(1) = i; # Select wich sens. function
    eval(sprintf("%s_numpar;", system_name)); # Read the parameters
    eval(sprintf("[A,B,C,D,E] = %s_dm;", system_name)); # Evaluate the
				# descriptor matrices
    fr = dm2fr(A,B,C,D,E,w);
    y_theta = [y_theta fr(:,2)]; # Sensitivity frequency response
  endfor

  y = fr(:,1);			# Actual frequency response
  
  
endfunction


