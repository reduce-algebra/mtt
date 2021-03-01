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
  ## Revision 1.5  2002/12/12 17:18:42  geraint
  ## Fixed [ 647664 ] Namespace clash: LANG
  ## Prepended MTT_ to SYS, OPTS and LANG environment variables.
  ##
  ## Revision 1.4  2001/04/23 15:06:21  gawthrop
  ## Removed stdin bug workaround
  ##
  ## Revision 1.3  2001/04/11 07:52:45  gawthrop
  ## Temporary fix to avoid incorrect _input.cc with stdin
  ##
  ## Revision 1.2  2001/04/05 11:49:07  gawthrop
  ## Fixed a number of bugs to as to work with reports.
  ##
  ## Revision 1.1  2001/04/04 10:05:38  gawthrop
  ## Reresentation for system identification for ppp
  ##
  ###############################################################

#Copyright (C) 2000 by Peter J. Gawthrop

all: $(MTT_SYS)_ippp.$(MTT_LANG)

$(MTT_SYS)_ippp.view:  $(MTT_SYS)_ippp.pdf
	acroread *.pdf

$(MTT_SYS)_ippp.ps: $(MTT_SYS)_parameters.ps $(MTT_SYS)_error.ps $(MTT_SYS)_outputs.ps $(MTT_SYS)_ippp.pdf
	cp $(MTT_SYS)_parameters.ps $(MTT_SYS)_ippp.ps

$(MTT_SYS)_ippp.pdf: $(MTT_SYS)_parameters.pdf $(MTT_SYS)_error.pdf $(MTT_SYS)_outputs.pdf
	cp $(MTT_SYS)_parameters.pdf $(MTT_SYS)_ippp.pdf

$(MTT_SYS)_parameters.ps: s$(MTT_SYS)_ode2odes.m s$(MTT_SYS)_ssim.m $(MTT_SYS)_ippp.m s$(MTT_SYS)_sympar.m s$(MTT_SYS)_simpar.m
	octave $(MTT_SYS)_ippp.m

$(MTT_SYS)_error.ps: $(MTT_SYS)_parameters.ps
	touch $(MTT_SYS)_error.ps

$(MTT_SYS)_outputs.ps: $(MTT_SYS)_parameters.ps
	touch $(MTT_SYS)_outputs.ps

$(MTT_SYS)_parameters.pdf: s$(MTT_SYS)_ode2odes.m s$(MTT_SYS)_ssim.m $(MTT_SYS)_ippp.m s$(MTT_SYS)_sympar.m s$(MTT_SYS)_simpar.m
	octave $(MTT_SYS)_ippp.m

$(MTT_SYS)_error.pdf: $(MTT_SYS)_parameters.pdf
	touch $(MTT_SYS)_error.pdf

$(MTT_SYS)_outputs.pdf: $(MTT_SYS)_parameters.pdf
	touch $(MTT_SYS)_outputs.pdf

s$(MTT_SYS)_ode2odes.m: 
	echo Starting creation of s$(MTT_SYS)_ode2odes.m with options $(MTT_OPTS)
	mtt -q $(MTT_OPTS) -stdin -s s$(MTT_SYS) ode2odes m

s$(MTT_SYS)_ssim.m: s$(MTT_SYS)_def.m
	mtt -q $(MTT_OPTS) -s s$(MTT_SYS) ssim m

s$(MTT_SYS)_sympar.m:
	mtt -q $(MTT_OPTS) -s s$(MTT_SYS) sympar m

s$(MTT_SYS)_simpar.m:
	mtt -q $(MTT_OPTS) -s s$(MTT_SYS) simpar m

s$(MTT_SYS)_def.m:
	mtt -q $(MTT_OPTS) -s s$(MTT_SYS) def m

