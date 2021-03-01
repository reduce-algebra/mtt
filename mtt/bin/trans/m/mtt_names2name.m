function name = mtt_names2name (names)

  ## usage:  name = names2name (names)
  ##
  ## Converts array of subsystem names to a standard mtt name

  delim ="__";			# MTT delimiter

  [n,m] = size(names);
  name = deblank(names(1,:));

  for i = 2:n
    name = sprintf("%s%s%s", name, delim, deblank(names(i,:)));
  endfor

endfunction