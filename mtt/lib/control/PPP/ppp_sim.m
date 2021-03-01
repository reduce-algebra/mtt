function [y,y_s] = ppp_sim (system_name,x_0,u,t,par,i_s,external)

  ## mtt_sim: Simulates system  sensitivity functions. 
  ## usage:  [y,y_s] = ppp_sim (system_name,x_0,u,t,par,i_s)
  ##   system_name string containing name of the sensitivity system
  ##   x_0         initial state 
  ##   u           system input (one input per row)
  ##   t           row vector of time
  ##   par         system parameter vector
  ##   i_s         indices of sensitivity parameters 


  if nargin<7
    external = 0;
  endif
  
  ## Some sizes
  n_s = length(i_s);
  n_t = length(t);


  for i = 1:n_s

    ## Set sensitivity parameters
    par(i_s(i)) = 1.0;
    par(complement(i_s(i),i_s)) = 0;

    if external
      par_string = "";
      for i_string=1:length(par)
	par_string = sprintf("%s %s", par_string, num2str(par(i_string)));
      endfor
      data_string = system(sprintf("./%s_ode2odes.out %s | cut -f 2-%i", \
				   system_name, par_string, 1+n_s));
      Y = str2num(data_string)';
    else
      Y = eval(sprintf("%s_sim(x_0,u,t,par);", system_name));
    endif

    [n_Y,m_Y] = size(Y);
     n_y = n_Y/2;
    if i==1	
      y = Y(1:2:n_Y,:);		# Save up the output
      y_s = zeros(n_s*n_y, n_t); # Initialise for speed
    endif
 
    y_s((i-1)*n_y+1:i*n_y,:)  = Y(2:2:n_Y,:);	# Other sensitivities
    
  endfor

title("");
plot(t,y);

endfunction
