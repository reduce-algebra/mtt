#!/bin/csh
## Automatically generated from bashrc on Wed Apr 24 10:24:58 BST 2002 - DO NOT EDIT
#! /bin/sh

     ###################################### 
     ##### Model Transformation Tools #####
     ######################################

# Bourne shell script: mttrc - sets up paths etc for mtt
# Usage: mttrc 

# Copyright (c) P.J.Gawthrop 1996,1977.


###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
## Revision 1.25  2002/04/02 09:16:39  geraint
## Tidied up library search paths, now assumes that system libraries are set up correctly.
## For Debian, this means installing the following: blas-dev, fftw-dev, lapack-dev, libncurses5-dev, libkpathsea-dev, libreadline-dev
## It may also be necessary to run /sbin/ldconfig on the relevant directories (especially Octave's).
##
## Revision 1.24  2001/10/15 14:28:35  gawthrop
## Now has . at start of components library path $MTT_COMPONENTS
##
## Revision 1.23  2001/07/24 22:32:49  gawthrop
## Use gv, not ghostview
##
## Revision 1.22  2001/04/12 03:08:00  geraint
## Improved sh->csh conversion, reduces environment namespace pollution.
##
## Revision 1.21  2001/04/10 13:56:13  gawthrop
## Uses standard mkoctfile
##
## Revision 1.20  2001/04/10 13:08:19  gawthrop
## Smoother translation to .cs using sh2csh
##
## Revision 1.19  2001/03/30 15:13:49  gawthrop
## Rationalised simulation modes to each return mtt_data
##
## Revision 1.18  2001/03/19 02:28:52  geraint
## Branch merge: merging-ode2odes-exe back to MAIN.
##
## Revision 1.17.2.4  2001/03/06 03:48:43  geraint
## Print additional environment variable for "mtt -p".
## MTT_LDFLAGS defaults to " " to avoid installation warning.
##
## Revision 1.17.2.3  2001/03/01 05:05:53  geraint
## Minor revisions.
##
## Revision 1.17.2.2  2001/02/23 03:53:53  geraint
## Minor revisions. (ode2odes.exe works on GNU/Linux and ~GNU/Irix)
##
## Revision 1.17.2.1  2001/02/22 06:41:40  geraint
## Initial merge of ode2odes.exe into main mtt.
## standalone_rep.make deleted: rules moved to mtt, variables to mttrc.
##
## Revision 1.17  2000/12/27 16:46:13  peterg
## Stripped the mtt- from paths
##
## Revision 1.16  2000/12/27 15:16:44  peterg
##
## Revision 1.15  2000/12/27 14:57:43  peterg
## Now takes the base path as an argument
##
## Revision 1.14  2000/12/27 13:11:43  peterg
## *** empty log message ***
##
## Revision 1.13  2000/10/03 12:12:14  peterg
## New path structure to account for three way split in mtt tree
##
## Revision 1.12  2000/09/18 12:17:07  peterg
## Now includes to control system toolbox in OCTAVE_PATH
## Don't use -path stuff - use :: instead.
##
## Revision 1.11  2000/05/21 17:55:15  peterg
## New rep path
##
## Revision 1.10  2000/05/16 11:41:23  peterg
## *** empty log message ***
##
## Revision 1.9  1999/03/11 04:02:19  peterg
## Revised so that sh2csh does its stuff.
##
## Revision 1.8  1998/07/17 19:48:46  peterg
## *** empty log message ***
##
## Revision 1.7  1998/03/24 09:11:49  peterg
## Compatible with .csh version
##
## Revision 1.6  1998/03/13 11:53:29  peterg
## reduce --> reduce 64
##
## Revision 1.5  1998/01/16 08:55:01  peterg
## MAKE=make
##
## Revision 1.4  1998/01/06 09:14:51  peterg
## Added latex2html to setup
##
# Revision 1.3  1998/01/06  09:11:26  peterg
# Removed matlab from the setup
#
# Revision 1.2  1997/12/04  10:49:16  peterg
# Put under RCS at last
# Added CC variable
#
###############################################################

## When using csh, replace /home/peterg/Development/mttroot/mtt by the mtt base path, eg /usr/share/mtt/latest
setenv MTT_BASE /home/peterg/Development/mttroot/mtt

  echo Setting paths with base $MTT_BASE
  # The following line sets up the make to use -- gmake is the standard 
  # but you may wish to use lsmake for parallelism
  setenv MAKE 'make'
  
  # The following sets up the c compiler
  setenv CC 'gcc'
  
  # Setup the paths
  setenv MTTPATH $MTT_BASE/bin
  setenv MTT_LIB $MTT_BASE/lib
  setenv MTT_DOC $MTT_BASE/doc
  setenv MTT_CC $MTT_BASE/cc
  
  setenv MTT_COMPONENTS .:$MTT_LIB/comp
  setenv MTT_CRS $MTT_LIB/cr
  setenv MTT_EXAMPLES $MTT_LIB/examples
  setenv MTT_REP $MTT_LIB/rep
  
  setenv PATH $PATH\:$MTTPATH\:$MTTPATH/trans\:$MTT_CC
  
  #Setup octave
  setenv MATRIX_PATH $MTTPATH/trans/m//
  setenv MATRIX_PATH $MATRIX_PATH\:$MTT_LIB/comp/simple//
  setenv MATRIX_PATH $MATRIX_PATH\:$MTT_LIB/control//
  setenv MATRIX_PATH $MATRIX_PATH\:$MTT_LIB/octave//\:\:
  
  setenv OCTAVE_PATH .\:$MATRIX_PATH
  setenv MATRIX "octave"
  
  # Setup the symbolic stuff
  setenv SYMBOLIC 'reduce 64'
  
  
  # Setup xfig
  setenv FIG "xfig  \
  	-startfontsize 20 \
  	-metric \
  	-portrait \
  	-startgridmode 2 \
  	-pheight 21 \
  	-pwidth 30 \
  	-library_dir $MTT_LIB/xfig/\
  	"
  
  # Setup ps viewer
  setenv PSVIEW 'gv'
  
  # Setup pdf viewer
  setenv PDFVIEW 'acroread'
  
  # Setup html viewer
  setenv HTMLVIEW 'netscape'
  
  # Setup dvi viewer
  setenv DVIVIEW 'xdvi'
  
  # Setup latex2html
  setenv LATEX2HTML "latex2html -contents_in_navigation -index_in_navigation -address http://mtt.sourceforge.net"
  
  # Ascend stuff
  setenv ASCENDLIBRARY $MTTPATH/ascend/lib
  
  # Oct file generation - use version with no optimisation.
  #setenv MKOCTFILE $MTT_LIB/octave/mkoctfile # This for no optimisation
    setenv MKOCTFILE mkoctfile

  # ode2odes.exe stuff

    # local system

set PLAT="i686-pc-linux-gnu"
set PREFIX="/usr"
set GCCVERS="2.95.2"

    # include paths

set IOCTAVE="-I${PREFIX}/include/octave/ -I${PREFIX}/include/octave/octave"

    # library paths

set OCTAVEVERS=`octave --version | awk '{ print $4 }'`
set LOCTAVE="-L${PREFIX}/lib/octave-${OCTAVEVERS} -loctave -lcruft -loctinterp"
set LSYSTEM="-ldl -lm -lncurses -lkpathsea -lreadline -lblas -llapack -lfftw -lg2c"

    # compiler options

set DEBUG="-g"
set OPTIM="-O3"
set FLAGS="-fno-rtti -fno-exceptions -fno-implicit-templates"

    # exported variables

    setenv MTT_CXX "g++"
    setenv MTT_CXXFLAGS "${DEBUG} ${OPTIM} ${FLAGS}"
    setenv MTT_CXXLIBS "${LOCTAVE} ${LSYSTEM}"
    setenv MTT_CXXINCS "-I. ${IOCTAVE}"
    setenv MTT_LDFLAGS " "
