function [x] = mtt_implicit(x,dx,AA,AAx,dt,Nx,open); 
  ## x = mtt_implicit(x,dx,AA,AAx,dt,Nx,open); 
  ## Implicit integration update

  ## ###############################################################
  ## ## Version control history
  ## ###############################################################
  ## ## $Id$
  ## ## $Log$
  ## ## Revision 1.3  1999/04/20 06:14:53  peterg
  ## ## Reorder to make equivalent to .p version
  ## ##
  ## ## Revision 1.2  1999/04/20 00:58:22  peterg
  ## ## Set open-switch states to zero
  ## ##
  ## ## Revision 1.1  1999/04/02 06:23:20  peterg
  ## ## Initial revision
  ## ##
  ## ###############################################################

  ## Copyright (C) 1999 by P.J. Gawthrop

  I = nozeros(!open.*[1:Nx]');	# Indices of states to update
  x(I) = AA(I,I)\(AAx(I) + dx(I)*dt);	# Implicit update (except open switches);
  I_open = nozeros(open.*[1:Nx]'); # Indices of open switches
  x(I_open) = 0.0;		# Open switches have zero state

endfunction
