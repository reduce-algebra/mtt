
## Set up parameters
name = "idRC";
sim = sidRC_simpar;		# Simulation parameter
sym = sidRC_sympar;		# Parameter names
par = sidRC_numpar;		# Parameter values
par([sym.us,sym.rs,sym.cs])=0;	# Reset sensitivity params
x0  = sidRC_state(par);         # Initial state

## Simulation of "actual" system
t = [0:sim.dt:sim.last]';
T = 5;				# Period
u = sin((2*pi/T)*t);
y_0 = sidRC_ssim(x0,par,sim,u,1);

## Initial parameter
par_0 = par;
par_0(sym.r) = 0.1;

## Identify
extras.criterion = 1e-5;
extras.max_iterations = 10;
extras.v = 1e-5;
extras.verbose = 1;		# Show what is going on
[par,Par,Error,Y] = ppp_identify (name,u,y_0,["r"],par_0,extras);

par = par

grid;
xlabel("Time")
title("Estimated output");
plot(t,y_0,t,Y);
figfig("idRC_outputs","pdf");
figfig("idRC_outputs","ps");

xlabel("Iteration")
title("Estimation error");
plot(Error);
figfig("idRC_error","pdf");
figfig("idRC_error","ps");

xlabel("Iteration")
title("Estimated Parameter");
plot(Par');
figfig("idRC_parameters","pdf");
figfig("idRC_parameters","ps");
