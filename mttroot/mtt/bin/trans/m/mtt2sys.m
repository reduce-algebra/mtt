function sys = mtt2sys (Name,par)

  ## usage:  sys = mtt2sys (Name[,par])
  ##
  ## Creates a sys structure for the Octave Control Systems Toolbox
  ## from an MTT system with name "Name"
  ## Optional second argument is system parameter list
  ## Assumes that Name_sm.m, Name_struc.m and Name_numpar.m exist

  ## Copyright (C) 2000 by Peter J Gawthrop


  if nargin<1
    error("missing system name, usage:  sys = mtt2sys (Name)");
  else
    ## Create function names
    numpar_name = sprintf("%s_numpar",Name);
    sm_name = sprintf("%s_sm",Name);
    struc_name = sprintf("%s_struc",Name);
  endif

  if nargin<2			# Use predefined parameters
    mtt(Name,"numpar");
    eval(sprintf("par=%s_numpar;", Name)); # Parameters
    mtt(Name,"sm");		# Create state matrices
    mtt(Name,"struc");		# Create structure info
    mtt(Name,"sympar");		# Create sympar details
  else				# Only create other file if not there
    if  exist(sm_name)!=2
      mtt(Name,"sm");		# Create state matrices
    endif

    if  exist(struc_name)!=2
      mtt(Name,"struc");	# Create state matrices
    endif

  endif
  


  eval(sprintf("[A,B,C,D]=%s_sm(par);", Name)); # State matrices
  sys = ss2sys(A,B,C,D);	# Sys form
  if (rindex(version,"2.0."))	# stable (pre-list)
    eval(sprintf("[sys.inname,sys.outname,sys.stname]=%s_struc;", Name)); # Setup names
  else 				# development version
    eval(sprintf("[mtt_inname,mtt_outname,mtt_stname]=%s_struc;",Name)); # Setup names
    eval(sprintf("sys = syssetsignals(sys,\"in\", mtt_inname);"));
    eval(sprintf("sys = syssetsignals(sys,\"out\",mtt_outname);"));
    eval(sprintf("sys = syssetsignals(sys,\"st\", mtt_stname);"));
  endif
endfunction






