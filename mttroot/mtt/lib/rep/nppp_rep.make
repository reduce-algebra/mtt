# -*-makefile-*-
# Makefile for representation nppp
# File nppp_rep.make

#Copyright (C) 2000 by Peter J. Gawthrop

all: $(SYS)_nppp.$(LANG)

$(SYS)_nppp.view: $(SYS)_nppp.ps
	echo Viewing $(SYS)_nppp.ps; ghostview $(SYS)_nppp.ps&

$(SYS)_nppp.ps: $(SYS)_ode2odes.out s$(SYS)_ode2odes.out \
                $(SYS)_sim.m s$(SYS)_sim.m \
                $(SYS)_state.m $(SYS)_sympar.m $(SYS)_numpar.m  \
                s$(SYS)_state.m s$(SYS)_sympar.m s$(SYS)_numpar.m \
                $(SYS)_sm.m $(SYS)_def.m  s$(SYS)_def.m
	octave $(SYS)_nppp.m

$(SYS)_ode2odes.out: 
	echo Starting creation of $(SYS)_ode2odes.out '....'
	mtt -q -c -stdin $(SYS) ode2odes out

s$(SYS)_ode2odes.out:
	echo Starting creation of s$(SYS)_ode2odes.out '....'
	mtt  -q -c -stdin -s s$(SYS) ode2odes out

$(SYS)_sim.m:
	echo Starting creation of $(SYS)_sim '....'
	mtt -q -c $(SYS) sim m

s$(SYS)_sim.m:
	echo Starting creation of s$(SYS)_sim. '....'
	mtt -q -c -s s$(SYS) sim m

$(SYS)_state.m:
	echo Starting creation of $(SYS)_state. '....'
	mtt -q $(SYS) state m

$(SYS)_sympar.m :
	echo Starting creation of $(SYS)_sympar.m '....'
	mtt -q $(SYS) sympar m 

$(SYS)_numpar.m:
	echo Starting creation of $(SYS)_numpar. '....'
	mtt -q $(SYS) numpar m

s$(SYS)_state.m:
	echo Starting creation of s$(SYS)_state. '....'
	mtt -q -s s$(SYS) state m

s$(SYS)_sympar.m :
	echo Starting creation of s$(SYS)_sympar.m '....'
	mtt -q -s s$(SYS) sympar m 

s$(SYS)_numpar.m:
	echo Starting creation of s$(SYS)_numpar. '....'
	mtt -q -s s$(SYS) numpar m

$(SYS)_sm.m:
	echo Starting creation of $(SYS)_sm. '....'
	mtt -q $(SYS) sm m

$(SYS)_def.m:
	echo Starting creation of $(SYS)_def. '....'
	mtt -q $(SYS) def m

s$(SYS)_def.m:
	echo Starting creation of s$(SYS)_def. '....'
	mtt -q -s s$(SYS) def m






