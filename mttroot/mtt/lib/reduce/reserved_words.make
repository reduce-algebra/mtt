#! /bin/sh

reduce_reserved_word_manual_page=${1:-"/usr/local/reduce/doc/manual/appenda.tex"}
output="reserved_words.txt"

cat $reduce_reserved_word_manual_page                   |\
    tr "\n" " "                                         |\
    sed 's/\\\_/_/g'                                    |\
    sed 's/\\tt\ \([A-Za-z0-9_]*\)/\"\1\"/g'            |\
    tr " " "\n"                                         |\
    sed 's/\{//g'                                       |\
    sed 's/\}//g'                                       |\
    awk -F\" '(NF==3) { printf "%s\n",$2 }'             |\
    sort -u						\
> $output
