function [theta,Theta,Error,Y] = mtt_identify (system_name,y_s,theta_0,criterion,max_iterations)

  ## usage:  [theta,Theta,Error] = mtt_identify (system_name,theta_0,criterion,max_iterations)
  ##      y_s   actual system output
  ##      theta_0   initial parameter estimate
  ##      criterion convergence criterion
  ##      max_iterations limit to number of iterations

  if nargin<4
    criterion = 1e-5;
  endif
  
  if nargin <5
    max_iterations = 20;
  endif

  alpha = 1.0;
  e_last = 1e20;
  error=1e10;
  theta = theta_0;
  Theta = [];
  Error = [];
  Y = [];
  iterations = 0;
  while abs(e_last-error)>criterion
    theta
    iterations = iterations + 1;
    e_last = error;
    [t,y,y_theta] = mtt_ssimulate(system_name,theta); # Simulate system
    Theta = [Theta theta];	# Save parameters
    Y = [Y y];			# Save output
    E = (y - y_s);		# Error(t)
    error = (E'*E);			# Sum the error
    Error = [Error error];
    theta = theta - alpha*((y_theta'*y_theta)\(y_theta'*E));
  endwhile

endfunction
