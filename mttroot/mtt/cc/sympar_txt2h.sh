#! /bin/sh
# $Id$
# $Log$
# Revision 1.5  2000/12/05 12:44:55  peterg
# Changed $() to ``
#
# Revision 1.4  2000/12/05 12:16:02  peterg
# Changed function name to name()
#
# Revision 1.3  2000/12/04 11:05:01  peterg
# Removed () -- geraint
#
# Revision 1.2  2000/11/07 17:29:27  peterg
# Changed echo
#
# Revision 1.1  2000/11/07 17:28:53  peterg
# Initial revision
#
# Revision 1.1  2000/10/31 04:32:02  geraint
# Initial revision
#

SYS=$1

if [ $# -gt 1 ]
then
  NUM_OF_TMP_VAR=$2;
  shift; shift;
else
  NUM_OF_TMP_VAR=500
  shift;
fi
TMP_VAR_NAMES="mtt_tmp mtt_o $*"

IN=${SYS}_sympar.txt
OUT=${SYS}_sympar.h

declare_sys_param ()
{
cat ${IN} | awk '{printf ("double %s;\t// %s\n", $1, $2)}'
}

declare_temp_vars ()
{
for name in ${TMP_VAR_NAMES}
do
    echo ""
    i=0
    while [ ${i} -le ${NUM_OF_TMP_VAR} ]
    do
	echo "double ${name}${i};"
	i=`expr ${i} + 1`
    done
done
}

echo Creating ${OUT}
declare_sys_param	>  ${OUT}
declare_temp_vars	>> ${OUT}
