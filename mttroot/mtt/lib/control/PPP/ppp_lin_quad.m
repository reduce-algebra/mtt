function [k_x,k_w,K_x,K_w,Us0,J_uu,J_ux,J_uw,J_xx,J_xw,J_ww,A_u] = \
      ppp_lin_quad (A,B,C,D,tau,Q,R)

  ## usage:[k_x,k_w,K_x,K_w,Us0,J_uu,J_ux,J_uw,J_xx,J_xw,J_ww,A_u] =
  ## ppp_lin_quad (A,B,C,D,tau,Q,R)
  ##
  ## 

  ## Steady-state Linear Quadratic solution
  ## using Algebraic Riccati equation (ARE)
  [P,A_u,A_w] = ppp_are (A,B,C,D,Q,R);

  ## PPP solution
  [k_x,k_w,K_x,K_w,Us0,J_uu,J_ux,J_uw,J_xx,J_xw,J_ww] = \
      ppp_lin(A,B,C,D,A_u,A_w,tau,Q,R,P);


endfunction