function [eqn,insigs,innames] = I_seqn (Name, name, cr, arg, outsig, insigs ,innames)

  ## usage:  [eqn,inbonds] = I_seqn (Name, cr, arg, outbond, inbonds)
  ##
  ## 
  ## Multi port I's ??


  [eqn,insigs,innames] = CI_seqn ("I", Name, name, cr, arg, outsig, insigs ,innames);

endfunction
