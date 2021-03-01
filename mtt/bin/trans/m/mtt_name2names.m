function names = mtt_name2names (name)

  ## usage:  names = mtt_name2names (name)
  ##
  ## Converts standard mtt name to an array of subsystem names

  ## Copyright (C) 2003 by Peter J. Gawthrop

  delim ="__";			# MTT delimiter
  names = char(strsplit(name,delim));

endfunction