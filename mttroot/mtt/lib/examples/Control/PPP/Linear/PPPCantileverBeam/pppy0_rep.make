## Make file for the ppp output rep
## Symlinked to:
##	pppy
##	pppy0
##	pppu

all: $(SYS)_pppy.ps $(SYS)_pppy0.ps $(SYS)_pppu.ps

$(SYS)_pppy.ps: Make_figures.m ppp_1.m $(SYS)_sm.m $(SYS)_numpar.m
	octave Make_figures.m
$(SYS)_pppy0.ps: $(SYS)_pppy.ps
	touch $(SYS)_pppy0.ps
$(SYS)_pppu.ps: $(SYS)_pppy.ps
	touch $(SYS)_pppu.ps

$(SYS)_sm.m: 
	mtt $(SYS) sm m

$(SYS)_numpar.m: 
	mtt $(SYS) numpar m
