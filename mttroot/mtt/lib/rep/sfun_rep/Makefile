#! /usr/bin/make -f

$(SYS)_sfun.mexglx: $(SYS)_sfun.cc $(SYS)_def.h $(SYS)_state.mexglx $(SYS)_ode.mexglx $(SYS)_odeo.mexglx
	cp -a $(SYS)_ode.mexglx ..
	cp -a $(SYS)_odeo.mexglx ..
	cp -a $(SYS)_state.mexglx ..
	mex $(SYS)_sfun.cc

$(SYS)_sfun.cc:: ${MTT_REP}/sfun_rep/sfun.cc.tmpl
	cat $^ | sed 's/<mtt_model_name>/$(SYS)/g' > $@

%::
	mtt -q $(OPTS) `echo $* | sed 's/\(.*\)_\(.*\)\.\(.*\)/\1 \2 \3/'`