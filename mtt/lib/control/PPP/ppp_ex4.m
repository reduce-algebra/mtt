function name = ppp_ex4 (ReturnName)

  ## usage:  ppp_ex4 ()
  ##
  ## PPP example -- a 1i2o system with performance limitations
  ## 	$Id$	



  ## Example name
  name = "Resonant system (1i2o): illustrates performance limitations with 2 different time-constants";

  if nargin>0
    return
  endif
  

  ##  Mass- sping damper from Middleton et al EE9908

  ## Set parameters to unity
  m_1 = 1;		
  m_2 = 1;
  k = 1;

  ## System
  [A,B,C,D] = TwoMassSpring (k,m_1,m_2);

  for TC = [0.4 1]
    disp(sprintf("\nClosed-loop time constant = %1.1f\n",TC));
    ## Controller
    A_w = zeros(2,1);	# Setpoint: Unit W* for each output
    t =[11:0.1:12];			# Optimisation horizon
    [A_u] = ppp_aug(laguerre_matrix(4,1/TC), 0);	# U*

    Q = [1;0];

    ## Design and plot
    [ol_poles,cl_poles,ol_zeros,cl_zeros,k_x,k_w] = ppp_lin_plot (A,B,C,D,A_u,A_w,t,Q)
    hold on;
  endfor

  hold off;
endfunction




