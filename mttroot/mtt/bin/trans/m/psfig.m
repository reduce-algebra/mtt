function psfig(filename)
  ## Usage: psfig(filename)
  ## Puts figure into ps file

  ###############################################################
  ## Version control history
  ###############################################################
  ## $Id$
  ## $Log$
  ## Revision 1.3  1999/09/04 02:23:30  peterg
  ## Removed mv stuff - now uses gset on actual file
  ##
  ## Revision 1.2  1999/06/15 02:05:44  peterg
  ## Now adds a .ps if not there already
  ##
  ## Revision 1.1  1999/03/25 01:35:00  peterg
  ## Initial revision
  ##
  ###############################################################

  ## Add .ps if not there already
  if !index(filename,".")	# Is there a .
    filename = sprintf("%s.ps",filename);
  endif
  
  gset term postscript eps
  eval(sprintf("gset output \"%s\" ",filename));
  replot;
  gset term x11
  gset output 
  replot;

endfunction
