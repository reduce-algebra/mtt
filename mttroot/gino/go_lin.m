function [A,B,C,D] = go_lin (f,g)

  ## usage:  [A,B,C,D] = go_lin (f,g)
  ##
  ## 

  n_x = eval(g_nops(f));		# Number of states
  n_y = eval(g_nops(g));		# Number of outputs

  n_u = n_y;

  ## Create symbolic state list
  x = "{}";
  for i=1:n_x
    x = go_append(x,sprintf("x_%i", i));
  endfor


  ## Create symbolic input list
  u = "{}";
  for i=1:n_u
    u = go_append(u,sprintf("u_%i", i));
  endfor
		  
  [A_l,A] = go_diff(f,x);
  [B_l,B] = go_diff(f,u);
  [C_l,C] = go_diff(g,x);
  [D_l,D] = go_diff(g,u);

endfunction