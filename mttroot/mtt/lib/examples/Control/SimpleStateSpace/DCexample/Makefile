#
# TransFig makefile
#

all: DCexample_pic.tex 

# translation into ps

DCexample_pic.tex: DCexample_pic.ps Makefile
	fig2ps2tex DCexample_pic.ps >DCexample_pic.tex
clean::
	rm -f DCexample_pic.tex

DCexample_pic.ps: DCexample_pic.fig Makefile
	fig2dev -L ps DCexample_pic.fig > DCexample_pic.ps
clean::
	rm -f DCexample_pic.ps

