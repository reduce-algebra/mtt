function stripped_name = mtt_strip_name (name)

  ## usage:  stripped_name = mtt_strip_name (name)
  ##
  ## Removes blanks and [] from a port name

  if (length(name)==0)
    error("Zero length port name found");
  endif


  [N,M] = size(name)
  if N>1
    error("Cannot resolve port names: redraw abg.fig");
  endif
  
  
  stripped_name = deblank(name); # remove blanks
  stripped_name = stripped_name(2:length(stripped_name)-1);
  stripped_name = deblank(stripped_name); # remove blanks

endfunction