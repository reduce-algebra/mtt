function [Y,X] = ppp_sm2sr(A,B,C,D,T,u0,x0);
  ## Usage [Y,X] = ppp_sm2sr(A,B,C,D,T,u0,x0);
  ## Computes a step response
  ## A,B,C,D- state matrices
  ## T vector of time points
  ## u0 input gain vector: u = u0*unit step.

  ## Copyright (C) 1999 by Peter J. Gawthrop
  ## 	$Id$	

  [Ny,Nu] = size(D);
  [Ny,Nx] = size(C);

  if nargin<6
    u0 = zeros(Nu,1);
    u0(1) = 1;
  end;

  if nargin<7
    x0 = zeros(Nx,1);
  end;

  [N,M] = size(T);
  if M>N
    T = T';
    N = M;
  end;



  one = eye(Nx);

  Y = zeros(Ny,N);
  X = zeros(Nx,N);

  dt = T(2)-T(1);		# Assumes fixed interval
  expAdt = expm(A*dt);		# Compute matrix exponential
  i = 0;
  expAt = one;

  DoingStep = max(abs(u0))>0;	# Is there a step component?
  DoingInitial = max(abs(x0))>0; # Is there an initial component?
  for t = T'
    i=i+1;
    if Nx>0
      x = zeros(Nx,1);
      if DoingStep
	x = x + ( A\(expAt-one) )*B*u0;
      endif
      if DoingInitial
	x = x + expAt*x0;
      endif
      
      expAt = expAt*expAdt;

      X(:,i) = x;
      if Ny>0
	y = C*x + D*u0;
	Y(:,i) = y;
      endif
    elseif Ny>0
      y = D*u0;
      Y(:,i) = y;
    endif
  endfor


endfunction

