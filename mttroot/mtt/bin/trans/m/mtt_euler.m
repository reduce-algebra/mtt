function [x] = mtt_euler(x,dx,dt,stepfactor,Nx,open) # Euler update
  I_open = nozeros(open.*[1:Nx]'); # Indices of open switches
  x(I_open) = 0.0;		# Open switches have zero state
  I = nozeros(!open.*[1:Nx]');	# Indices of states to update
  x(I) = x(I) + dx(I)*dt;	# Update states except open switches.
endfunction;

