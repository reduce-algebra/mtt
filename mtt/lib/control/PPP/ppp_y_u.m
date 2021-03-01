function [y_u, Us] = ppp_y_u (A,B,C,D,A_u,u_0,tau)

  ## usage:  y_u = ppp_y_u (A,B,C,D,A_u,u_0,t)
  ##
  ## Computes y_u derivative of y* wrt U
  ## Called by ppp_lin
  ## OBSOLETE

  ###############################################################
  ## Version control history
  ###############################################################
  ## $Id$
  ## $Log$
  ## Revision 1.6  2000/12/27 16:41:05  peterg
  ## *** empty log message ***
  ##
  ## Revision 1.5  1999/05/31 01:58:01  peterg
  ## Now uses ppp_extract
  ##
  ## Revision 1.4  1999/05/12 00:10:35  peterg
  ## Modified for alternative (square) A_u
  ##
  ## Revision 1.3  1999/05/03 23:56:32  peterg
  ## Multivariable version - tested for N uncoupled systems
  ##
  ## Revision 1.2  1999/05/03 00:38:32  peterg
  ## Changed data storage:
  ## y_u saved as row vector, one row for each time, one column for
  ## each U
  ## y_x saved as row vector, one row for each time, one column for
  ## each x
  ## W* saved as row vector, one row for each time, one column for
  ## each element of W*
  ## This is consistent with paper.
  ##
  ## Revision 1.1  1999/04/29 06:02:43  peterg
  ## Initial revision
  ##
  ###############################################################



  ## Check argument dimensions
  [n_x,n_u,n_y] = abcddim(A,B,C,D);
  if (n_x==-1)
    return
  endif

  [n,m] = size(A_u);		# Size of composite A_u matrix
  N = m;			# Number of U* functions per input
  
  y_u = [];			# Initialise
  Us = [];
  
#   for input=1:n_u		# Do for each system input
#     a_u = ppp_extract(A_u,input); # Extract the relecant A_u matrix
#     for i=1:N			# Do for each input function U*_i
#       C_u = zeros(1,N); C_u(i) = 1; # Create C_u for this U*_i
#       b = B(:,input);		# B vector for this input
#       d = D(:,input);		# D vector for this input
#       [y,u] = ppp_transient (t,a_u,C_u,u_0,A,b,C,d); # Compute response for this input
#       y_u = [y_u y'];		# Save y_u (y for input u)  with one row for each t.
#       Us = [Us u'];		# Save u (input)  with one row for each t.
#     endfor
#   endfor
  i_U = 0;
  x_0 = zeros(n_x,1);		# This is for x=0
  for input=1:n_u		# Do for each system input
    a_u = ppp_extract(A_u,input); # Extract the relevant A_u matrix
    for i=1:N			# Do for each input function U*_i
      dU = zeros(N*n_u,1);
      dU(++i_U) = 1;		# Create dU/dU_i 
      [ys,us] = ppp_ystar (A,B,C,D,x_0,a_u,dU,tau); # Find ystar and ustar
      y_u = [y_u ys'];		# Save y_u (y for input u)  with one row for each t.
      Us = [Us us'];		# Save u (input)  with one row for each t.
    endfor
  endfor

endfunction




