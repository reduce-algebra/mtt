function [Ac,Bc,Cc,Dc] = ppp_closedloop (A,B,C,D,k_x,k_w,l_x,l_y)

  ## usage:  [Ac,Bc,Cc,Dc] = ppp_closedloop (A,B,C,K_x,K_w,K_y,L)
  ##
  ## 


  ## Closed loop input  is [w;v]. 
  ## Closed loop output is [y;u]. 
  ## w is reference signal
  ## v is input disturbance
  ## Inputs:
  ## 	A,B,C,D		MIMO linear system matrices
  ## 	k_x,k_w,k_y	Gain matrices: u = k_w*w - k_x*x
  ##	L		Observer gain matrix
  ## Outputs
  ## 	Ac,Bc,Cc,Dc	Closed-loop charecteristic polynomial	

  ## Copyright (C) 1999 by Peter J. Gawthrop

  ## System dimensions
  [n_x,n_u,n_y] = abcddim(A,B,C,D);

  ## Create matrices describing closed-loop system
  Ac = [ A,  -B*k_x     
	l_x*C,  (A - l_x*C - B*k_x)];

  Bc = [B*k_w    B
	B*k_w    zeros(n_x,n_u)];

  Cc = [C               zeros(n_y,n_x)
	zeros(n_u,n_x)  -k_x          ];

  Dc = [zeros(n_y,n_y)     zeros(n_y,n_u)
	k_w              zeros(n_u,n_u)];

endfunction