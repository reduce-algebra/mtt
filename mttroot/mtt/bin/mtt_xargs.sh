#! /bin/sh

cmd=$1
for arg in $2; do
	eval $cmd $arg
done

