function is_external = mtt_is_external (comp_type,outsig, insigs, is_port)

  ## usage:  is_external = mtt_is_external (comp_type,outsig, insigs, is_port)
  ##
  ## This is to determine if mtt_component_equation should look for
  ## another equation. If is_external, the varable is available as a
  ## system input and therfore requires no further equation.
  ## I suspect that it needs more work.


  if nargin<4
    is_port = 0;
  endif

  is_external = 0;			# Default

  if is_port
    is_external = 0;
  elseif strcmp(comp_type,"SS");
    is_external = insigs(1,2)!=outsig(2);
  else
    is_external = 0;
  endif

endfunction