## Figures.m
## Makes figures for the InvertedPendulumOnCart_PPP exasmple.
## $Log$
## Revision 1.4  2000/08/17 12:34:58  peterg
## *** empty log message ***
##
## Revision 1.3  2000/08/11 16:01:27  peterg
## Fixed documentation error
##
## Revision 1.2  2000/05/21 06:39:40  peterg
## Parameterised _sm
##
## Revision 1.1  2000/05/20 11:30:41  peterg
## Initial revision
##
## Revision 1.2  2000/05/17 16:59:57  peterg
## Revised for Inverted pendulum - it works !!!!
##
## Revision 1.1  2000/05/17 14:07:53  peterg
## Initial revision
##
## Revision 1.1  2000/05/17 09:14:37  peterg
## Initial revision
##
system_name = "InvertedPendulumOnCartPPP";

## Uncomment the following the first time
## (Or do ./Make InvertedPendulumOnCartPPP in this directory)

## MTT stuff for the system simulation
##system("Make InvertedPendulumOnCartPPP");

t_s=1.0*[0:0.1:10];
u = [ones(4,length(t_s))];
x_0 = InvertedPendulumOnCartPPP_state;
par  = InvertedPendulumOnCartPPP_numpar;

## Simulate the system
tick=time;
[y,x] = InvertedPendulumOnCartPPP_sim(x_0,u,t_s,par);
Elapsed = time-tick
plot(t_s,y, t_s,x);

## Simulate the system to give just the final few points
t_s1 = 10*[9:0.1:10];
tick=time;
[y,x] = InvertedPendulumOnCartPPP_sim(x_0,u,t_s1,par);
Elapsed = time-tick
plot(t_s1,y,t_s1,x);

## Sensitivity system simulation parameters
x_0s = sInvertedPendulumOnCartPPP_state;
pars  = sInvertedPendulumOnCartPPP_numpar;
sympars  = sInvertedPendulumOnCartPPP_sympar;

## Simulate the sensitivity system
sensitivities = [sympars.ppp_1s,sympars.ppp_2s,sympars.r_cs]
tick=time;
[y,ys] = sInvertedPendulumOnCartPPP_sim(x_0s,u,t_s,pars,sensitivities);
Elapsed = time-tick
plot(t_s,y,t_s,ys);

### PPP parameters
A_w = [0;0];
A_u = laguerre_matrix(4,20); # Specify basis functions: constant &
			     # exp(-5t)
tau = 0.5*[0.9:0.01:1];             # Optimisation interval
t_ol =0.5*[0:0.01:0.2];            # Open-loop interval
N = 20;                          # Number of open-loop intervals in simulation
w = [0;0];                         # Setpoint

## Linear system
## Linear system
[A,B,C,D] = InvertedPendulumOnCartPPP_sm(par);
Q = [1;1];
ppp_lin_plot (A,B(:,1),C,D(:,1),A_u,A_w,tau,Q,w,x_0);
psfig("InvertedPendulumOnCartPPP_lin");

## Simulate non-linear PPP (on this nonlinear system)
extras.U_initial = "zero";
extras.U_next = "continuation";
extras.criterion = 1e-5;
extras.max_iterations = 10;
extras.v = 0;
extras.verbose = 0;

# ##  -- with no optimisation using linear PPP with continuation
# extras.U_initial = "linear";
# extras.U_next = "continuation";
# extras.criterion = 1e-5;
# extras.max_iterations = 0;
# [y_c,x,u_c,t,U,U_c,U_l] = ppp_nlin_sim (system_name,A_u,tau,t_ol,N,w,extras);

# ##  -- with no optimisation using linear PPP at each step
# extras.U_initial = "linear";
# extras.U_next = "linear";
# extras.criterion = 1e-5;
# extras.max_iterations = 0;
# [y_l,x,u_l,t,U,U_c,U_l] = ppp_nlin_sim (system_name,A_u,tau,t_ol,N,w,extras);

##  -- with optimisation using nonlinear PPP with continuation
extras.U_initial = "zero";
extras.U_next = "continuation";
extras.criterion = 1e-4;
extras.max_iterations = 100;
extras.v = 1e-3;
extras.verbose = 0;
[y,x,u,t,U,U_c,U_l] = ppp_nlin_sim (system_name,A_u,tau,t_ol,N,w,extras);


## Plots
title("");

## U, U_c and U_l
I = 1:N;
IU1 = [I' U(1,:)'];
IU1_c = [I' U_c(1,:)'];
IU1_l = [I' U_l(1,:)'];
gset grid; xlabel "Interval"
gplot IU1 title "U_1", IU1_c title "U_c1", IU1_l title "U_l1"
psfig("InvertedPendulumOnCartPPP_U1");

IU2 = [I' U(2,:)'];
IU2_c = [I' U_c(2,:)'];
IU2_l = [I' U_l(2,:)'];
gset grid; xlabel "Interval "
gplot IU2 title "U_2", IU2_c title "U_c2", IU2_l title "U_l2"
psfig("InvertedPendulumOnCartPPP_U2");

## y & u
gset grid; xlabel "Time (sec)"
tu =  [t' u']; 
gplot tu title "Output"
psfig("InvertedPendulumOnCartPPP_u");

gset grid; xlabel "Time (sec)"
ty_th = [t' y(1,:)'] ;
ty_x = [t' y(2,:)'] ;
gplot ty_th title "Theta",ty_x title "x"
psfig("InvertedPendulumOnCartPPP_nppp");

