function [subname, compname] = mtt_subname (name)

  ## usage:  subname = mtt_subname (name)
  ##
  ## Finds the subsystem name from the component name
  ## Copyright (C) 2003 by Peter J. Gawthrop


  names = mtt_name2names(name);
  [n,m] = size(names);

  if n<2			# Simple name
    subname = "";
    compname = name;
  else				# Compound name
    subname = mtt_names2name(names(1:n-1,:));
    compname = deblank(names(n,:));
  endif

endfunction