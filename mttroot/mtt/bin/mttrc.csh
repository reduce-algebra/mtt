#!/bin/csh
## Automatically generated from bashrc on Tue Apr 10 14:02:38 BST 2001 - DO NOT EDIT
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
## If then else format
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
## MAKE make
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

## When using csh, replace $1 by the mtt base path, eg /usr/share/mtt/latest
setenv MTT_BASE /home/peterg/Development/mttroot/mtt

#if [ -z "$MTT_BASE" ]; then
#  echo mttrc requires one argument: eg mttrc /usr/share/mtt/latest
#else
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
  
  setenv MTT_COMPONENTS $MTT_LIB/comp
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
  setenv PSVIEW 'ghostview'
  
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
  setenv MKOCTFILE $MTT_LIB/octave/mkoctfile

  # ode2odes.exe stuff

    # local system

    setenv PLAT "i686-pc-linux-gnu"
#    PREFIX "/usr/local"
    setenv PREFIX "/usr"
    setenv GCCVERS "2.95.2"
    setenv SRCOCTAVE "/cvs/octave"

#    PLAT "mips-sgi-irix6.5"
#    PREFIX "/usr/people/bevangp/GNU"
#    GCCVERS "2.95.2"
#    SRCOCTAVE "${PREFIX}/../build/octave-2.1.33"

    # include paths

    setenv IOCTAVE "-I${PREFIX}/include/octave"

    # library paths

#    LOCTAVE "-L${PREFIX}/lib/octave -loctave -lcruft -loctinterp"
    setenv LOCTAVE "-L${PREFIX}/lib/octave -loctave -lcruft -loctinterp"
    setenv LKPATHSEA "-L${SRCOCTAVE}/kpathsea -lkpathsea"
    setenv LREADLINE " -L${SRCOCTAVE}/readline -lreadline"
    setenv LSYSTEM "-ldl -lm -lncurses"
    setenv LF2C "-L${PREFIX}/lib/gcc-lib/${PLAT}/${GCCVERS} -lg2c"

    # compiler options

    setenv DEBUG "-g"
    setenv OPTIM "-O3"
    setenv FLAGS "-fno-rtti -fno-exceptions -fno-implicit-templates"

    # setenved variables

    setenv MTT_CXX "g++"
    setenv MTT_CXXFLAGS "${DEBUG} ${OPTIM} ${FLAGS}"
    setenv MTT_CXXLIBS "${LOCTAVE} ${LKPATHSEA} ${LREADLINE} ${LF2C} ${LSYSTEM}"
    setenv MTT_CXXINCS "-I. ${IOCTAVE}"
    setenv MTT_LDFLAGS " "
#fi