function [eqn,insigs,innames] = C_seqn (Name, name, cr, arg, outsig, insigs ,innames)

  ## usage:  [eqn,inbonds] = C_seqn (Name, cr, arg, outbond, inbonds)
  ##
  ## 
  ## Multi port C's ??


  [eqn,insigs,innames] = CI_seqn ("C", Name, name, cr, arg, outsig, insigs ,innames);

endfunction
