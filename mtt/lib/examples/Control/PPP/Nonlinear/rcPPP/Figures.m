## Figures.m
## Makes figures for the rc_PPP exasmple.
## $Log$
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

# ## System info
par  = rcPPP_numpar;
simpar  = rcPPP_simpar;
x_0 = rcPPP_state(par);

# ## Set up the input
# t = [0:simpar.dt:simpar.last];
# A_w = 0;
# A_u = ppp_aug(A_w,laguerre_matrix(1,2.0)) # Specify basis functions: constant & exp(-t/T)
# u = ppp_ustar(A_u,1,t,0,0);

# ## Simulate the system
# tick=time;
# [y,x] = rcPPP_sim(x_0,par,simpar,u);
# Elapsed = time-tick
# plot(t,y)

## Sensitivity system simulation parameters
simpars  = srcPPP_simpar;
sympars  = srcPPP_sympar;
pars  = srcPPP_numpar;
x_0s = srcPPP_state(pars);

t = [0:simpars.dt:simpars.last];
A_w = 0;
A_u = ppp_aug(A_w,laguerre_matrix(1,2.0)) # Specify basis functions: constant & exp(-t/T)
u = ppp_ustar(A_u,1,t,0,0);


## Setup the indices of the adjustable stuff
i_ppp = [sympars.ppp_1, sympars.ppp_1s
	 sympars.ppp_2, sympars.ppp_2s]; # PPP params
i_par = [sympars.x_0,  sympars.x_0s
	 sympars.r,    sympars.rs]; # State and r component

## Simulate the sensitivity system
sensitivities = [i_ppp(:,2); i_par(:,2)]
u = ppp_ustar(A_u,1,t,0,0); 
tick=time;
[y,ys,x] = srcPPP_ssim(x_0s,pars,simpars,u,sensitivities);
Elapsed = time-tick
plot(t,y,t,ys);

### PPP parameters
tau = [0.9:0.01:1];		# Optimisation interval
t_ol = [0:0.01:0.2];		# Open-loop interval
N = 10;				# Number of open-loop intervals in simulation
w = 1;				# Setpoint
w_s = w*ones(10,1);                  # The setpoint witnin the horizon

## Linear system
n_Tau = round(simpars.last/simpars.dt);
dtau = simpars.dt;
Tau = [0:n_Tau-1]'*dtau;
[n_tau,n_w] = size(w_s);
tau = Tau(n_Tau-n_tau+1:n_Tau)
[A,B,C,D] = rcPPP_sm(par);
Q = 1;
w = 1;
ppp_lin_plot (A,B(:,1),C(1,:),D(1,1),A_u,A_w,tau',Q,w);
psfig("rcPPP_lin");

## Simulate non-linear PPP (on this linear system)
extras.U_initial = "zero";
extras.U_next = "continuation";
extras.criterion = 1e-5;
extras.max_iterations = 10;
extras.alpha = 0.1;
extras.verbose = 0;
extras.v = 1e-5;

##  -- with no optimisation using linear PPP with continuation
extras.U_initial = "linear";
extras.U_next = "continuation";
extras.criterion = 1e-5;
extras.max_iterations = 0;
[y_c,x,u_c,t,U,U_c,U_l] = ppp_nlin_sim (system_name,i_ppp,i_par,A_u,w_s,N,extras);

##  -- with no optimisation using linear PPP at each step
extras.U_initial = "linear";
extras.U_next = "linear";
extras.criterion = 1e-5;
extras.max_iterations = 0;
[y_l,x,u_l,t,U,U_c,U_l] = ppp_nlin_sim (system_name,i_ppp,i_par,A_u,w_s,N,extras);

##  -- with optimisation using nonlinear PPP with continuation
extras.U_initial = "zero";
extras.U_next = "continuation";
extras.criterion = 1e-5;
extras.max_iterations = 100;
[y,x,u,t,U,U_c,U_l] = ppp_nlin_sim (system_name,i_ppp,i_par,A_u,w_s,N,extras);


## Plots
title("");

## U, U_c and U_l
I = [1:N]';
IU1 = [I U(:,1)];
IU1_c = [I U_c(:,1)];
IU1_l = [I U_l(:,1)];
gset grid; xlabel "Interval"
gplot IU1 title "U_1", IU1_c title "U_c1", IU1_l title "U_l1"
psfig("rcPPP_U1");

IU2 = [I U(:,2)];
IU2_c = [I U_c(:,2)];
IU2_l = [I U_l(:,2)];
gset grid; xlabel "Interval "
gplot IU2 title "U_2", IU2_c title "U_c2", IU2_l title "U_l2"
psfig("rcPPP_U2");

## y & u
gset grid; xlabel "Time (sec)"
ty = [t y] ; tu =  [t u]; 
gplot ty title "Output", tu title "Input"

psfig("rcPPP_yu");

gset grid; xlabel "Time (sec)"
ty_c = [t y_c] ; 
ty_l = [t y_l] ; 
ty = [t y] ; 
tu =  [t u]; 
gplot ty_c title "Continuation", ty_l title "Linear", ty title "Optimisation"
psfig("rcPPP_ylco");
 