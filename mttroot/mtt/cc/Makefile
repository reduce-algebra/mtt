
.POSIX:

CC=g++

ifeq (0,1)
CFLAGS+=-static
OCTAVE_LIBS_PATH=-L/usr/local/lib/octave
OCTAVE_LIBRARIES=-loctave -lcruft -lm -lncurses -ldl -lstdc++ -lc -lkpathsea -lreadline -lf2c

%.exe: %.cc
	$(CC) $< $(CFLAGS) $(OCTAVE_LIBS_PATH) $(OCTAVE_LIBRARIES) -o $@

%.oct: %.cc
	mkoctfile $<
endif



all:	$(sys)_$(rep).cc

parser.exe: parse_m2cc.cc
	g++ $< $(CFLAGS) -o ${MTTPATH}/trans/parser.exe -I${MTTPATH}/../cc/include

ifeq ($(rep),ode2odes)
$(sys)_ode2odes.cc: ode2odes.cc
	cat ode2odes.cc | sed 's/\$$/$(sys)/' > $(sys)_ode2odes.cc
else
$(sys)_$(rep).cc: $(sys)_def.h $(sys)_sympar.h $(sys)_def.r $(sys)_$(rep).m
	mtt_m2cc.sh ${sys} ${rep} parser
endif

$(sys)_def.h: $(sys)_def.m $(sys)_sympar.txt
	def_m2h.sh $(sys)

$(sys)_sympar.h: $(sys)_sympar.txt
	sympar_txt2h.sh $(sys)

$(sys)_def.m:
	mtt $(sys) def m

# getsize needs def.r
$(sys)_def.r:
	mtt $(sys) def r

$(sys)_sympar.txt:
	mtt $(sys) sympar txt


# struc2gnuplot_txt.exe is used by gnuplot_rep.make to create gnuplot input file.
struc2gnuplot_txt.exe: $(MTT_CC)/struc2gnuplot_txt.cc
	$(CC) -O3 -Wall -ansi -pedantic -DMAIN $(MTT_CC)/struc2gnuplot_txt.cc -o $(MTTPATH)/trans/struc2gnuplot_txt.exe 
