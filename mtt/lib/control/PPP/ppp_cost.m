function [J J_U] = ppp_cost (U,x,W,J_uu,J_ux,J_uw,J_xx,J_xw,J_ww)

  ## usage: [J J_U] = ppp_cost (U,x,W,J_uu,J_ux,J_uw,J_xx,J_xw,J_ww)
  ## Computes the PPP cost function given U,x and W
  ## 
  ## J_uu,J_ux,J_uw,J_xx,J_xw,J_ww cost derivatives from ppp_lin

  ## Copyright (C) 1999 by Peter J. Gawthrop
  ## 	$Id$	

  J = U'*J_uu*U/2 + U'*(J_ux*x - J_uw*W) - x'*J_xw*W + x'*J_xx*x/2 + W'*J_ww*W'/2;
  J_U = J_uu*U + (J_ux*x - J_uw*W) ;

endfunction
