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


all: $(SYS)_cxxsim.$(LANG)

# view rule copied from gnuplot_rep.make
# need it here to prevent MTT using the default route (via dae)
$(SYS)_cxxsim.view: $(SYS)_gnuplot.wish $(SYS)_cxxsim.exe
	./$(SYS)_cxxsim.exe > $(SYS)_odes.dat2
	sh $(SYS)_gnuplot.wish			|\
		tee gnuplot_in.log		|\
		 gnuplot -geometry 400x300	\
		 > gnuplot_out.log 2> gnuplot_err.log &

$(SYS)_cxxsim.exe: $(SYS)_cxxsim.cc
	echo Creating $(SYS)_cxxsim.exe
	$(CC) -o $@ $^ $(OPTIMISE) $(WARNINGS) $(INCLUDE)

$(SYS)_cxxsim.cc: $(SYS)_cr.txt $(SYS)_ese.r $(SYS)_struc.txt $(SYS)_sympar.txt cxxsim
	./cxxsim $(SYS)
	cp $@ ..

cxxsim: ${MTT_LIB}/rep/cxxsim.cc
	echo creating $@
	echo Compiling $^
	$(CC) -o $@ $^ $(OPTIMISE) $(WARNINGS) $(INCLUDE)

# list of constitutive relationships
$(SYS)_cr.txt:
	mtt -q $(OPTS) $(SYS) cr txt

# elementary system equations
$(SYS)_ese.r:
	mtt -q $(OPTS) $(SYS) ese r

# system structure
$(SYS)_struc.txt:
	mtt -q $(OPTS) $(SYS) struc txt

# list of symbolic parameters
$(SYS)_sympar.txt:
	mtt -q $(OPTS) $(SYS) sympar txt

# gnuplot script
$(SYS)_gnuplot.wish:
	mtt -q $(OPTS) $(SYS) gnuplot wish