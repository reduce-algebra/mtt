#! /usr/bin/gawk -f
# script to replace the line: "/* insert filename */" with the contents of file "filename"
($1 != "/*" || $2 != "insert" || $4 != "*/") { print }
($1 == "/*" && $2 == "insert" && $4 == "*/") { cmd = "cat " $3 ; system(cmd) }