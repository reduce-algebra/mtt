## Makes the figures

par = ReactorTQ_numpar;		# Parameters
sym = ReactorTQ_sympar;		# Parameter indices

F_s= [90:10:500];		# Range of flows

Z = [];
for f_s=F_s
  par(sym.f_s) = f_s;
  z = sort(eig(ReactorTQ_sm(par)));
  Z = [Z z];
endfor


grid; xlabel("f_s"); ylabel("z");
plot(F_s,Z);
psfig("ReactorTQ_zero");

