function [dfdx_l, dfdx_m] = go_diff (f,x)

  ## usage:  [dfdx_l dfdx_m] = go_diff (f,x)
  ##
  ## dfdx_l is a list with ith element df/dx
  ## dfdx_m the corresponing matrix (in ginsh form)
  ## f may itself be a list
  ## The elements of x must be symbols

  N = eval(g_nops(f));
  M = eval(g_nops(x));

  dfdx = "{}";

  ## Find derivatives of f for each x_i and append to list
  for j = 1:M
    dfdx = go_append(dfdx, g_diff(f,g_op(x,int2str(j-1))));
  endfor

  ## Convert to matrix and transpose
  dfdx_m = g_transpose(go_lst_to_matrix(dfdx));

  ## And back to a list
  dfdx_l = go_matrix_to_lst(dfdx_m);

endfunction