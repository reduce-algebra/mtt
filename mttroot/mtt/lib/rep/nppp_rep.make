# -*-makefile-*-
# Makefile for representation nppp
# File nppp_rep.make

#Copyright (C) 2000,2001,2002 by Peter J. Gawthrop

## Model targets
model_reps =  ${SYS}_sympar.m ${SYS}_simpar.m ${SYS}_state.m 
model_reps += ${SYS}_numpar.m ${SYS}_input.m ${SYS}_ode2odes.m  
model_reps += ${SYS}_def.m

## Prepend s to get the sensitivity targets
sensitivity_reps = ${model_reps:%=s%}

## Simulation targets
sims = ${SYS}_sim.m s${SYS}_ssim.m

## m-files needed for nppp
nppp_m = ${SYS}_nppp.m ${SYS}_nppp_numpar.m 

## Targets for the nppp simulation
nppp_reps = ${nppp_m} ${sims} ${model_reps} ${sensitivity_reps}

## ps output files
psfiles = ${SYS}_nppp.ps ${SYS}_nppp.basis.ps ${SYS}_nppp.par.ps ${SYS}_nppp.U.ps
figfiles = ${psfiles:%.ps=%.fig}

all: ${SYS}_nppp.${LANG}

echo:
	echo "sims: ${sims}"
	echo "model_reps: ${model_reps}"
	echo "sensitivity_reps: ${sensitivity_reps}"
	echo "nppp_reps: ${nppp_reps}"

${SYS}_nppp.view: ${SYS}_nppp.ps
	nppp_rep.sh ${SYS} view

${psfiles}: ${SYS}_nppp.fig
	nppp_rep.sh ${SYS} ps

${SYS}_nppp.gdat: ${SYS}_nppp.dat2
	nppp_rep.sh ${SYS} gdat

${SYS}_nppp.fig ${SYS}_nppp.dat2: ${nppp_reps}
	nppp_rep.sh ${SYS} dat2

${SYS}_nppp.m: 
	nppp_rep.sh ${SYS} m

${SYS}_nppp_numpar.m:
	nppp_rep.sh ${SYS} numpar.m

## System model reps
## Generic txt files 
${SYS}_%.txt:
	mtt ${OPTS} -q -stdin ${SYS} $* txt

## Specific m files
${SYS}_ode2odes.m: ${SYS}_rdae.r
	mtt -q -stdin ${OPTS} ${SYS} ode2odes m

${SYS}_sim.m: ${SYS}_ode2odes.m
	mtt ${OPTS} -q -stdin ${SYS} sim m

## Generic txt to m
${SYS}_%.m: ${SYS}_%.txt
	mtt ${OPTS} -q -stdin ${SYS} $* m

## r files
${SYS}_def.r: ${SYS}_abg.fig
	mtt ${OPTS} -q -stdin ${SYS} def r

${SYS}_rdae.r: 
	mtt ${OPTS} -q -stdin ${SYS} rdae r

## Sensitivity model reps
## Generic txt files 
s${SYS}_%.txt:
	mtt ${OPTS} -q -stdin s${SYS} $* txt

## Specific m files
s${SYS}_ode2odes.m: s${SYS}_rdae.r
	mtt -q -stdin ${OPTS} -s s${SYS} ode2odes m

s${SYS}_ssim.m:
	mtt -q -stdin ${OPTS} -s s${SYS} ssim m

s${SYS}_def.m:
	mtt -q -stdin ${OPTS} -s s${SYS} def m


## Generic txt to m
s${SYS}_%.m: s${SYS}_%.txt
	mtt ${OPTS} -q -stdin s${SYS} $* m


## r files
s${SYS}_rdae.r: 
	mtt ${OPTS} -q -stdin -s s${SYS} rdae r


