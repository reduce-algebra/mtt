# -*-makefile-*-

.POSIX:

MTTFLAGS	= -q -u -oct $(OPTS)

# Adapt according to local set-up and mkoctfile
CXX		= g++
CXXFLAGS	= $(DEBUG) $(OPTIM) $(DEFINES) $(ARCHFLAGS) -fno-rtti -fno-exceptions -fno-implicit-templates

DEBUG		= -g
OPTIM		= -O3

PREFIX		= /usr/local

INCLUDES	= -I$(PREFIX)/include/octave

OCTAVE_SRC_PATH	= $(PREFIX)/src/octave

LIBOCTAVE	= -L$(PREFIX)/lib/octave			-loctave -lcruft -loctinterp
LIBKPATHSEA	= -L$(OCTAVE_SRC_PATH)/kpathsea			-lkpathsea
LIBREADLINE	= -L$(OCTAVE_SRC_PATH)/readline			-lreadline
LIBBLAS		= -L/usr/local/src/ATLAS/lib/Linux_PIII		-lcblas -lf77blas -llapack -latlas -ltstatlas
LIBF2C		= 						-lg2c
LIBRARIES	= 						-ldl -lm -lncurses

ARCHFLAGS	= $(i386FLAGS)
i386FLAGS	=  -mieee-fp 

# Define -DOCTAVE_DEV for octave 2.1.x
ifeq (0, $(shell octave --version | awk -F\. '{print $2}'))
DEFINES   = -DSTANDALONE
else
DEFINES   = -DSTANDALONE -DOCTAVE_DEV
endif

all: $(SYS)_standalone.$(LANG)

$(SYS)_standalone.exe: $(SYS)_ode2odes.cc $(SYS)_def.h $(SYS)_sympar.h
	cp $(MTT_LIB)/cc/*.cc .
	echo Creating $(SYS)_standalone.exe
	$(CXX) *.cc -o $@ $(CXXFLAGS) $(INCLUDES) $(LIBOCTAVE) $(LIBKPATHSEA) $(LIBREADLINE) $(LIBBLAS) $(LIBF2C) $(LIBRARIES)

.PHONY: $(SYS)_standalone.clean

$(SYS)_ode2odes.cc:
	mtt $(MTTFLAGS) $(SYS) ode2odes m

$(SYS)_def.h:
	mtt $(MTTFLAGS) $(SYS) def h

$(SYS)_sympar.h:
	mtt $(MTTFLAGS) $(SYS) sympar h 


$(SYS)_standalone.clean:
	cd .. ; mtt Clean
	rm -f ../$(SYS)_standalone.exe
