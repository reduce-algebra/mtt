#! /bin/sh

file=$1

gzip --test --quiet $file 2> /dev/null ; file_is_uncompressed=$?

if [ $file_is_uncompressed -eq 0 ]; then
    gz=`mktemp $file.gz.tmpXXXXXX`
    mv $file $gz
    zcat $gz > $file
fi

