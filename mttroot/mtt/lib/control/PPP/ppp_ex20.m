function [name,T,y,u,ys,us,ysu,usu] = ppp_ex20 (ReturnName)

  ## usage:  ppp_ex20 ()
  ##
  ## PPP example - 2nd-order 2i2o system
  ## 	$Id$	


  ## Example name
  name = "2nd-order 2i2o system with 1st-order basis"

  if nargin>0
    return
  endif

  ## System  
  A = [-2 -1
       1   0];
  B = [[1;0], [1;2]];
  C = [ [0,1]; [2,1]];
  D = zeros(2,2);

#  sys = ss2sys(A,B,C,D);
  [n_x,n_u,n_y] = abcddim(A,B,C,D);

#   ## Display it
#   for j = 1:n_u
#     for i = 1:n_y
#       sysout(sysprune(sys,i,j),"tf")
#       step(sysprune(sys,i,j),1,5);
#     endfor
#   endfor
  
  ## Setpoint
  A_w = 0;

  ## Controller

  ##Optimisation horizon
  t =[4:0.01:5];

  ## A_u
  pole = [3];
  poles = 1;
  A_u = ppp_aug(butterworth_matrix(poles,pole),0);
  Q = ones(n_y,1);;

  ## Setpoints
  W = [1:n_y]';

  ## Design and plot
  [ol_poles,cl_poles,ol_zeros,cl_zeros,k_x,k_w,K_x,K_w,cond_uu] = ppp_lin_plot (A,B,C,D,A_u,A_w,t,Q,W);

  format bank
  cl_poles

  A_c = A-B*k_x;			# Closed-loop A
  A_cw = [A_c B*k_w*W
          zeros(1,n_x+1)]

  log_cond_uu = log10(cond_uu)
				#  K_xwe = ppp_open2closed(A_u,A_cwe,[k_xe -k_we*W]); # Exact Kx
#  K_xwc = ppp_open2closed(A_u,A_cw,[k_x -k_w*W]); # Computed Kx
				#  Exact_K_xw = K_xwe
  PPP_K_xw = [K_x -K_w*W] 
#  Comp_K_xw = K_xwc

#  Error = Approx_K_xw - Comp_K_xw

endfunction



