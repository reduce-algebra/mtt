function X = transient (t,A,x_0)

  ## usage:  L = transient (t,p,order)
  ##
  ## Computes transient response for time t with initial condition x_0

  ###############################################################
  ## Version control history
  ###############################################################
  ## $Id$
  ## $Log$
  ## Revision 1.1  1999/04/27 04:46:05  peterg
  ## Initial revision
  ##
  ## Revision 1.1  1999/04/25 23:19:40  peterg
  ## Initial revision
  ##
  ###############################################################


X=[];
  for tt=t			# Create the Transient up to highest order
    x = expm(A*tt)*x_0;
    X = [X x];
  endfor

endfunction