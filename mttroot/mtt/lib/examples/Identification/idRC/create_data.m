## Create some data
  c = 1;
  r = 5;
  tau = r*c;

  t = [0:0.1:10]';		# time
  one = ones(size(t));
  u = one;			# Step input
  y = one - exp(-t/tau);	# Exact step response

  save idRC_ident_data.dat y u t

