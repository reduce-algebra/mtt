function new_list = go_append (list,element)

  ## usage:  new_list = go_append (list,element)
  ##
  ## Appends element to list to give new list
  ## This is missing from ginsh
  ## Copyright (C) 2002 by Peter J. Gawthrop

  new_list = deblank(list);	# Remove trailing blanks
  new_list = new_list(1:length(new_list)-1); # Zap final }
  if (g_nops(list)=="0")
    new_list = sprintf("%s%s}", new_list, element);
  else
    new_list = sprintf("%s,%s}", new_list, element);
  endif
  

endfunction