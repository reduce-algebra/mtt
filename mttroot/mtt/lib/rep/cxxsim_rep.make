# -*-makefile-*-

# usage: mtt <sys> cxxsim view

# example:
# mtt copy MotorGenerator && cd MotorGenerator && mtt MotorGenerator cxxsim view

# cxxsim creates a very simple C++ simulation without using Reduce
# it doesn't use MTT's normal .txt files so the resultant .cc must be edited 
# manually to alter parameter, input and logic values

# a more intelligent version would just do ese_r2cc to create <sys>_ese.cc
# this could then be embedded into MTT's normal code like <sys>_ode.cc
# maybe another day ...

CC=g++

INCLUDE=-I. -I${MTT_LIB}/cr/hh
OPTIMISE=-O0
WARNINGS=-Wall -ansi -pedantic


all: $(MTT_SYS)_cxxsim.$(MTT_LANG)

# view rule copied from gnuplot_rep.make
# need it here to prevent MTT using the default route (via dae)
$(MTT_SYS)_cxxsim.view: $(MTT_SYS)_gnuplot.wish $(MTT_SYS)_cxxsim.exe
	./$(MTT_SYS)_cxxsim.exe > $(MTT_SYS)_odes.dat2
	sh $(MTT_SYS)_gnuplot.wish		|\
		tee gnuplot_in.log		|\
		 gnuplot -geometry 400x300	\
		 > gnuplot_out.log 2> gnuplot_err.log &

$(MTT_SYS)_cxxsim.exe: $(MTT_SYS)_cxxsim.cc
	echo Creating $(MTT_SYS)_cxxsim.exe
	$(CC) -o $@ $^ $(OPTIMISE) $(WARNINGS) $(INCLUDE)

$(MTT_SYS)_cxxsim.cc: $(MTT_SYS)_cr.txt $(MTT_SYS)_ese.r $(MTT_SYS)_struc.txt $(MTT_SYS)_sympar.txt cxxsim
	./cxxsim $(MTT_SYS)
	cp $@ ..

cxxsim: ${MTT_LIB}/rep/cxxsim.cc
	echo creating $@
	echo Compiling $^
	$(CC) -o $@ $^ $(OPTIMISE) $(WARNINGS) $(INCLUDE)

# list of constitutive relationships
$(MTT_SYS)_cr.txt:
	mtt -q $(MTT_OPTS) $(MTT_SYS) cr txt

# elementary system equations
$(MTT_SYS)_ese.r:
	mtt -q $(MTT_OPTS) $(MTT_SYS) ese r

# system structure
$(MTT_SYS)_struc.txt:
	mtt -q $(MTT_OPTS) $(MTT_SYS) struc txt

# list of symbolic parameters
$(MTT_SYS)_sympar.txt:
	mtt -q $(MTT_OPTS) $(MTT_SYS) sympar txt

# gnuplot script
$(MTT_SYS)_gnuplot.wish:
	mtt -q $(MTT_OPTS) $(MTT_SYS) gnuplot wish