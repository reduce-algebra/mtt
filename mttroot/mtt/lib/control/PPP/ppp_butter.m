function pol = ppp_butter (order,radius)

  ## usage:  pol = cgpc_butter (order,radius)
  ##
  ## Butterworth polynomial of given order and pole radius
  ## Copyright (C) 1999 by P.J. Gawthrop

  ## 	$Id$	

  theta = pi/(2*order);		# Angle with real axis

  even = (floor(order/2)==order/2);
  if even
    pol=1; N=order/2;
  else
    pol=[1 radius]; N=(order-1)/2;
  endif
  
  for i=1:N
    pol=conv(pol, [1 2*radius*cos(i*theta) radius^2]);
  endfor

endfunction