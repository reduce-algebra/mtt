#! /usr/bin/make -f

all: $(SYS)_sfun.mexglx

$(SYS)_sfun.mexglx: $(SYS)_sfun.c sfun_debug.h useful-functions.hh $(SYS)_def.h $(SYS)_sympar.h $(SYS)_numpar.c $(SYS)_ode.c $(SYS)_odeo.c $(SYS)_state.c $(SYS)_sfun_ae.mexglx $(SYS)_sfun_input.mexglx $(SYS)_sfun_interface.mexglx $(SYS).mdl
	echo Creating $@
	mex $(SYS)_sfun.c
	cp *_sfun*mexglx $(SYS).mdl ..

$(SYS)_sfun.c:: ${MTT_REP}/sfun_rep/sfun.c.tmpl
	echo Creating $@
	cat $^ | sed 's/<mtt_model_name>/$(SYS)/g' > $@

$(SYS)_sfun_ae.mexglx: $(SYS)_sfun_ae.c sfun-debug.h useful-functions.hh $(SYS)_def.h $(SYS)_sympar.h $(SYS)_ae.c
	echo Creating $@
	mex $(SYS)_sfun_ae.c

$(SYS)_sfun_ae.c:: ${MTT_REP}/sfun_rep/mex_ae.c.tmpl
	echo Creating $@
	cat $^ | sed 's/<mtt_model_name>/$(SYS)/g' > $@

$(SYS)_sfun_input.mexglx: $(SYS)_sfun_input.c sfun_debug.h useful-functions.hh $(SYS)_def.h $(SYS)_sympar.h $(SYS)_input.c $(SYS)_numpar.c
	echo Creating $@
	mex $(SYS)_sfun_input.c

$(SYS)_sfun_input.c:: ${MTT_REP}/sfun_rep/sfun_input.c.tmpl
	echo Creating $@
	cat $^ | sed 's/<mtt_model_name>/$(SYS)/g' > $@

$(SYS)_sfun_interface.mexglx: $(SYS)_sfun_interface.c sfun_debug.h useful-functions.hh $(SYS)_def.h $(SYS)_sympar.h $(SYS)_numpar.c
	echo Creating $@
	mex $(SYS)_sfun_interface.c

$(SYS)_sfun_interface.c: ${MTT_REP}/sfun_rep/sfun_interface.c.tmpl $(SYS)_struc.c
	echo Creating $@
	cat ${MTT_REP}/sfun_rep/sfun_interface.c.tmpl	|\
	 sed 's/<mtt_model_name>/$(SYS)/g'		|\
	 ${MTT_REP}/sfun_rep/insert_file.sh > $@

$(SYS)_sfun.zip: $(SYS)_sfun.c sfun_debug.h useful-functions.hh $(SYS)_sfun_ae.c $(SYS)_sfun_input.c $(SYS)_sfun_interface.c \
	 $(SYS)_def.h $(SYS)_sympar.h \
	 $(SYS)_ae.c $(SYS)_input.c $(SYS)_numpar.c $(SYS)_ode.c $(SYS)_odeo.c $(SYS)_state.c \
	 $(SYS).mdl README
	echo Creating $@
	zip $@ $^

$(SYS).mdl: ${MTT_REP}/sfun_rep/mdl.tmpl
	echo Creating $@
	cat $^ | sed 's/<mtt_model_name>/$(SYS)/g' > $@

README:: ${MTT_REP}/sfun_rep/README.tmpl
	echo Creating $@
	cat $^ | sed 's/<mtt_model_name>/$(SYS)/g' > $@

$(SYS)_ae.c: $(SYS)_ae.m
	echo Creating $@
	${MTT_CC}/mtt_m2cc.sh $(SYS) ae c cat 

$(SYS)_input.c: $(SYS)_input.m
	echo Creating $@
	${MTT_CC}/mtt_m2cc.sh $(SYS) input c cat 

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

$(SYS)_struc.c: $(SYS)_struc.txt
	echo Creating $@
	gawk '\
($$1 == "input")  { printf "         double *%s\t= &(mttu[%d]);\t/* input and output */\n", $$4, $$2-1 }\
($$1 == "state")  { printf "   const double *_%s\t= &(mttx[%d]);\t/* input */\n", $$4, $$2-1 }\
($$1 == "output") { printf "   const double *_%s\t= &(mtty[%d]);\t/* input */\n", $$4, $$2-1 }\
($$1 != "input" && $$1 != "state" && $$1 != "output") { }\
	' $^ > $@

sfun_debug.h:: ${MTT_REP}/sfun_rep/sfun_debug.h
	echo Copying $@
	cp $^ $@

useful-functions.hh:: ${MTT_CC}/include/useful-functions.hh
	echo Copying $@
	cp $^ $@

%::
	mtt -q $(OPTS) `echo $* | sed 's/\(.*\)_\(.*\)\.\(.*\)/\1 \2 \3/'`