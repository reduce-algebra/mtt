#
# TransFig makefile
#

all: TwoTanks_pic.tex 

# translation into ps

TwoTanks_pic.tex: TwoTanks_pic.ps Makefile
	fig2ps2tex TwoTanks_pic.ps >TwoTanks_pic.tex
clean::
	rm -f TwoTanks_pic.tex

TwoTanks_pic.ps: TwoTanks_pic.fig Makefile
	fig2dev -L ps TwoTanks_pic.fig > TwoTanks_pic.ps
clean::
	rm -f TwoTanks_pic.ps

