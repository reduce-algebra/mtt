#! /usr/bin/make -f

all: $(SYS)_sfun.mexglx

$(SYS)_sfun.mexglx: $(SYS)_sfun.c $(SYS)_def.h $(SYS)_sympar.h $(SYS)_numpar.c $(SYS)_ode.c $(SYS)_odeo.c $(SYS)_state.c $(SYS)_sfun_ae.mexglx 
	echo Creating $@
	mex $(SYS)_sfun.c
	cp *_sfun*mexglx ..

$(SYS)_sfun.c:: ${MTT_REP}/sfun_rep/sfun.c.tmpl
	echo Creating $@
	cat $^ | sed 's/<mtt_model_name>/$(SYS)/g' > $@

$(SYS)_sfun_ae.mexglx: $(SYS)_sfun_ae.c $(SYS)_def.h $(SYS)_ae.c
	echo Creating $@
	mex $(SYS)_sfun_ae.c

$(SYS)_sfun_ae.c:: ${MTT_REP}/sfun_rep/ae.c.tmpl
	echo Creating $@
	cat $^ | sed 's/<mtt_model_name>/$(SYS)/g' > $@

$(SYS)_sfun.zip: $(SYS)_sfun.c $(SYS)_sfun_ae.c $(SYS)_def.h $(SYS)_sympar.h $(SYS)_ae.c $(SYS)_numpar.c $(SYS)_ode.c $(SYS)_odeo.c $(SYS)_state.c README
	echo Creating $@
	zip $@ $^

README:: ${MTT_REP}/sfun_rep/README.tmpl
	echo Creating $@
	cat $^ | sed 's/<mtt_model_name>/$(SYS)/g' > $@

$(SYS)_ae.c: $(SYS)_ae.m
	echo Creating $@
	${MTT_CC}/mtt_m2cc.sh $(SYS) ae c cat 

$(SYS)_numpar.c: $(SYS)_numpar.m
	echo Creating $@
	${MTT_CC}/mtt_m2cc.sh $(SYS) numpar c cat

$(SYS)_ode.c: $(SYS)_ode.m
	echo Creating $@
	${MTT_CC}/mtt_m2cc.sh $(SYS) ode c cat

$(SYS)_odeo.c: $(SYS)_odeo.m
	echo Creating $@
	${MTT_CC}/mtt_m2cc.sh $(SYS) odeo c cat

$(SYS)_state.c: $(SYS)_state.m
	echo Creating $@
	${MTT_CC}/mtt_m2cc.sh $(SYS) state c cat

%::
	mtt -q $(OPTS) `echo $* | sed 's/\(.*\)_\(.*\)\.\(.*\)/\1 \2 \3/'`