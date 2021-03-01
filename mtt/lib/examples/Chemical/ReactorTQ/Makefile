## Makes the schematic diagram and the zero figure
all: ReactorTQ_pic.ps ReactorTQ_zero.ps

ReactorTQ_pic.ps: ReactorTQ_pic.fig
	fig2dev -Lps ReactorTQ_pic.fig> ReactorTQ_pic.ps

ReactorTQ_zero.ps: ReactorTQ_abg.fig
	mtt -q ReactorTQ sm m; mtt -q ReactorTQ numpar m;
	mtt -q ReactorTQ sympar m;
	octave MakeFigure.m

