function psfig(filename)
  ## Usage: psfig(filename)
  ## Puts figure into ps file

  ###############################################################
  ## Version control history
  ###############################################################
  ## $Id$
  ## $Log$
  ## Revision 1.1  1999/11/30 23:26:21  peterg
  ## Initial revision
  ##
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
  
  eval(sprintf("gset output \"%s\" ",filename));
  gset linestyle 1 lw 4		# Thicker lines
  gset linestyle 2 lw 4		# Thicker lines
  gset linestyle 3 lw 4		# Thicker lines
  gset linestyle 4 lw 4		# Thicker lines
  gset linestyle 5 lw 4		# Thicker lines


  gset term postscript eps 
  replot;
  gset term x11
  gset output 
  replot;

endfunction
