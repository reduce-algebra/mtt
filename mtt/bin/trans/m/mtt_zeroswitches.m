function [x] = mtt_zeroswitches(x,Nx,open)
  I_open = nozeros(open.*[1:Nx]'); # Indices of open switches
  x(I_open) = 0.0;		   # Open switches have zero states
endfunction;