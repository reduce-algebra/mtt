function [t,y,y_theta] = mtt_stime(system_name,theta,indices);
  ## usage: [t,y,y_theta] = mtt_stime(system_name,theta);
  ##
  ## Simulate system with name system_name and parameter vector theta
  ## The order of components in theta is determined in system_numpar.txt:
  ## y_theta contains the corresponding sensitivity functions
  ## Assumes system generated by the sBG approach
  ## Copyright (C) 1999 by Peter J. Gawthrop

  ## 	$Id$	

  ## Simulate using mtt-generated function

  if nargin<3
    indices = ones(size(theta))
  endif
  
  N = length(theta);
  if N!=length(indices)
    error(sprintf("The length (%i) of indices must be the same as that of theta (%i)",length(indices),N));
  endif
  
  y_theta = [];
  for i=1:length(theta)
    if indices(i)
      args="";
      for j=1:length(theta)
	i_sensitivity=(j==i);
	args = sprintf("%s%i %g ",args, i_sensitivity, theta(j));
      endfor
      args
      command = sprintf("./%s_ode2odes.out %s > mtt_data.dat\n", system_name, args);
      system(command);

      ## Retrieve data
      load -force mtt_data.dat
      t = mtt_data(:,1);
      y = mtt_data(:,2);
      y_theta = [y_theta mtt_data(:,3)];
    endif
  endfor

endfunction



