# -*-makefile-*-
# create a gnuplot input file

MTTFLAGS	= $(MTT_OPTS)

all: $(MTT_SYS)_gnuplot.$(MTT_LANG)

$(MTT_SYS)_gnuplot.view: $(MTT_SYS)_gnuplot.wish
	mtt $(MTT_OPTS) $(MTT_SYS) odes dat2
	sh $(MTT_SYS)_gnuplot.wish				|\
		tee gnuplot_in.log				|\
		 gnuplot -name $(MTT_SYS) -geometry 400x300	\
		 > gnuplot_out.log 2> gnuplot_err.log &

$(MTT_SYS)_gnuplot.wish: $(MTT_SYS)_struc.txt
	$(MTTPATH)/trans/struc2gnuplot_txt2wish $(MTT_SYS)

$(MTT_SYS)_struc.txt:
	mtt $(MTTFLAGS) $(MTT_SYS) struc txt


