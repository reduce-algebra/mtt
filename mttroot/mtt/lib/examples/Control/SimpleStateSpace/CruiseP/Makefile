#
# TransFig makefile
#

all: CruiseP_pic.tex 

# translation into ps

CruiseP_pic.tex: CruiseP_pic.ps Makefile
	fig2ps2tex CruiseP_pic.ps >CruiseP_pic.tex
clean::
	rm -f CruiseP_pic.tex

CruiseP_pic.ps: CruiseP_pic.fig Makefile
	fig2dev -L ps CruiseP_pic.fig > CruiseP_pic.ps
clean::
	rm -f CruiseP_pic.ps

