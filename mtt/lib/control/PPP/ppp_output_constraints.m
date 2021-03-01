function [Gamma,gamma] = ppp_output_constraints (A,B,C,D,x_0,A_u,Tau,Min,Max,Order)

  ## usage:
  ## [Gamma,gamma] = ppp_output_constraints(A,B,C,D,x_0,A_u,Tau,Min,Max,Order)
  ##
  ## 
  
  ## Sanity check
  [n_y,n_tau] = size(Min);
  [n,m] = size(Max);
  if (n!=n_y)||(m!=n_tau)
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
  if nargin<10
    Order=zeros(n_y,n_tau);
  endif
  
  ## Stack up constraints for each output
  Gamma=[];
  gamma=[];
  for i_y=1:n_y
    [Gamma_i,gamma_i] = \
	ppp_output_constraint (A,B,C,D,x_0,A_u,Tau,\
			       Min(i_y,:),Max(i_y,:),Order(i_y,:),i_y);
    Gamma = [Gamma; Gamma_i];
    gamma = [gamma; gamma_i];
  endfor
  
endfunction