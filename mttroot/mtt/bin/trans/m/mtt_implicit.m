function [x] = mtt_implicit(x,dx,AA,AAx,dt,Nx,open); # Implicit update

## ###############################################################
## ## Version control history
## ###############################################################
## ## $Id$
## ## $Log$
## ## Revision 1.1  1999/04/02 06:23:20  peterg
## ## Initial revision
## ##
## ###############################################################

## Copyright (C) 1999 by P.J. Gawthrop

  I_open = nozeros(open.*[1:Nx]'); # Indices of open switches
  x(I_open) = 0.0;		# Open switches have zero state
  I = nozeros(!open.*[1:Nx]');	# Indices of states to update
  x(I) = AA(I,I)\(AAx(I) + dx(I)*dt);	# Implicit update (except open switches);

endfunction
