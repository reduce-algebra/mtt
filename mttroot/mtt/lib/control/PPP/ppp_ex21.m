function [name,T,y,u,ys,us,ysu,usu] = ppp_ex21 (ReturnName)

  ## usage:  ppp_ex21 ()
  ##
  ## PPP example - 2nd-order 2i2o system system with anomalous behaviour"
  ## 	$Id$	


  ## Example name
  name = "2nd-order 2i2o system with anomalous behaviour"

  if nargin>0
    return
  endif

  ## System  
  A = [-2 -1
       1   0];
  B = [[1;0], [1;2]];
  C = [ [0,1]; [2,1]];
  D = zeros(2,2);

  sys = ss2sys(A,B,C,D);
  [n_x,n_u,n_y] = abcddim(A,B,C,D);

  ## Display it
  for j = 1:n_u
    for i = 1:n_y
      sysout(sysprune(sys,i,j),"tf")
      step(sysprune(sys,i,j),1,5);
    endfor
  endfor
  
  ## Setpoint
  A_w = 0;

  ## Controller

  ##Optimisation horizon
  t =[4:0.1:5];

  ## A_u
  pole = [4];
				#A_u = ppp_aug(laguerre_matrix(2,pole),0);
				#A_u = ppp_aug(diag([-3,-4]),0);
  A_u = ppp_aug(butterworth_matrix(2,pole),0);
  Q = ones(n_y,1);;

  ## Setpoints
  W = [1:n_y]';

  ## Initial condition
  x_0 = [0;0.5];

  ## Design and plot
  [ol_poles,cl_poles,ol_zeros,cl_zeros,k_x,k_w,K_x,K_w,cond_uu] = ppp_lin_plot (A,B,C,D,A_u,A_w,t,Q,W,x_0);

  format short
  cl_poles

  A_c = A-B*k_x;			# Closed-loop A
  A_cw = [A_c B*k_w*W
          zeros(1,n_x+1)]

  log_cond_uu = log10(cond_uu)
				#  K_xwe = ppp_open2closed(A_u,A_cwe,[k_xe -k_we*W]); # Exact Kx
				#AA_u = ppp_inflate([A_u;A_u]);
  K_xwc = ppp_open2closed(A_u,A_cw,[k_x -k_w*W]) # Computed Kx
				#  Exact_K_xw = K_xwe
  Approx_K_xw = [K_x -K_w*W] 
  format

endfunction



