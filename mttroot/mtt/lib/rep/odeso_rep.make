# -*-makefile-*-

all: ${MTT_SYS}_odeso.${MTT_LANG}

${MTT_SYS}_odeso.gnuplot:
	@mtt -q ${MTT_OPT} ${MTT_SYS} gnuplot view

ifneq ("${MTT_LANG}","gnuplot")
${MTT_SYS}_odeso.${MTT_LANG}:
	@touch odeso_rep.make.ignore
	@mtt -q ${MTT_OPT} ${MTT_SYS} odeso ${MTT_LANG}
	@rm odeso_rep.make.ignore
endif
