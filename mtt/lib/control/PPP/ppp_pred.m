function [A_p,B_p] = ppp_pred (A,B,C,D,A_u,Ust0,T)

  ## usage:  [A_p,B_p] = ppp_pred (A,B,C,D,A_u,Ust0,T)
  ##
  ## PPP prediction matrices: x_pred = A_p*x + B_p*U

  ## Sanity
  [n_x,n_u,n_y] = abcddim(A,B,C,D); # System dimensions
  if (n_x==-1)
    error("A B C D not compatible");
  endif
  
  n_U = issquare(A_u);
  if (n_U!=n_x)
    error(sprintf("A_u must be %ix%i",n_x,n_x));
  endif
  
  [nn,mm] = size(Ust0);
  if (nn!=1)||(mm!=n_x)
    error(sprintf("Ust0 must be 1x%i",n_x));
  endif
  
      Z = zeros(n_x,n_x);
      AA = [A   B*Ust0
	    Z   A_u'];

      eAA = expm(AA*T);
      A_p = eAA(1:n_x,1:n_x);
      B_p = eAA(1:n_x,n_x+1:2*n_x);
  
endfunction