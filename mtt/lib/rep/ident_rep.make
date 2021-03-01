# -*-makefile-*-

#SUMMARY 	Identification
#DESCRIPTION 	Partially know system identification using
#DESCRIPTION    using bond graphs

# Makefile for representation ident
# File ident_rep.make

#Copyright (C) 2000,2001,2002 by Peter J. Gawthrop

## Model targets
model_reps =  ${MTT_SYS}_sympar.m ${MTT_SYS}_simpar.m ${MTT_SYS}_state.m 
model_reps += ${MTT_SYS}_numpar.m ${MTT_SYS}_input.m ${MTT_SYS}_ode2odes.m  
model_reps += ${MTT_SYS}_def.m 

## Prepend s to get the sensitivity targets
sensitivity_reps = ${model_reps:%=s%}

## Model prerequisites
model_pre =  ${MTT_SYS}_abg.fig ${MTT_SYS}_lbl.txt 
model_pre += ${MTT_SYS}_rdae.r ${MTT_SYS}_numpar.txt

## Prepend s to get the sensitivity targets
sensitivity_pre = ${model_pre:%=s%}


## Simulation targets
sims = ${MTT_SYS}_sim.m s${MTT_SYS}_ssim.m

## m-files needed for ident
ident_m = ${MTT_SYS}_ident.m ${MTT_SYS}_ident_numpar.m 

## The input data
ident_data = ${MTT_SYS}_ident_data.dat

## Targets for the ident simulation
ident_reps = ${ident_m} ${sims} ${model_reps} ${sensitivity_reps}

## ps output files etc
psfile = ${MTT_SYS}_ident.ps
psfiles = ${MTT_SYS}_ident.ps ${MTT_SYS}_ident.comparison.ps ${MTT_SYS}_ident_pars.ps
figfiles = ${psfiles:%.ps=%.fig}
gdatfiles = ${psfiles:%.ps=%.gdat}
datfiles = ${psfiles:%.ps=%.dat2}

## LaTeX files etc
latexfiles = ${MTT_SYS}_ident_par.tex

all: ${MTT_SYS}_ident.${MTT_LANG}

echo:
	echo "sims: ${sims}"
	echo "model_reps: ${model_reps}"
	echo "sensitivity_reps: ${sensitivity_reps}"
	echo "ident_reps: ${ident_reps}"

${MTT_SYS}_ident.view: ${psfiles}
	ident_rep.sh ${MTT_SYS} view

${psfiles}: ${figfiles}
	ident_rep.sh ${MTT_SYS} ps
	touch ${psfiles}

${figfiles}: ${gdatfiles}
	ident_rep.sh ${MTT_SYS} fig
	touch ${figfiles}

${gdatfiles}: ${datfiles}
	ident_rep.sh ${MTT_SYS} gdat
	touch ${gdatfiles}

${datfiles} ${latexfiles}: ${ident_reps} ${ident_data} 
	ident_rep.sh ${MTT_SYS} dat2
	touch ${datfiles}

${MTT_SYS}_ident.m: 
	ident_rep.sh ${MTT_SYS} m

${MTT_SYS}_ident_numpar.m:
	ident_rep.sh ${MTT_SYS} numpar.m

## System model reps
## Generic txt files 
${MTT_SYS}_%.txt:
	mtt ${MTT_OPTS} -q -stdin ${MTT_SYS} $* txt

## Specific m files
${MTT_SYS}_ode2odes.m: ${model_pre}
	mtt -q -stdin ${MTT_OPTS} ${MTT_SYS} ode2odes m

${MTT_SYS}_sim.m: ${MTT_SYS}_ode2odes.m
	mtt ${MTT_OPTS} -q -stdin ${MTT_SYS} sim m

## Numpar files
${MTT_SYS}_numpar.m:
	mtt ${MTT_SYS} numpar m

## Sympar files
${MTT_SYS}_sympar.m:
	mtt ${MTT_SYS} sympar m

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
	mtt ${MTT_OPTS} -q -stdin -s s${MTT_SYS} $* txt

## Specific m files
## Numpar files
s${MTT_SYS}_numpar.m:
	mtt -s s${MTT_SYS} numpar m

## Sympar files
s${MTT_SYS}_sympar.m:
	mtt -s s${MTT_SYS} sympar m

s${MTT_SYS}_ode2odes.m: ${sensitivity_pre}
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

