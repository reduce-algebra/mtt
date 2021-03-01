## Makes the schematic diagram and the (trasmission) zero figure
all: Reactor_pic.ps Reactor_zero_b.ps

Reactor_pic.ps: Reactor_pic.fig
	fig2dev -Lps Reactor_pic.fig> Reactor_pic.ps

Reactor_zero_b.ps: Reactor_abg.fig
	mtt -q Reactor sm m
	mtt -q Reactor numpar m;
	mtt -q Reactor sympar m;
	octave MakeFigure.m


