#! /usr/bin/make -f

all: $(MTT_SYS)_sfun.mexglx

$(MTT_SYS)_sfun.mexglx: $(MTT_SYS)_sfun.c sfun_debug.h useful-functions.hh $(MTT_SYS)_def.h $(MTT_SYS)_sympar.h $(MTT_SYS)_cr.h $(MTT_SYS)_numpar.c $(MTT_SYS)_ode.c $(MTT_SYS)_odeo.c $(MTT_SYS)_state.c $(MTT_SYS)_sfun_ae.mexglx $(MTT_SYS)_sfun_input.mexglx $(MTT_SYS)_sfun_interface.mexglx $(MTT_SYS).mdl
	echo Creating $@
	mex $(MTT_SYS)_sfun.c
	cp *_sfun*mexglx $(MTT_SYS).mdl ..

$(MTT_SYS)_sfun.c:: ${MTT_REP}/sfun_rep/sfun.c.tmpl
	echo Creating $@
	cat $^ | sed 's/<mtt_model_name>/$(MTT_SYS)/g' > $@

$(MTT_SYS)_sfun_ae.mexglx: $(MTT_SYS)_sfun_ae.c sfun_debug.h useful-functions.hh $(MTT_SYS)_def.h $(MTT_SYS)_sympar.h $(MTT_SYS)_cr.h $(MTT_SYS)_ae.c
	echo Creating $@
	mex $(MTT_SYS)_sfun_ae.c

$(MTT_SYS)_sfun_ae.c:: ${MTT_REP}/sfun_rep/mex_ae.c.tmpl
	echo Creating $@
	cat $^ | sed 's/<mtt_model_name>/$(MTT_SYS)/g' > $@

$(MTT_SYS)_sfun_input.mexglx: $(MTT_SYS)_sfun_input.c sfun_debug.h useful-functions.hh $(MTT_SYS)_def.h $(MTT_SYS)_sympar.h $(MTT_SYS)_cr.h $(MTT_SYS)_input.c $(MTT_SYS)_numpar.c
	echo Creating $@
	mex $(MTT_SYS)_sfun_input.c

$(MTT_SYS)_sfun_input.c:: ${MTT_REP}/sfun_rep/sfun_input.c.tmpl
	echo Creating $@
	cat $^ | sed 's/<mtt_model_name>/$(MTT_SYS)/g' > $@

$(MTT_SYS)_sfun_interface.mexglx: $(MTT_SYS)_sfun_interface.c sfun_debug.h useful-functions.hh $(MTT_SYS)_def.h $(MTT_SYS)_sympar.h $(MTT_SYS)_numpar.c
	echo Creating $@
	mex $(MTT_SYS)_sfun_interface.c

$(MTT_SYS)_sfun_interface.c: ${MTT_REP}/sfun_rep/sfun_interface.c.tmpl $(MTT_SYS)_struc.c
	echo Creating $@
	cat ${MTT_REP}/sfun_rep/sfun_interface.c.tmpl	|\
	 sed 's/<mtt_model_name>/$(MTT_SYS)/g'		|\
	 ${MTT_REP}/sfun_rep/insert_file.sh > $@

$(MTT_SYS)_sfun.zip: $(MTT_SYS)_sfun.c sfun_debug.h useful-functions.hh $(MTT_SYS)_sfun_ae.c $(MTT_SYS)_sfun_input.c $(MTT_SYS)_sfun_interface.c \
	 $(MTT_SYS)_def.h $(MTT_SYS)_sympar.h $(MTT_SYS)_cr.h\
	 $(MTT_SYS)_ae.c $(MTT_SYS)_input.c $(MTT_SYS)_numpar.c $(MTT_SYS)_ode.c $(MTT_SYS)_odeo.c $(MTT_SYS)_state.c \
	 $(MTT_SYS).mdl README
	echo Creating $@
	zip $@ $^

$(MTT_SYS).mdl: ${MTT_REP}/sfun_rep/mdl.tmpl
	echo Creating $@
	cat $^ | sed 's/<mtt_model_name>/$(MTT_SYS)/g' > $@

README:: ${MTT_REP}/sfun_rep/README.tmpl README.CVS
	echo Creating $@
	cat $^ | sed 's/<mtt_model_name>/$(MTT_SYS)/g' > $@
	rm -f README.CVS

README.CVS:
	echo Getting CVS status
	cvs status ../$(MTT_SYS)_abg.fig > $@ 2>1
	date >> $@

$(MTT_SYS)_ae.c: $(MTT_SYS)_ae.m
	echo Creating $@
	${MTT_CC}/mtt_m2cc.sh $(MTT_SYS) ae c cat 

$(MTT_SYS)_input.c: $(MTT_SYS)_input.m
	echo Creating $@
	${MTT_CC}/mtt_m2cc.sh $(MTT_SYS) input c cat 

$(MTT_SYS)_numpar.c: $(MTT_SYS)_numpar.m
	echo Creating $@
	${MTT_CC}/mtt_m2cc.sh $(MTT_SYS) numpar c cat

$(MTT_SYS)_ode.c: $(MTT_SYS)_ode.m
	echo Creating $@
	${MTT_CC}/mtt_m2cc.sh $(MTT_SYS) ode c cat

$(MTT_SYS)_odeo.c: $(MTT_SYS)_odeo.m
	echo Creating $@
	${MTT_CC}/mtt_m2cc.sh $(MTT_SYS) odeo c cat

$(MTT_SYS)_state.c: $(MTT_SYS)_state.m
	echo Creating $@
	${MTT_CC}/mtt_m2cc.sh $(MTT_SYS) state c cat

$(MTT_SYS)_struc.c: $(MTT_SYS)_struc.txt
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
	mtt -q $(MTT_OPTS) `echo $* | sed 's/\(.*\)_\(.*\)\.\(.*\)/\1 \2 \3/'`