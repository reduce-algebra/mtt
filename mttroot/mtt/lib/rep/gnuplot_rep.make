# -*-makefile-*-
# create a gnuplot input file

MTTFLAGS	= $(OPTS)

all: $(SYS)_gnuplot.$(LANG)

$(SYS)_gnuplot.view: $(SYS)_gnuplot.txt $(SYS)_odes.dat2
	gnuplot $(SYS)_gnuplot.txt

$(SYS)_gnuplot.txt: $(SYS)_struc.txt $(MTTPATH)/trans/struc2gnuplot_txt.exe
	$(MTTPATH)/trans/struc2gnuplot_txt.exe $(SYS) < $(SYS)_struc.txt > $(SYS)_gnuplot.txt

$(SYS)_struc.txt:
	mtt $(MTTFLAGS) $(SYS) struc txt

$(MTTPATH)/trans/struc2gnuplot_txt.exe:
	make -f $(MTT_CC)/Makefile struc2gnuplot_txt.exe

$(SYS)_odes.dat2:
	mtt $(OPTS) $(SYS) odes dat2
