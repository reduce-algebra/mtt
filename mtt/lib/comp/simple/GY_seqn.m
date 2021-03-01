function [eqn,insigs,innames] = GY_seqn (Name, cr, arg, outsig, insigs, innames)

  ## usage:  [eqn,inbonds] = GY_seqn (Name, cr, arg, outbond, inbonds)
  ##
  ##
  ## GYs have two ports; the input and output ports must be different
  N = mtt_check_sigs (outsig,insigs);

  if N!=2
    error("A GY must have exactly two ports");
  else
    if insigs(1,3)==outsig(3)	# First signal is on output port
      inport = 2;
    else
      inport = 1;
    endif
  endif
  
  insig = insigs(inport,:);
  inname = innames(inport,:);
  eqn = equation("""GY""",Name,cr,arg,outsig(1),outsig(2),outsig(3), ...
		 insig(:,1),insig(:,2),inport);

  insigs = insig;		# Set the correct input signals
  innames = inname;		# Set the correct input names
  
endfunction