## Figures.m
## Makes figures for the rc_PPP exasmple.
## $Log$
## Revision 1.2  2000/05/21 06:39:23  peterg
## Parameterised _sm
##
## Revision 1.1  2000/05/19 13:15:38  peterg
## Initial revision
##
## Revision 1.2  2000/05/17 17:02:58  peterg
## Fixed documentation
##
## Revision 1.1  2000/05/17 09:14:37  peterg
## Initial revision
##
system_name = "rcPPP";

## Uncomment the following the first time
## (Or do ./Make rcPPP in this directory)

## MTT stuff for the system simulation
##system("Make rcPPP");



t_s=[0:0.1:10];
u = [ones(1,length(t_s));ones(1,length(t_s))];
x_0 = rcPPP_state;
par  = rcPPP_numpar;

## Simulate the system
tick=time;
[y,x] = rcPPP_sim(x_0,u,t_s,par);
Elapsed = time-tick
plot(t_s,y,t_s,x);

## Simulate the system to give just the final few point
t_s1 = [9:0.1:10];
tick=time;
[y,x] = rcPPP_sim(x_0,u,t_s1,par);
Elapsed = time-tick
plot(t_s1,y,t_s1,x);

## Sensitivity system simulation parameters
x_0s = srcPPP_state;
pars  = srcPPP_numpar
sympars  = srcPPP_sympar;

## Simulate the sensitivity system
sensitivities = [sympars.ppp_1s,sympars.ppp_2s,sympars.rs]
tick=time;
[y,ys] = srcPPP_sim(x_0s,u,t_s,[sympars.r,2.0],sensitivities);
Elapsed = time-tick
plot(t_s,y,t_s,ys);

### PPP parameters
A_w = 0;
A_u = ppp_aug(A_w,laguerre_matrix(1,10)); # Specify basis functions: constant & exp(-5t)
tau = [0.9:0.01:1];		# Optimisation interval
t_ol = [0:0.01:0.2];		# Open-loop interval
N = 5;				# Number of open-loop intervals in simulation
w = 1;				# Setpoint

## Linear system
[A,B,C,D] = rcPPP_sm(par);
Q = 1;
w = 1;
ppp_lin_plot (A,B(:,1),C(1,:),D(1,1),A_u,A_w,tau,Q,w,x_0);
psfig("rcPPP_lin");

## Simulate non-linear PPP (on this linear system)
extras.U_initial = "zero";
extras.U_next = "continuation";
extras.criterion = 1e-5;
extras.max_iterations = 10;
extras.alpha = 0;
extras.verbose = 0;

##  -- with no optimisation using linear PPP with continuation
disp("Linear PPP at time zero with continuation trajectories")
extras.U_initial = "linear";
extras.U_next = "continuation";
extras.criterion = 1e-5;
extras.alpha = 0;
extras.max_iterations = 0;
[y_c,x,u_c,t,U,U_c,U_l] = ppp_nlin_sim (system_name,A_u,tau,t_ol,N,w,extras);

##  -- with no optimisation using linear PPP at each step
disp("Linear PPP at each step")
extras.U_initial = "linear";
extras.U_next = "linear";
extras.criterion = 1e-5;
extras.max_iterations = 0;
extras.alpha = 0;
[y_l,x,u_l,t,U,U_c,U_l] = ppp_nlin_sim (system_name,A_u,tau,t_ol,N,w,extras);

##  -- with optimisation using nonlinear PPP with continuation
disp("Nonlinear PPP");
extras.U_initial = "zero";
extras.U_next = "continuation";
extras.alpha = 0.0001;
extras.criterion = 1e-6;
extras.max_iterations = 1000;
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
psfig("rcPPP_U1");

IU2 = [I' U(2,:)'];
IU2_c = [I' U_c(2,:)'];
IU2_l = [I' U_l(2,:)'];
gset grid; xlabel "Interval "
gplot IU2 title "U_2", IU2_c title "U_c2", IU2_l title "U_l2"
psfig("rcPPP_U2");

## y & u
gset grid; xlabel "Time (sec)"
ty = [t' y'] ; tu =  [t' u']; 
gplot ty title "Output", tu title "Input"

psfig("rcPPP_yu");

title("");
gset grid; xlabel "Time (sec)"
ty_c = [t' y_c'] ; 
ty_l = [t' y_l'] ; 
ty = [t' y'] ; 
tu =  [t' u']; 
gplot ty_c title "Continuation", ty_l title "Linear", ty title "Optimisation"
psfig("rcPPP_nppp");
 
