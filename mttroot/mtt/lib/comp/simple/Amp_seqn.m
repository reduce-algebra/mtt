function [eqn,insigs,innames] = Amp_seqn (AmpType,Name, name, cr, arg, outsig, insigs, innames)

  ## usage:  [eqn,inbonds] = AF_seqn (Name, cr, arg, outbond, inbonds)
  ##
  ## 

  N = mtt_check_sigs (outsig,insigs);
  if (N!=2)
    mtt_error("Amplifier component must have exactly two ports");
  endif
  

  ## On which port is the equation required?
  outbond_number = outsig(1);
  outport = find(abs(insigs(:,1))!=outbond_number*ones(N,1));

  ## Some definitions
  flow = -1;
  effort = 1;

  if strcmp(AmpType,"AE")
    causality = effort;
    other_causality = flow;
  elseif strcmp(AmpType,"AF")
    causality = flow;
    other_causality = effort;
  else
    mtt_error(sprintf("Amp_seqn: type %s unknown", AmpType));
  endif
  
  ## Standard causality
  if (outport==2)
    qAmpType = sprintf("""%s""", AmpType);
    eqn = equation(qAmpType,Name,cr,arg,outsig(1),causality,2, ...
		 insigs(2,1),causality,1);
  elseif (outport==1)
    LHS = varname(Name,insigs(2,1),other_causality);
    eqn = sprintf("%s := 0;", LHS);
  else
    mtt_error("AF_seqn: outport must be 1 or 2");
  endif

endfunction