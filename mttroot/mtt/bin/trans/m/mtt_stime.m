function [t,y,y_theta,x] = mtt_stime(system_name,theta,free);
  ## usage: [t,y,y_theta] = mtt_stime(system_name,theta);
  ##
  ## Simulate system with name system_name and parameter vector theta
  ## The order of components in theta is determined in system_numpar.txt:
  ## y_theta contains the corresponding sensitivity functions
  ## Assumes system generated by the sBG approach
  ## Copyright (C) 1999 by Peter J. Gawthrop

  ## 	$Id$	

  ## Simulate using mtt-generated function

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
  
  for i=free
    args=sprintf("%i",i);
    for j=1:length(theta)
      args = sprintf("%s %g",args, theta(j));
    endfor

    ## Run system and replace NaN by 1e30 -- easier to handle
    command = sprintf("./%s_ode2odes.out %s | sed \'s/NAN/1e30/g\' >mtt_data.dat\n", \
    system_name, args);
   system(command);

    ## Retrieve data
    load -force mtt_data.dat
    y_theta = [y_theta mtt_data(:,3:2:1+ny)];
  endfor

  ## System data
  [n,m]=size(mtt_data);
  t = mtt_data(:,1);
  y = mtt_data(:,2:2:ny);
  x = mtt_data(:,3+ny:m);

endfunction



