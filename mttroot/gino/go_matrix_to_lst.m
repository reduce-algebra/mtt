function L = go_matrix_to_lst (M)

  ## usage:  L = go_matrix_to_lst (M)
  ##
  ## Converts matrix to list (in ginsh format)

  L = strrep(strrep(M,"[","{"), "]","}");

endfunction