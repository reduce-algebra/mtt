# -*-makefile-*-
# create a gnuplot input file

MTTFLAGS	= $(OPTS)

all: $(SYS)_gnuplot.$(LANG)

$(SYS)_gnuplot.view: $(SYS)_gnuplot.wish $(SYS)_odes.dat2
	sh $(SYS)_gnuplot.wish | gnuplot -geometry 400x300 2> .gnuplot.log &

$(SYS)_gnuplot.wish: $(SYS)_struc.txt
	$(MTTPATH)/trans/struc2gnuplot_txt2wish $(SYS)

$(SYS)_gnuplot.txt: $(SYS)_struc.txt $(MTTPATH)/trans/struc2gnuplot_txt.exe
	$(MTTPATH)/trans/struc2gnuplot_txt.exe $(SYS) < $(SYS)_struc.txt > $(SYS)_gnuplot.txt

$(SYS)_struc.txt:
	mtt $(MTTFLAGS) $(SYS) struc txt

$(MTTPATH)/trans/struc2gnuplot_txt.exe:
	make -f $(MTT_CC)/Makefile struc2gnuplot_txt.exe

$(SYS)_odes.dat2:
	mtt $(OPTS) $(SYS) odes dat2
