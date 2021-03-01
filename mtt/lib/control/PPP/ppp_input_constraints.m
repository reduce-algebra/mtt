function [Gamma,gamma] = ppp_input_constraints (A_u,Tau,Min,Max,Order)

  ## usage:  [Gamma,gamma] = ppp_input_constraints (A_u,Tau,Min,Max[,Order])
  ##
  ## Derives input copnstraint matrices Gamma and gamma 
  ## for multi-input systems.
  ## A_u Input-generating matrix
  ## Tau row vector of times at which constraints occur
  ## Max, Maximum and minimum values
  ## Limits at inf and -inf are discarded

  ## Sanity check
  [n_u,n_tau] = size(Min);
  [n,m] = size(Max);
  if (n!=n_u)||(m!=n_tau)
    error("Max and Min must have the same dimensions");
  endif
  
  [n,m] = size(Tau);
  if (m!=n_tau)
    error("Max and Min must have same number of columns as Tau");
  endif
  if (n>1)
    error("Tau must be a row vector");
  endif

  ##Defaults
  if nargin<5
    Order=zeros(1,n_tau);
  endif
  
  ## Stack up constraints for each input
  Gamma=[];
  gamma=[];
  for i_u=1:n_u
    [Gamma_i,gamma_i] = \
	ppp_input_constraint(A_u,Tau,Min(i_u,:),Max(i_u,:),Order,i_u,n_u);
    Gamma = [Gamma; Gamma_i];
    gamma = [gamma; gamma_i];
  endfor

endfunction