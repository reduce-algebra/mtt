# -*-makefile-*-
# Makefile for representation ippp - ppp system identification
# File ippp_rep.make

  ###################################### 
  ##### Model Transformation Tools #####
  ######################################

  ###############################################################
  ## Version control history
  ###############################################################
  ## $Id$
  ## $Log$
  ###############################################################

#Copyright (C) 2000 by Peter J. Gawthrop

all: $(SYS)_ippp.$(LANG)

$(SYS)_ippp.view: $(SYS)_parameters.pdf $(SYS)_error.pdf $(SYS)_outputs.pdf
	( cd MTT_work; acroread *.pdf )

$(SYS)_parameters.pdf: s$(SYS)_ode2odes.oct s$(SYS)_ssim.m $(SYS)_ippp.m s$(SYS)_sympar.m s$(SYS)_simpar.m
	(cd MTT_work; octave $(SYS)_ippp.m)

$(SYS)_error.pdf: $(SYS)_parameters.pdf
	(cd MTT_work; touch $(SYS)_error.pdf)

$(SYS)_outputs.pdf: $(SYS)_parameters.pdf
	(cd MTT_work; touch $(SYS)_outputs.pdf)

## Note when a proper input.cc for stdin is available, change to
## mtt -q -stdin -s s$(SYS) ode2odes oct
s$(SYS)_ode2odes.oct: 
	echo Starting creation of s$(SYS)_ode2odes.oct '....'
	mtt -q -s s$(SYS) ode2odes oct; (cd MTT_work; make_stdin s$(SYS) m)

s$(SYS)_ssim.m:
	mtt -q -s s$(SYS) ssim m

s$(SYS)_sympar.m:
	mtt -q -s s$(SYS) sympar m

s$(SYS)_simpar.m:
	mtt -q -s s$(SYS) simpar m





