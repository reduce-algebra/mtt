function [args] = mtt_alias (fullname,args,default);
  ## usage:  [cr,args] = mtt_alias (fullname,cr,args)
  ##
  ## Aliasing code for mtt.
  ## Abstracted from cbg2ese for use in cbg2sese_m2r

  ## Copyright (C) 2003 by Peter J. Gawthrop

  filenum = -1;			# No file number for messages

  [Name,name] = mtt_subname(fullname); # Split fullname

  if (length(args)==0)
    mtt_info(sprintf("No arguments given so no argument aliasing done for system %s",\
		     fullname));
    return
  endif
  
  ## Info for component and surrounding subsystem
  cbg = mtt_cbg(fullname);	# Structure for this component

  if (length(Name)==0)
    return
  else
    Cbg = mtt_cbg(Name);		# Structure for this subsystem
  endif
  

  ## Argument aliasing
  message = sprintf("\tfor component  %s within %s",name,Name);
  if struct_contains(cbg,"alias")
    args = alias_args(args,cbg.alias,";",message,filenum,fullname);
  endif;

  ## Substitute positional params
  Args = eval(sprintf("Cbg.subsystems.%s.arg;", name));
  args = subs_arg(args,Args,default,Name,"",name,filenum);

endfunction