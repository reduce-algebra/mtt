# -*-makefile-*-
# $Id$
# $Log$
# Revision 1.1  2000/08/31 14:31:28  peterg
# Initial revision
#
# Revision 1.3  2000/08/31 02:56:18  geraint
# Keep mkdir quiet if $(SYS)_Simulation_Dir exists
#
# Revision 1.2  2000/08/30 04:34:55  geraint
# *** empty log message ***
#

BIN=$(MTTPATH)/trans
INC=$(MTTPATH)/lib/cr/hh
SRC=$(MTTPATH)/trans/cc

CC=g++

INCLUDE=-I$(MTTPATH)/lib/cr/hh
OPTIMISE=-O3
WARNINGS=-Wall -ansi -pedantic

DIR=$(SYS)_Simulation_Dir
EXE=$(SYS)_sim.exe
OBJ=$(SYS)_input.o $(SYS)_numpar.o $(SYS)_ode.o $(SYS)_init.o $(SYS)_sim.o $(SYS)_switch.o

MTTFLAGS=-c -i euler -o -q

all: $(EXE)

$(SYS)_sim.exe: $(OBJ) 
	echo Creating $(SYS)_sim.exe
	$(CC) $(WARNINGS) $(OPTIMISE) $(INCLUDE) $(CFLAGS) $(OBJ) -o $(SYS)_sim.exe
	mkdir -p ../$(DIR)
	cp *.cc ../$(DIR)
	cp *.hh ../$(DIR)
	cp *.o ../$(DIR)
	cp $(EXE) ../$(DIR)

$(SYS)_sim.o: $(SYS)_sim.cc $(SYS)_struc.hh
	echo Creating $(SYS)_sim.o
	$(CC) $(WARNINGS) $(OPTIMISE) $(INCLUDE) $(CFLAGS) -c $(SYS)_sim.cc

$(SYS)_sim.cc: sim.txt
	echo Creating $(SYS)_sim.cc
	$(BIN)/sim_txt2cc $(SYS) sim < sim.txt > $(SYS)_sim.cc

sim.txt:
	echo Creating sim.txt:
	cp $(MTTPATH)/trans/cc/src/sim.txt .

# list of constitutive relationships
$(SYS)_cr.hh: $(SYS)_cr.txt
	echo Creating $(SYS)_cr.hh
	$(BIN)/cr_txt2hh $(SYS) < $(SYS)_cr.txt > $(SYS)_cr.hh

$(SYS)_cr.txt:
	mtt $(MTTFLAGS) $(SYS) cr txt

# elementary system equations, Reduce format
$(SYS)_ese.r:
	echo Creating $(SYS)_ese.r
	mtt --version
	mtt $(MTTFLAGS) $(SYS) ese r

# state initialisation (MTT already has state.cc)
$(SYS)_init.o: $(SYS)_init.cc
	echo Creating $(SYS)_init.o
	$(CC) $(WARNINGS) $(OPTIMISE) $(INCLUDE) $(CFLAGS) -c $(SYS)_init.cc

$(SYS)_init.cc: $(SYS)_struc.txt
	echo Creating $(SYS)_init.cc
	$(BIN)/struc2state_txt2cc $(SYS) < $(SYS)_struc.txt > $(SYS)_init.cc

# system inputs
$(SYS)_input.o: $(SYS)_input.cc $(SYS)_cr.hh $(SYS)_numpar.hh
	echo Creating $(SYS)_input.o
	$(CC) $(WARNINGS) $(OPTIMISE) $(INCLUDE) $(CFLAGS) -c $(SYS)_input.cc

$(SYS)_input.cc: $(SYS)_struc.txt
	echo Creating $(SYS)_input.cc
	$(BIN)/struc2input_txt2cc $(SYS) < $(SYS)_struc.txt > $(SYS)_input.cc

# system numerical parameters
$(SYS)_numpar.o: $(SYS)_numpar.cc
	echo Creating $(SYS)_numpar.o
	$(CC) $(WARNINGS) $(OPTIMISE) $(INCLUDE) $(CFLAGS) -c $(SYS)_numpar.cc

$(SYS)_numpar.cc: $(SYS)_sympar.txt
	echo Creating $(SYS)_numpar.cc
	$(BIN)/sympar2numpar_txt2cc $(SYS) < $(SYS)_sympar.txt > $(SYS)_numpar.cc

$(SYS)_numpar.hh: $(SYS)_sympar.txt
	echo Creating $(SYS)_numpar.hh
	$(BIN)/sympar2numpar_txt2hh $(SYS) < $(SYS)_sympar.txt > $(SYS)_numpar.hh

$(SYS)_numpar.txt:
	echo Creating $(SYS)_numpar.txt
	mtt $(MTTFLAGS) $(SYS) numpar txt

# ordinary differential equations
$(SYS)_ode.o: $(SYS)_ode.cc $(SYS)_cr.hh $(SYS)_numpar.hh
	echo Creating $(SYS)_ode.o
	$(CC) $(WARNINGS) $(OPTIMISE) $(INCLUDE) $(CFLAGS) -c $(SYS)_ode.cc

$(SYS)_ode.cc: $(SYS)_ode.txt
	echo Creating $(SYS)_ode.cc
	$(BIN)/ode_txt2cc $(SYS) < $(SYS)_ode.txt > $(SYS)_ode.cc

$(SYS)_ode.txt: $(SYS)_ese.r
	echo Creating $(SYS)_ode.txt
	$(BIN)/stripComments '%' < $(SYS)_ese.r | $(BIN)/resolve $(SYS) > $(SYS)_ode.txt

# system structure, sizes of state-space matrices
$(SYS)_struc.hh: $(SYS)_struc.txt
	echo Creating $(SYS)_struc.hh
	$(BIN)/struc_txt2hh $(SYS) < $(SYS)_struc.txt > $(SYS)_struc.hh

$(SYS)_struc.txt:
	echo Creating $(SYS)_struc.txt
	mtt $(MTTFLAGS) $(SYS) struc txt

# logic control
$(SYS)_switch.o: $(SYS)_switch.cc $(SYS)_struc.txt $(SYS)_sympars.txt
	echo Creating $(SYS)_switch.o
	$(CC) $(WARNINGS) $(OPTIMISE) $(INCLUDE) $(CFLAGS) -c $(SYS)_switch.cc

$(SYS)_switch.cc: $(SYS)_struc.txt
	echo Creating $(SYS)_switch.cc
	$(BIN)/struc2switch_txt2cc $(SYS) < $(SYS)_struc.txt > $(SYS)_switch.cc

# list of symbolic parameters
$(SYS)_sympar.txt:
	echo Creating $(SYS)_sympar.txt
	mtt $(MTTFLAGS) $(SYS) sympar txt

# list of symbolic parameters and switch controls
$(SYS)_sympars.txt:
	echo Creating $(SYS)_sympars.txt
	mtt $(MTTFLAGS) $(SYS) sympars txt
