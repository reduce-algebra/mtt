## Makes the schematic diagram and the zero figure
all: ReactorTF_pic.ps ReactorTF_zero_1.ps ReactorTF_zero_2.ps

ReactorTF_pic.ps: ReactorTF_pic.fig
	fig2dev -Lps ReactorTF_pic.fig> ReactorTF_pic.ps

ReactorTF_zero_1.ps: ReactorTF_abg.fig
	mtt -q ReactorTF sm m; mtt -q ReactorTF numpar m;
	mtt -q Reactor sympar m;
	octave MakeFigure.m

ReactorTF_zero_2.ps: ReactorTF_zero_1.ps
	touch ReactorTF_zero_2.ps

