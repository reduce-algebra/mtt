function [t,y,y_theta] = mtt_simulate(system_name,theta);
  ## usage: [t,y,y_theta] = mtt_simulate(r);
  ##
  ## Simulate system with name system and parameter vector theta
  ## The order of components in theta is determined in system_numpar.txt:
  ## Copyright (C) 1999 by Peter J. Gawthrop

  ## 	$Id$	

  ## Simulate using mtt-generated function
  y_theta = [];
   for i=1:length(theta)
     args="";
     for j=1:length(theta)
       i_sensitivity=(j==i);
       args = sprintf("%s%i %g ",args, i_sensitivity, theta(j));
     endfor

     command = sprintf("./%s_ode2odes.out %s > mtt_data.dat\n", system_name, args);
     system(command);

     ## Retrieve data
     load -force mtt_data.dat
     t = mtt_data(:,1);
     y = mtt_data(:,2);
     y_theta = [y_theta mtt_data(:,3)];
   endfor

endfunction



