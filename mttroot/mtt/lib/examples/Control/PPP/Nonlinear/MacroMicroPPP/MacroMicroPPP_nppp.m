## MacroMicroPPP_nppp.m
## Makes figures for the MacroMicro_PPP exasmple.
## $Log$
## Revision 1.4  2000/05/21 16:11:53  peterg
## 7 basis funs.
##
## Revision 1.3  2000/05/21 15:59:34  peterg
## Made into _nppp.m file
## Parameterised _sm
##
## Revision 1.2  2000/05/17 17:01:39  peterg
## Modified for Macro Micro example -- works!!
##
## Revision 1.1  2000/05/17 10:03:04  peterg
## Initial revision
##
## Revision 1.1  2000/05/17 09:14:37  peterg
## Initial revision
##
system_name = "MacroMicroPPP";

## Uncomment the following the first time
## (Or do ./Make MacroMicroPPP in this directory)

## MTT stuff for the system simulation
##system("Make MacroMicroPPP");



t_s=0.1*[0:0.01:1];
u = [ones(7,length(t_s))];
x_0 = MacroMicroPPP_state;
par  = MacroMicroPPP_numpar;

## Simulate the system
tick=time;
[y] = MacroMicroPPP_sim(x_0,u,t_s,par);
Elapsed = time-tick
plot(t_s,y)

## Simulate the system to give just the final few point
t_s1 = 0.1*[0.91:0.01:1];
tick=time;
[y,x] = MacroMicroPPP_sim(x_0,u,t_s1,par);
Elapsed = time-tick
plot(t_s1,y,t_s1,x);

## Sensitivity system simulation parameters
x_0s = sMacroMicroPPP_state;
pars  = sMacroMicroPPP_numpar;
sympars  = sMacroMicroPPP_sympar;

## Simulate the sensitivity system
sensitivities = \
    [sympars.ppp_1s,\
     sympars.ppp_2s,\
     sympars.ppp_3s,\
     sympars.ppp_4s,\
     sympars.ppp_5s,\
     sympars.ppp_6s,\
     sympars.ppp_7s]
tick=time;
[y,ys] = sMacroMicroPPP_sim(x_0s,u,t_s,pars,sensitivities);
Elapsed = time-tick
plot(t_s,y,t_s,ys);


### PPP parameters
A_w = 0;
A_u = ppp_aug(A_w,laguerre_matrix(6,25)); # Specify basis functions

tau = 0.5*[0.9:0.01:1];         # Optimisation interval
t_ol = 0.5*[0:0.01:0.1];	# Open-loop interval
N = 10;                          # Number of open-loop intervals in simulation
w = 1;                          # Setpoint

## Linear system
[A,B,C,D] = MacroMicroPPP_sm(par);
Q = 1;
w = 1;
ppp_lin_plot (A,B(:,1),C(1,:),D(1,1),A_u,A_w,tau,Q,w,x_0);
psfig("MacroMicroPPP_lin");

## Simulate non-linear PPP (on this linear system)
extras.U_initial = "zero";
extras.U_next = "continuation";
extras.criterion = 1e-8;
extras.max_iterations = 10;
extras.v = 0.1;
extras.verbose = 0;

##  -- with no optimisation using linear PPP with continuation
extras.U_initial = "linear";
extras.U_next = "continuation";
extras.criterion = 1e-5;
extras.max_iterations = 0;

[y_c,x,u_c,t,U,U_c,U_l] = ppp_nlin_sim (system_name,A_u,tau,t_ol,N,w,extras);

##  -- with no optimisation using linear PPP at each step
extras.U_initial = "linear";
extras.U_next = "linear";
extras.criterion = 1e-5;
extras.max_iterations = 0;
[y_l,x,u_l,t,U,U_c,U_l] = ppp_nlin_sim (system_name,A_u,tau,t_ol,N,w,extras);

##  -- with optimisation using nonlinear PPP with continuation
extras.U_initial = "zero";
extras.U_next = "continuation";
extras.criterion = 1e-5;
extras.max_iterations=100;
extras.verbose = 0;
extras.v = 1e-5;
disp("Non-linear optimisation ....");
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
psfig("MacroMicroPPP_U1");

IU2 = [I' U(2,:)'];
IU2_c = [I' U_c(2,:)'];
IU2_l = [I' U_l(2,:)'];
gset grid; xlabel "Interval "
gplot IU2 title "U_2", IU2_c title "U_c2", IU2_l title "U_l2"
psfig("MacroMicroPPP_U2");

## y & u
gset grid; xlabel "Time (sec)"
ty = [t' y'] ; tu =  [t' u']; 
gplot ty title "Output", tu title "Input"

psfig("MacroMicroPPP_yu");

title("");
gset grid; xlabel "Time (sec)"
ty_c = [t' y_c'] ; 
ty_l = [t' y_l'] ; 
ty = [t' y'] ; 
tu =  [t' u']; 
gplot ty_c title "Continuation", ty_l title "Linear", ty title "Optimisation"
psfig("MacroMicroPPP_nppp");



