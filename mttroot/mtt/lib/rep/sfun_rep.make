# -*-makefile-*-

REP ?= "sfun"

all:
	${MTT_REP}/sfun_rep.sh "$(OPTS)" "$(SYS)" "$(REP)" "$(LANG)"