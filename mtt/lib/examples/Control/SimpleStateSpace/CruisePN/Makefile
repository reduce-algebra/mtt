#
# TransFig makefile
#

all: CruisePN_pic.tex 

# translation into ps

CruisePN_pic.tex: CruisePN_pic.ps Makefile
	fig2ps2tex CruisePN_pic.ps >CruisePN_pic.tex
clean::
	rm -f CruisePN_pic.tex

CruisePN_pic.ps: CruisePN_pic.fig Makefile
	fig2dev -L ps CruisePN_pic.fig > CruisePN_pic.ps
clean::
	rm -f CruisePN_pic.ps

