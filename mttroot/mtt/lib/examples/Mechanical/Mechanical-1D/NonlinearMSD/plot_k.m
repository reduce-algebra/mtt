## Plots the effective spring constant.

p = NonlinearMSD_numpar;	# Numerical parameters
s = NonlinearMSD_sympar		# Symbolic parameters

Eta = eta=[0:0.01:1]*pi; K = [];
for eta=Eta
  p(s.eta) = eta;		# Change the eta parameter
  A = NonlinearMSD_sm(p);	# SS A matrix
  k = -A(2,1);
  K = [K k];
endfor

grid;
ylabel("k");
xlabel("eta");
plot(Eta,K);
figfig("k","eps");