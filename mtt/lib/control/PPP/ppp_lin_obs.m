function [l_x,l_y,L_x,L_y,J_uu,J_ux,J_uw,Us0] = ppp_lin_obs (A,B,C,D,A_u,A_y,t,Q)

  ## usage:  [l_x,l_y,L_x,L_y,J_uu,J_ux,J_uw,Us0] = ppp_lin_obs  (A,B,C,D,A_u,A_y,t,Q)
  ##
  ## Linear PPP (Predictive pole-placement) computation 
  ## INPUTS:
  ## A,B,C,D: system matrices
  ## A_u: composite system matrix for U* generation 
  ##      one square matrix (A_ui) row for each system input
  ##      each A_ui generates U*' for ith system input.
  ## A_y: composite system matrix for W* generation 
  ##      one square matrix (A_yi) row for each system output
  ##      each A_yi generates W*' for ith system output.
  ## t: row vector of times for optimisation (equispaced in time)
  ## Q column vector of output weights (defaults to unity)

  ## OUTPUTS:
  ## l_x: State feedback gain
  ## l_y: setpoint gain
  ## ie u(t) = l_y w(t) - l_x x(t)
  ## L_x, L_y: open loop gains
  ## J_uu, J_ux, J_uw: cost derivatives
  ## Us0: Value of U* at tau=0

  ## Check some dimensions
  [n_x,n_u,n_y] = abcddim(A,B,C,D);
  if (n_x==-1)
    return
  endif

  ## Default Q
  if nargin<8
    Q = ones(n_y,1);
  endif
  

#   B_x = eye(n_x);		# Pseudo B
#   D_x = zeros(n_y,n_x);		# Pseudo D
  [l_x,l_y,L_x,L_y,J_uu,J_ux,J_uw,Us0] = ppp_lin(A',C',B',D',A_u',A_y',t,Q);
  
  l_x = l_x';
  l_y = l_y';
  L_x = L_x';
  L_y = L_y';
endfunction









