function fullname = mtt_fullname (subname,compname)

  ## usage:  fullname = mtt_fullname (subname,compname)
  ##
  ## Finds the standard mtt name of the component

  delim = "__";
  fullname = sprintf("%s%s%s", subname, delim, compname);

endfunction