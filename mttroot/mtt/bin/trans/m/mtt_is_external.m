function is_external = mtt_is_external (comp_type,outsig, insigs, is_port)

  ## usage:  is_external = mtt_is_external (comp_type,outsig, insigs)
  ##
  ## 

  if nargin<4
    is_port = 0;
  endif

  is_external = 0;			# Default

  if strcmp(comp_type,"SS");
    is_external = insigs(1,2)!=outsig(2);
  else
    is_external = 0;
  endif

endfunction