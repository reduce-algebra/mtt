function [x] = mtt_implicit(x,dx,AA,AAx,dt,Nx,open); # Implicit update

## ###############################################################
## ## Version control history
## ###############################################################
## ## $Id$
## ## $Log$
## ###############################################################

## Copyright (C) 1999 by P.J. Gawthrop

  I = nozeros(!open.*[1:Nx]');	# Indices of states to update
  x(I) = AA(I,I)\(AAx(I) + dx(I)*dt);	# Implicit update (exept open switches);

endfunction
