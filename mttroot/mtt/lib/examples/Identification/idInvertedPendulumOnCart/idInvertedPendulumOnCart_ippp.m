
## Set up parameters
name = "idInvertedPendulumOnCart";
sim = sidInvertedPendulumOnCart_simpar;		# Simulation parameter
sym = sidInvertedPendulumOnCart_sympar;		# Parameter names
par = sidInvertedPendulumOnCart_numpar;		# Parameter values
x0  = sidInvertedPendulumOnCart_state(par);         # Initial state

## Simulation of "actual" system
t = [0:sim.dt:sim.last]';
one = ones(size(t));
u = 1.0*(t<one);
y_0 = sidInvertedPendulumOnCart_ssim(x0,par,sim,u);

## Initial parameter
par_0 = par;
par_0(sym.r_c) = 0.1;
par_0(sym.r_p) = 0.1;
par_0(sym.m_c) = 1.0;
## Identify
extras.criterion = 1e-5;
extras.max_iterations = 10;
extras.v = 1e-1;		#Cautious initial step
extras.verbose = 1;		# Show what is going on
[par,Par,Error,Y] = ppp_identify (name,u,y_0,["r_c";"r_p";"m_c"],par_0,extras);

par = par

grid;
xlabel("Time")
title("Estimated output");
plot(t,y_0,t,Y);
figfig("idInvertedPendulumOnCart_outputs","pdf");
figfig("idInvertedPendulumOnCart_outputs","ps");

xlabel("Iteration")
title("Estimation error");
plot(Error);
figfig("idInvertedPendulumOnCart_error","pdf");
figfig("idInvertedPendulumOnCart_error","ps");

xlabel("Iteration")
title("Estimated Parameters");
plot(Par([sym.r_c,sym.r_p,sym.m_c],:)');
figfig("idInvertedPendulumOnCart_parameters","pdf");
figfig("idInvertedPendulumOnCart_parameters","ps");





