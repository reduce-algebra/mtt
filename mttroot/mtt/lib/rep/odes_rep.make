# -*-makefile-*-

all: ${MTT_SYS}_odes.${MTT_LANG}

${MTT_SYS}_odes.gnuplot:
	@mtt -q ${MTT_OPT} ${MTT_SYS} gnuplot view

ifneq ("${MTT_LANG}","gnuplot")
${MTT_SYS}_odes.${MTT_LANG}:
	@touch odes_rep.make.ignore
	@mtt -q ${MTT_OPT} ${MTT_SYS} odes ${MTT_LANG}
	@rm odes_rep.make.ignore
endif
