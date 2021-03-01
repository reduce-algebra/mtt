function [eqn,insigs,innames] = AF_seqn (Name, name, cr, arg, outsig, insigs, innames)

  ## usage:  [eqn,inbonds] = AF_seqn (Name, cr, arg, outbond, inbonds)
  ##
  ## Implements the AF component 

  [eqn,insigs,innames] = Amp_seqn ("AF",Name, name, cr, arg, outsig, insigs, innames);
endfunction