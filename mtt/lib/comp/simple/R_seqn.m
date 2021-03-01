function [eqn,insigs,innames] = R_seqn (Name, name, cr, arg, outsig, insigs, innames)

  ## usage:  [eqn,inbonds] = R_seqn (Name, cr, arg, outbond, inbonds)
  ##
  ## 
  ## Multi port R's use all potential signals

  N = mtt_check_sigs (outsig,insigs);
  
  inports = [1:N]; 
  eqn = equation("""R""",Name,cr,arg,outsig(1),outsig(2),outsig(3), ...
		 insigs(:,1),insigs(:,2),inports);

  ## No change
  ## insigs = insigs;
  ## innames = innames;

endfunction