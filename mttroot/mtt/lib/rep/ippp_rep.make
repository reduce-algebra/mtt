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
  ## Revision 1.2  2001/04/05 11:49:07  gawthrop
  ## Fixed a number of bugs to as to work with reports.
  ##
  ## Revision 1.1  2001/04/04 10:05:38  gawthrop
  ## Reresentation for system identification for ppp
  ##
  ###############################################################

#Copyright (C) 2000 by Peter J. Gawthrop

all: $(SYS)_ippp.$(LANG)

$(SYS)_ippp.view:  $(SYS)_ippp.pdf
	acroread *.pdf

$(SYS)_ippp.ps: $(SYS)_parameters.ps $(SYS)_error.ps $(SYS)_outputs.ps $(SYS)_ippp.pdf
	cp $(SYS)_parameters.ps $(SYS)_ippp.ps

$(SYS)_ippp.pdf: $(SYS)_parameters.pdf $(SYS)_error.pdf $(SYS)_outputs.pdf
	cp $(SYS)_parameters.pdf $(SYS)_ippp.pdf

$(SYS)_parameters.ps: s$(SYS)_ode2odes.m s$(SYS)_ssim.m $(SYS)_ippp.m s$(SYS)_sympar.m s$(SYS)_simpar.m
	octave $(SYS)_ippp.m

$(SYS)_error.ps: $(SYS)_parameters.ps
	touch $(SYS)_error.ps

$(SYS)_outputs.ps: $(SYS)_parameters.ps
	touch $(SYS)_outputs.ps

$(SYS)_parameters.pdf: s$(SYS)_ode2odes.m s$(SYS)_ssim.m $(SYS)_ippp.m s$(SYS)_sympar.m s$(SYS)_simpar.m
	octave $(SYS)_ippp.m

$(SYS)_error.pdf: $(SYS)_parameters.pdf
	touch $(SYS)_error.pdf

$(SYS)_outputs.pdf: $(SYS)_parameters.pdf
	touch $(SYS)_outputs.pdf

## Note when a proper input.cc for stdin is available, change to
## mtt -q $(OPTS) -stdin -s s$(SYS) ode2odes oct
s$(SYS)_ode2odes.m: 
	echo Starting creation of s$(SYS)_ode2odes.m with options $(OPTS)
	mtt -q $(OPTS) -s s$(SYS) ode2odes m; rm s$(SYS)_input.oct; make_stdin s$(SYS) m

s$(SYS)_ssim.m: s$(SYS)_def.m
	mtt -q $(OPTS) -s s$(SYS) ssim m

s$(SYS)_sympar.m:
	mtt -q $(OPTS) -s s$(SYS) sympar m

s$(SYS)_simpar.m:
	mtt -q $(OPTS) -s s$(SYS) simpar m

s$(SYS)_def.m:
	mtt -q $(OPTS) -s s$(SYS) def m

