#! /bin/sh

type=$1
name=$2
file=$3

notvar="[%|#]NOT[V|P]AR"
grep ${notvar} ${type}_lbl.txt |\
    gawk '{ printf ("%s\t%s\n", $2, name) }' name=${name} \
    >> ${file}
 
