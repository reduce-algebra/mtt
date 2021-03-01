function N = mtt_check_sigs (outsig,insigs)

  ## usage:  N = mtt_check_sigs (outsig,insigs)
  ##
  ## 

  ##  A signal has the columns: bond number signal causality (+1 or -1)
  ##  and component port number

  M=3;

  ## Sanity check
  [N_out,M_out] = size(outsig);
  if N_out!=1
    error("There must be exactly one outbond");
  endif
  [N_in,M_in] = size(insigs);
  if (M_out!=M)||(M_in!=M)
    error(sprintf("There must be exactly %i elements to a bond (number, causality, port)",M));
  endif

  N = N_in;

endfunction