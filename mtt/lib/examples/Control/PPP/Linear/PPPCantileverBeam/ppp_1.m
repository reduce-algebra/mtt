function  ppp_1(Name,Inputs,Modes);

# Name = "CantileverBeam"
# Inputs = 1:2
# Modes = [1 2;1 3]

  path(path,"~/Research/CGPC/PPP");  
  
  Name,Inputs,Modes

  ## System
  system(sprintf("mtt -q %s numpar m", Name));
  system(sprintf("mtt -q %s sm m", Name));
  par = eval(sprintf("%s_numpar;",Name));
  eval(sprintf("[A,B,C,D]=%s_sm(par);",Name));
  [n_x,n_u,n_y] = abcddim(A,B,C,D)


  ## Change B
  B = B(:,Inputs);
  [junk,n_u]=size(B);
  n_u

  ## Redo C and D to reveal ALL velocities
   n_y = n_x/2
   C = zeros(n_y,n_x);
   for i = 1:n_y
     C(i,2*i-1) = 1;
   endfor

  ## Sort out D
  D = zeros(n_y,n_u);

  e = eig(A);			# Eigenvalues
  N = length(e);
  frequencies = sort(imag(e));
  frequencies = frequencies(N/2+1:N); # Modal frequencies

  ## Controller
  ## Controller design parameters
  t = [0.9:0.01:1.0];		# Optimisation horizon

  ## Specify input basis functions 
  ##  - damped sinusoids with same frequencies as beam
  damping_ratio = [0.1 0.1];		# Damping ratio of inputs
  A_u=[];
#   Modes = [1  3  
# 	   1  2];		# Choose modes to be controlled by each input 
  if n_u == 1			# Put all modes on each input
    Modes = [Modes; Modes];
  endif
  
  Modes

  for i=Inputs
    A_ui = damped_matrix(frequencies(Modes(i,:)),damping_ratio(i)*ones(size(Modes(i,:))));
    A_u = [A_u;A_ui];
    u_0 = ones(n_x,1);		# Initial conditions
  endfor
  

  A_w = 0;			# Setpoint
  Q = ones(n_y,1);		# Output weighting

  ## Design 
  disp("Control design - unconstrained");
  [k_x,k_w,K_x,K_w,Us0,J_uu,J_ux,J_uw] = ppp_lin  (A,B,C,D,A_u,A_w,t); # Unconstrained design

  ## Organise some plots
   dt = 0.002;		# Time increment
#   T =  0:dt:t(length(t));	# Time starting at zero but past horizon
   T =  0:dt:1.0;		# Time 

  ## Set up an "typical" initial condition
  x_0 = zeros(n_x,1);
  x_0(2:2:n_x) = ones(1,n_x/2);	# Set initial twist to 1.
#  disp("Computing OL response");
#  [Ys,Us] = ppp_transient (T,A_u,-(K_x*x_0)',u_0,A,B,C,D,x_0); # Compute open-loop control
  
  
  disp("Computing OL response (no control)");
  [Y_0] = ppp_sm2sr(A, B, C, D, T, zeros(n_u,1), x_0); # Compute Closed-loop control
  title("Y (no control)");
  xlabel("Time")
  grid; 
  plot(T,Y_0);
  psfig(sprintf("%s_pppy0",Name));

  disp("Computing Unconstrained CL response");
  [y_u,X_u] = ppp_sm2sr(A-B*k_x, B, C, D, T, zeros(n_u,1), x_0);
  u_u = -k_x*X_u';


  title("Unconstrained closed-loop control - y");
  xlabel("Time")
  grid; 
  plot(T,y_u);
  psfig(sprintf("%s_pppy",Name));

  title("Unconstrained closed-loop control - u");
  xlabel("Time")
  grid; 
  plot(T,u_u);
  psfig(sprintf("%s_pppu",Name));

#   ## Constrained version
  
#   ## Constraints - u
#   Tau_u = [0:0.01:1];
#   one = ones(size(Tau_u));
#   limit = 1e10;
#   Min_u = -limit*one;
#   Max_u =  limit*one;
#   Order_u = 0*one;

#   ## Constraints - y
#   Tau_y = [];
#   one = ones(size(Tau_y));
#   limit = 1e5; 
#   Min_y = -limit*one;
#   Max_y =  limit*one;
#   Order_y = 0*one;

#   ## Simulation

#   ## Constrained - open-loop
#   Gamma = [];
#   gamma = [];
#   for i=1:n_u			# Put same constraints on each input
#     [Gamma_i,gamma_i] = ppp_input_constraint (A_u,Tau_u,Min_u,Max_u,Order_u,i,n_u);
#     Gamma = [Gamma; Gamma_i];
#     gamma = [gamma; gamma_i];
#   endfor


#   disp("Open-loop simulations...");
#   ## Constrained OL simulation
#   W = zeros(n_y,1);
#   [u,U] = ppp_qp (x_0,W,J_uu,J_ux,J_uw,Us0,Gamma,gamma);
#   T = [0:t(2)-t(1):t(length(t))];
#   [ys,us] = ppp_ystar (A,B,C,D,x_0,A_u,U,T);

#   title("Constrained y*");
#   xlabel("t");
#   grid;
#   plot(T,ys)

#   ## Unconstrained OL simulation
#   [uu,Uu] = ppp_qp (x_0,W,J_uu,J_ux,J_uw,Us0,[],[]); 
#   [ysu,usu] = ppp_ystar (A,B,C,D,x_0,A_u,Uu,T);

#   title("Unconstrained y*");
#   xlabel("t");
#   grid;
#   plot(T,ysu)

#   ## Non-linear - closed-loop
#   disp("Closed-loop simulation");
#   Tc = [0:4e-4:1.0];	
#   Delta_ol = 1.0;
#   [yc,uc,J] = ppp_qp_sim (A,B,C,D,A_u,A_w,t,Q, T, Tau_u,Min_u,Max_u,Order_u, Tau_y,Min_y,Max_y,Order_y,W,x_0,Delta_ol);

#   title("y,y*,u and u*");
#   xlabel("t");
#   grid;
#   plot(T1,y,T,ys,T1,u,T,us);

endfunction








