function [eqn,insigs,innames] = AE_seqn (Name, name, cr, arg, outsig, insigs, innames)

  ## usage:  [eqn,inbonds] = AE_seqn (Name, cr, arg, outbond, inbonds)
  ##
  ## Implements the AE component 

  [eqn,insigs,innames] = Amp_seqn ("AE",Name, name, cr, arg, outsig, insigs, innames);
endfunction