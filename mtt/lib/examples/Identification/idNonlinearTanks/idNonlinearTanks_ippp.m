
## Set up parameters
name = "idNonlinearTanks";
sim = sidNonlinearTanks_simpar;	# Simulation parameter
sym = sidNonlinearTanks_sympar;	# Parameter names
par = sidNonlinearTanks_numpar;	# Parameter values
x0  = sidNonlinearTanks_state(par); # Initial state

## Simulation of "actual" system
t = [0:sim.dt:sim.last]';
T = 5;				# Period
u = ones(size(t));
y_0 = sidNonlinearTanks_ssim(x0,par,sim,u,2);

plot(t,y_0);

## The initial parameters
par_0 = par;
par_0(sym.V_1) = 2.0;
par_0(sym.V_2) = 1.0;
par_0(sym.alpha) = 1.0;
par_0(sym.beta) = 2.0;

## Identify
extras.criterion = 1e-5;
extras.max_iterations = 10;
extras.v = 10;			# Use a really big initial value
extras.verbose = 1;		# Show what is going on
[par,Par,Error,Y] = ppp_identify (name,u,y_0,["V_1  ";"V_2  ";"alpha";"beta "],par_0,extras);

par = par

grid;
xlabel("Time")
title("Output");
plot(t,y_0);
figfig("idNonlinearTanks_output","pdf");
figfig("idNonlinearTanks_output","ps");
grid;

xlabel("Time")
title("Estimated output");
plot(t,y_0,t,Y);
figfig("idNonlinearTanks_outputs","pdf");
figfig("idNonlinearTanks_outputs","ps");

xlabel("Iteration")
title("Estimation error");
plot(Error);
figfig("idNonlinearTanks_error","pdf");
figfig("idNonlinearTanks_error","ps");

xlabel("Iteration")
title("Estimated Parameter");
plot(Par');
figfig("idNonlinearTanks_parameters","pdf");
figfig("idNonlinearTanks_parameters","ps");
