function [u,U,J] = ppp_qp (x,W,J_uu,J_ux,J_uw,Us0,Gamma,gamma)

  ## usage:  [u,U] = ppp_qp (x,W,J_uu,J_ux,J_uw,Gamma,gamma)
  ## INPUTS:
  ##      x: system state    
  ##      W: Setpoint vector
  ##      J_uu,J_ux,J_uw: Cost derivatives (see ppp_lin)
  ##      Us0: value of U* at tau=0 (see ppp_lin)
  ##      Gamma, gamma: U constrained by Gamma*U <= gamma 
  ## Outputs:
  ##      u: control signal
  ##      U: control weight vector
  ##
  ## Predictive pole-placement of linear systems using quadratic programming
  ## Use ppp_input_constraint and ppp_output_constraint to generate Gamma and gamma
  ## Use ppp_lin to generate J_uu,J_ux,J_uw
  ## Use ppp_cost to evaluate resultant cost function

  ## Copyright (C) 1999 by Peter J. Gawthrop
  ## 	$Id$	

  ## Check the sizes
  n_x = length(x);

  [n_U,m_U] = size(J_uu);
  if n_U != m_U
    error("J_uu must be square");
  endif

  [n,m] = size(J_ux);
  if (n != n_U)||(m != n_x)
    error("J_ux should be %ix%i not %ix%i",n_U,n_x,n,m);
  endif


  if length(gamma)>0		# Constraints exist: do the QP algorithm 
    U = qp(J_uu,(J_ux*x - J_uw*W),Gamma,gamma); # QP solution for weights U
    #U = pd_lcp04(J_uu,(J_ux*x - J_uw*W),Gamma,gamma); # QP solution for weights U
    u = Us0*U;			# Control signal
  else			# Do the unconstrained solution
    ## Compute the open-loop gains
    K_w = J_uu\J_uw;
    K_x = J_uu\J_ux;

    ## Closed-loop control
    U = K_w*W - K_x*x;		# Basis functions weights - U(t)
    u = Us0*U;			# Control u(t)
  endif

endfunction
