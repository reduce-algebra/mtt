#! /usr/bin/make -f

SRC = $(SYS)_sfun.cc $(SYS)_def.h $(SYS)_ae.sfun $(SYS)_ode.sfun $(SYS)_odeo.sfun $(SYS)_state.sfun

all: $(SYS)_sfun.mexglx

$(SYS)_sfun.mexglx: $(SRC)
	mex $(SYS)_sfun.cc

$(SYS)_sfun.cc:: ${MTT_REP}/sfun_rep/sfun.cc.tmpl
	cat $^ | sed 's/<mtt_model_name>/$(SYS)/g' > $@

$(SYS)_sfun.zip: $(SRC)
	zip $@ $^

$(SYS)_ae.sfun: $(SYS)_ae.m
	${MTT_CC}/mtt_m2cc.sh $(SYS) ae sfun cat 

$(SYS)_ode.sfun: $(SYS)_ode.m
	${MTT_CC}/mtt_m2cc.sh $(SYS) ode sfun cat

$(SYS)_odeo.sfun: $(SYS)_odeo.m
	${MTT_CC}/mtt_m2cc.sh $(SYS) odeo sfun cat

$(SYS)_state.sfun: $(SYS)_state.m
	${MTT_CC}/mtt_m2cc.sh $(SYS) state sfun cat

%::
	mtt -q $(OPTS) `echo $* | sed 's/\(.*\)_\(.*\)\.\(.*\)/\1 \2 \3/'`