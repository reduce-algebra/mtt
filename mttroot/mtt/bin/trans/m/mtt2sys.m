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
    if exist(numpar_name)!=2	# Check file exists
      error("File %s.m does not exist: use <mtt %s numpar m> to create it",\
	    numpar_name,Name);
    endif
    eval(sprintf("par=%s_numpar;", Name)); # Parameters
  endif
  
  ## Check files exist
  if exist(sm_name)!=2
    error("File %s.m does not exist: use <mtt %s sm m> to create it",\
	  sm_name,Name);
  endif

  if exist(struc_name)!=2
    error("File %s.m does not exist: use <mtt %s struc m> to create it",\
	  struc_name,Name);
  endif
  
  eval(sprintf("[A,B,C,D]=%s_sm(par);", Name)); # State matrices
  sys = ss2sys(A,B,C,D);	# Sys form
  eval(sprintf("[sys.inname,sys.outname,sys.stname]=%s_struc;", Name)); # Setup names
  
endfunction






