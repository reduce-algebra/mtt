function stripped_name = mtt_strip_name (name)

  ## usage:  stripped_name = mtt_strip_name (name)
  ##
  ## Removes blanks and [] from a port name

  stripped_name = deblank(name); # remove blanks
  stripped_name = stripped_name(2:length(stripped_name)-1);
  stripped_name = deblank(stripped_name); # remove blanks

endfunction