

par = Reactor_numpar;		# Parameters
sym = Reactor_sympar;		# Parameter indices

F_s= [90:10:500];		# Range of flows

Z_a = []; Z_b = []; P = [];
for f_s=F_s
  par(sym.f_s) = f_s;
  [A,B,C,D] = Reactor_sm(par);	# Linearised system

  p = sort(eig(A));
  P = [P p];

  C_a = C([1 3],:);		# C vector for c_a and t
  D_a = D([1 3],:);		# D vector for c_a and t
  z_a = tzero(A,B,C_a,D_a);	# Transmission zeros for c_a and t
  Z_a = [Z_a z_a];

  C_b = C(2:3,:);		# C vector for c_b and t
  D_b = D(2:3,:);		# D vector for c_b and t
  z_b = tzero(A,B,C_b,D_b);	# Transmission zeros for c_b and t
  Z_b = [Z_b z_b];
endfor

grid; xlabel("f_s"); ylabel("p1,p2");
plot(F_s,P(1:2,:));
psfig("Reactor_pole_1_2");

grid; xlabel("f_s"); ylabel("p3");
plot(F_s,P(3,:));
psfig("Reactor_pole_3");

grid; xlabel("f_s"); ylabel("z_a");
plot(F_s,Z_a);
psfig("Reactor_zero_a");

grid; xlabel("f_s"); ylabel("z_b");
plot(F_s,Z_b);
psfig("Reactor_zero_b");

