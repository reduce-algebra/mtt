
CXX ?= g++

build: parse_m2cc.exe

.PHONY: FORCE
clean: FORCE
	@-rm -f parse_m2cc.exe

parse_m2cc.exe: parse_m2cc.cc
	@$(CXX) $< $(CFLAGS) -o $@ -I./include
	@strip $@
