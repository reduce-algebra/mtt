# -*-makefile-*-
# Makefile for representation nppp
# File nppp_rep.make

#Copyright (C) 2000,2001,2002 by Peter J. Gawthrop

model_reps = ${SYS}_sympar.m ${SYS}_simpar.m ${SYS}_state.m\
             ${SYS}_numpar.m ${SYS}_input.m ${SYS}_ode2odes.m\
             ${SYS}_sim.m ${SYS}_def.m

sensitivity_reps = s${SYS}_sympar.m s${SYS}_simpar.m s${SYS}_state.m\
                   s${SYS}_numpar.m s${SYS}_input.m s${SYS}_ode2odes.m\
                   s${SYS}_ssim.m s${SYS}_def.m

all: ${SYS}_nppp.${LANG}

${SYS}_nppp.help_short:
	nppp_rep.sh ${SYS} help_short

${SYS}_nppp.help_long:
	nppp_rep.sh ${SYS} help_long

${SYS}_nppp.view: ${SYS}_nppp.ps
	echo Viewing ${SYS}_nppp.ps; ghostview ${SYS}_nppp.ps&

${SYS}_nppp.ps: ${SYS}_nppp.fig
	nppp_rep.sh ${SYS} ps

${SYS}_nppp.fig: ${SYS}_nppp.gdat
	nppp_rep.sh ${SYS} fig

${SYS}_nppp.gdat: ${SYS}_nppp.dat2
	nppp_rep.sh ${SYS} gdat

${SYS}_nppp.dat2: ${SYS}_nppp.m ${SYS}_nppp_numpar.m \
                  ${model_reps} ${sensitivity_reps} ${SYS}_def.r
	nppp_rep.sh ${SYS} dat2

${SYS}_nppp.m: 
	nppp_rep.sh ${SYS} m

${SYS}_nppp_numpar.m:
	nppp_rep.sh ${SYS} numpar.m

## System model reps
${SYS}_sympar.m:
	mtt ${OPTS} -q -stdin ${SYS} sympar m

${SYS}_simpar.m:
	mtt ${OPTS} -q -stdin ${SYS} simpar m

${SYS}_state.m:
	mtt ${OPTS} -q -stdin ${SYS} state m

${SYS}_numpar.m:
	mtt ${OPTS} -q -stdin ${SYS} numpar m

${SYS}_input.m:
	mtt ${OPTS} -q -stdin ${SYS} input m

${SYS}_ode2odes.m:
	mtt ${OPTS} -q -stdin ${SYS} ode2odes m

${SYS}_sim.m:
	mtt ${OPTS} -q -stdin ${SYS} sim m

${SYS}_def.m:
	mtt ${OPTS} -q -stdin ${SYS} def m

${SYS}_def.r:
	mtt ${OPTS} -q -stdin ${SYS} def r


## Sensitivity model reps
s${SYS}_sympar.m:
	mtt -q -stdin ${OPTS} -s s${SYS} sympar m

s${SYS}_simpar.m:
	mtt -q -stdin ${OPTS} -s s${SYS} simpar m

s${SYS}_state.m:
	mtt -q -stdin ${OPTS} -s s${SYS} state m

s${SYS}_numpar.m:
	mtt -q -stdin ${OPTS} -s s${SYS} numpar m

s${SYS}_input.m:
	mtt -q -stdin ${OPTS} -s s${SYS} input m

s${SYS}_ode2odes.m:
	mtt -q -stdin ${OPTS} -s s${SYS} ode2odes m

s${SYS}_ssim.m:
	mtt -q -stdin ${OPTS} -s s${SYS} ssim m

s${SYS}_def.m:
	mtt -q -stdin ${OPTS} -s s${SYS} def m



