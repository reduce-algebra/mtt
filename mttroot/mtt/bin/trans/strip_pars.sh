#! /bin/sh
infile=$1
name=$2



var="[%|#][V|P]AR"
grep ${var} ${infile} |\
    gawk '{ printf ("%s\t%s\n", $2, name) }' name=${name} \
 
