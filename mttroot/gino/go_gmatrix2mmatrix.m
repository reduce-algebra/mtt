function M_m = go_gmatrix2mmatrix (M-g)

  ## usage:  M_m = go_gmatrix2mmatrix (M-g)
  ##
  ## Converts a ginsh format matrix to a matlab format matrix

  M_m = strrep(M_g,"],[","];[");

endfunction