function [Gamma,gamma] = ppp_input_constraint (A_u,Tau,Min,Max,Order,i_u,n_u)

  ## usage:  [Gamma,gamma] = ppp_input_constraint (A_u,Tau,Min,Max,Order)
  ##
  ## Derives the input constraint matrices Gamma and gamma
  ## For Constraints Min and max at times Tau 
  ## Order=0 - input constraints
  ## Order=1 - input derivative constraints
  ## etc
  ## i_u: Integer index of the input to be constrained
  ## n_u: Number of inputs
  ## NOTE You can stack up Gamma and gamma matrices for create multi-input constraints.

  ## Copyright (C) 1999 by Peter J. Gawthrop
  ## 	$Id$	


  ## Sizes
  [n_U,m_U] = size(A_u);	# Number of basis functions
  [n,N_t] = size(Tau);		# Number of constraint times
  
  ## Defaults
  if nargin<5
    Order = zeros(1,N_t);
  endif

  if nargin<6
    i_u = 1;
    n_u = 1;
  endif
  
  if N_t==0			# Nothing to be done
    Gamma = [];
    gamma = [];
    return
  endif
  
  if n != 1
    error("Tau must be a row vector");
  endif
  
  n = length(Min);
  m = length(Max);
  o = length(Order);

  if (n != N_t)||(m != N_t)||(o != N_t)
    error("Tau, Min and max must be the same length");
  endif
  
  ## Extract the A_i matrix for this input
  A_i = ppp_extract(A_u,i_u);

  ## Create the constraints in the form: Gamma*U < gamma
  Gamma = [];
  gamma = [];
  one = ones(m_U,1);
  i=0;

  zero_l = zeros(1,(i_u-1)*m_U); # Pad left-hand
  zero_r = zeros(1,(n_u-i_u)*m_U); # Pad right-hand
  for tau = Tau			# Stack constraints for each tau
    i++;
    Gamma_tau = ( A_i^Order(i) * expm(A_i*tau) * one )';
    Gamma_tau = [ zero_l Gamma_tau zero_r ]; # Only for i_uth input
    Gamma = [Gamma;[-1;1]*Gamma_tau]; # One row for each of min and max

    gamma_tau = [-Min(i);Max(i)];
    gamma = [gamma;gamma_tau];
  endfor

endfunction
