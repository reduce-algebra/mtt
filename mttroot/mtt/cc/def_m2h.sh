#! /bin/sh
# $Id$
# $Log$
# Revision 1.3  2000/12/05 12:13:52  peterg
# Changed function name to name()
#
# Revision 1.2  2000/12/04 12:04:46  peterg
# Changed $() to `` for sh compatibility -- geraint
#
# Revision 1.1  2000/12/04 12:02:23  peterg
# Initial revision
#
# Revision 1.1  2000/10/31 04:32:28  geraint
# Initial revision
#

SYS=$1
IN=${SYS}_def.m
SYM=${SYS}_sympar.txt
OUT=${SYS}_def.h

get_array_size ()
{
vec=$1
awk -v vec=${vec} '($1 == vec && $2 == "=") { print $3 }' | sed s/\;//
}

 echo "// ${SYS}_def.h, generated by MTT on `date`"			>  ${OUT}
 echo ""								>> ${OUT}
 echo "const int MTTNU   = `cat ${IN} | get_array_size nu`;"		>> ${OUT}
 echo "const int MTTNX   = `cat ${IN} | get_array_size nx`;"		>> ${OUT}
 echo "const int MTTNY   = `cat ${IN} | get_array_size ny`;"		>> ${OUT}
 echo "const int MTTNZ   = `cat ${IN} | get_array_size nz`;"		>> ${OUT}
 echo "const int MTTNYZ  = `cat ${IN} | get_array_size nyz`;"		>> ${OUT}
 echo "const int MTTNPAR = `wc -l ${SYM} | awk '{ print $1 }'`;"       	>> ${OUT}

cat <<EOF >> ${OUT}

// typedefs won't work because it is illegal to initialise ColumnVector in typedef
// use "ColumnVector mttx (MTTNX);" until the proper classes are ready


#if 0 // NB: These classes are not ready for use yet!
class InputVector : public ColumnVector
{
public:
  InputVector (void) : ColumnVector (MTTNU) { ; }
};
class StateVector : public ColumnVector
{
public:
  StateVector (void) : ColumnVector (MTTNX) { ; }
};
class OutputVector : public ColumnVector
{
public:
  OutputVector (void) : ColumnVector (MTTNY) { ; }
};
class ParameterVector : public ColumnVector
{
public:
  ParameterVector (void) : ColumnVector (MTTNPAR) { ; }
};
class StateMatrix : public Matrix
{
public:
  StateMatrix (void) : Matrix (MTTNX, MTTNX) { ; }
};
#endif

EOF




