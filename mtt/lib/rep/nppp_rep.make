# -*-makefile-*-

#SUMMARY 	Nonlinear pole-placement predictive control (nPPP)
#DESCRIPTION 	

# Makefile for representation nppp
# File nppp_rep.make

#Copyright (C) 2000,2001,2002 by Peter J. Gawthrop

## Model targets
model_reps =  ${MTT_SYS}_sympar.m ${MTT_SYS}_simpar.m ${MTT_SYS}_state.m 
model_reps += ${MTT_SYS}_numpar.m ${MTT_SYS}_input.m ${MTT_SYS}_ode2odes.m  
model_reps += ${MTT_SYS}_def.m

## Prepend s to get the sensitivity targets
sensitivity_reps = ${model_reps:%=s%}

## Simulation targets
sims = ${MTT_SYS}_sim.m s${MTT_SYS}_ssim.m

## m-files needed for nppp
nppp_m = ${MTT_SYS}_nppp.m ${MTT_SYS}_nppp_numpar.m 

## Targets for the nppp simulation
nppp_reps = ${nppp_m} ${sims} ${model_reps} ${sensitivity_reps}

## ps output files
psfiles = ${MTT_SYS}_nppp.ps ${MTT_SYS}_nppp.basis.ps ${MTT_SYS}_nppp.par.ps ${MTT_SYS}_nppp.U.ps
figfiles = ${psfiles:%.ps=%.fig}

all: ${MTT_SYS}_nppp.${MTT_LANG}

echo:
	echo "sims: ${sims}"
	echo "model_reps: ${model_reps}"
	echo "sensitivity_reps: ${sensitivity_reps}"
	echo "nppp_reps: ${nppp_reps}"

${MTT_SYS}_nppp.view: ${MTT_SYS}_nppp.ps
	nppp_rep.sh ${MTT_SYS} view

${psfiles}: ${MTT_SYS}_nppp.fig
	nppp_rep.sh ${MTT_SYS} ps

${MTT_SYS}_nppp.gdat: ${MTT_SYS}_nppp.dat2
	nppp_rep.sh ${MTT_SYS} gdat

${MTT_SYS}_nppp.fig ${MTT_SYS}_nppp.dat2: ${nppp_reps}
	nppp_rep.sh ${MTT_SYS} dat2

${MTT_SYS}_nppp.m: 
	nppp_rep.sh ${MTT_SYS} m

${MTT_SYS}_nppp_numpar.m:
	nppp_rep.sh ${MTT_SYS} numpar.m

## System model reps
## Generic txt files 
${MTT_SYS}_%.txt:
	mtt ${MTT_OPTS} -q -stdin ${MTT_SYS} $* txt

## Specific m files
${MTT_SYS}_ode2odes.m: ${MTT_SYS}_rdae.r
	mtt -q -stdin ${MTT_OPTS} ${MTT_SYS} ode2odes m

${MTT_SYS}_sim.m: ${MTT_SYS}_ode2odes.m
	mtt ${MTT_OPTS} -q -stdin ${MTT_SYS} sim m

## Generic txt to m
${MTT_SYS}_%.m: ${MTT_SYS}_%.txt
	mtt ${MTT_OPTS} -q -stdin ${MTT_SYS} $* m

## r files
${MTT_SYS}_def.r: ${MTT_SYS}_abg.fig
	mtt ${MTT_OPTS} -q -stdin ${MTT_SYS} def r

${MTT_SYS}_rdae.r: 
	mtt ${MTT_OPTS} -q -stdin ${MTT_SYS} rdae r

## Sensitivity model reps
## Generic txt files 
s${MTT_SYS}_%.txt:
	mtt ${MTT_OPTS} -q -stdin s${MTT_SYS} $* txt

## Specific m files
s${MTT_SYS}_ode2odes.m: s${MTT_SYS}_rdae.r
	mtt -q -stdin ${MTT_OPTS} -s s${MTT_SYS} ode2odes m

s${MTT_SYS}_ssim.m:
	mtt -q -stdin ${MTT_OPTS} -s s${MTT_SYS} ssim m

s${MTT_SYS}_def.m:
	mtt -q -stdin ${MTT_OPTS} -s s${MTT_SYS} def m


## Generic txt to m
s${MTT_SYS}_%.m: s${MTT_SYS}_%.txt
	mtt ${MTT_OPTS} -q -stdin s${MTT_SYS} $* m


## r files
s${MTT_SYS}_rdae.r: 
	mtt ${MTT_OPTS} -q -stdin -s s${MTT_SYS} rdae r


