# -*-makefile-*-

#SUMMARY 	Identification
#DESCRIPTION 	Partially know system identification using
#DESCRIPTION    using bond graphs

# Makefile for representation ident
# File ident_rep.make

#Copyright (C) 2000,2001,2002 by Peter J. Gawthrop

## Model targets
model_reps =  ${SYS}_sympar.m ${SYS}_simpar.m ${SYS}_state.m 
model_reps += ${SYS}_numpar.m ${SYS}_input.m ${SYS}_ode2odes.m  
model_reps += ${SYS}_def.m 

## Prepend s to get the sensitivity targets
sensitivity_reps = ${model_reps:%=s%}

## Model prerequisites
model_pre =  ${SYS}_abg.fig ${SYS}_lbl.txt 
model_pre += ${SYS}_rdae.r ${SYS}_numpar.txt

## Prepend s to get the sensitivity targets
sensitivity_pre = ${model_pre:%=s%}


## Simulation targets
sims = ${SYS}_sim.m s${SYS}_ssim.m

## m-files needed for ident
ident_m = ${SYS}_ident.m ${SYS}_ident_numpar.m 

## Targets for the ident simulation
ident_reps = ${ident_m} ${sims} ${model_reps} ${sensitivity_reps}

## ps output files etc
psfiles = ${SYS}_ident.ps ${SYS}_ident.comparison.ps
figfiles = ${psfiles:%.ps=%.fig}
gdatfiles = ${psfiles:%.ps=%.gdat}
datfiles = ${psfiles:%.ps=%.dat2}

## LaTeX files etc
latexfiles = ${SYS}_ident_par.tex

all: ${SYS}_ident.${LANG}

echo:
	echo "sims: ${sims}"
	echo "model_reps: ${model_reps}"
	echo "sensitivity_reps: ${sensitivity_reps}"
	echo "ident_reps: ${ident_reps}"

${SYS}_ident.view: ${psfiles}
	ident_rep.sh ${SYS} view

${psfiles}: ${figfiles}
	ident_rep.sh ${SYS} ps

${figfiles}: ${gdatfiles}
	ident_rep.sh ${SYS} fig

${gdatfiles}: ${datfiles}
	ident_rep.sh ${SYS} gdat

${datfiles} ${latexfiles}: ${ident_reps}
	ident_rep.sh ${SYS} dat2

${SYS}_ident.m: 
	ident_rep.sh ${SYS} m

${SYS}_ident_numpar.m:
	ident_rep.sh ${SYS} numpar.m

## System model reps
## Generic txt files 
${SYS}_%.txt:
	mtt ${OPTS} -q -stdin ${SYS} $* txt

## Specific m files
${SYS}_ode2odes.m: ${model_pre}
	mtt -q -stdin ${OPTS} ${SYS} ode2odes m

${SYS}_sim.m: ${SYS}_ode2odes.m
	mtt ${OPTS} -q -stdin ${SYS} sim m

## Numpar files
${SYS}_numpar.m:
	mtt ${SYS} numpar m

## Sympar files
${SYS}_sympar.m:
	mtt ${SYS} sympar m

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
	mtt ${OPTS} -q -stdin -s s${SYS} $* txt

## Specific m files
## Numpar files
s${SYS}_numpar.m:
	mtt -s s${SYS} numpar m

## Sympar files
s${SYS}_sympar.m:
	mtt -s s${SYS} sympar m

s${SYS}_ode2odes.m: ${sensitivity_pre}
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

