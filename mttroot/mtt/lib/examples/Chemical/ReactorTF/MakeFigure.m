## Makes the figures

par = ReactorTF_numpar;		# Parameters
sym = ReactorTF_sympar;		# Parameter indices

F_s= [90:10:500];		# Range of flows

Z = [];
for f_s=F_s
  par(sym.f_s) = f_s;
  z = sort(eig(ReactorTF_sm(par)));
  Z = [Z z];
endfor


grid; xlabel("f_s"); ylabel("z_1");
plot(F_s,Z(1,:));
psfig("ReactorTF_zero_1");

grid; xlabel("f_s"); ylabel("z_2");
plot(F_s,Z(2,:));
psfig("ReactorTF_zero_2");
