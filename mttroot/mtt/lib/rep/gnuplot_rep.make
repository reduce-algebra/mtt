# -*-makefile-*-
# create a gnuplot input file

MTTFLAGS	= $(OPTS)

all: $(SYS)_gnuplot.$(LANG)

$(SYS)_gnuplot.view: $(SYS)_gnuplot.wish
	mtt $(OPTS) $(SYS) odes dat2
	sh $(SYS)_gnuplot.wish			|\
		tee gnuplot_in.log		|\
		 gnuplot -geometry 400x300	\
		 > gnuplot_out.log 2> gnuplot_err.log &

$(SYS)_gnuplot.wish: $(SYS)_struc.txt
	$(MTTPATH)/trans/struc2gnuplot_txt2wish $(SYS)

$(SYS)_struc.txt:
	mtt $(MTTFLAGS) $(SYS) struc txt


