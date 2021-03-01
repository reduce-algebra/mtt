#! /bin/sh

usage ()
{
cat <<EOF

Usage: $0 [-p] file1 file2

       prepend file1 to file2
    
    options:

      -p preserves time attribute

EOF
}

preserve=''
while [ -n "`echo $1 | grep '^-'`" ]; do
    case $1 in
	-p)
	    preserve='-p'
	    ;;
	-h)
	    usage
	    exit
	    ;;
	 *)
	    echo "Error: invalid option ($1)"
	    usage;
	    exit;
	    ;;
    esac
    shift
done

if [ $# -ne 2 ]; then
    usage;
    exit;
fi

file1=$1
file2=$2
tmp=mtt_prepend.sh_$file1_$file2.tmp

if [ ${preserve:=""} = "-p" ]; then
    time=mtt_prepend.sh_$file2.time
    touch -r $file2 $time
fi

cat $file1 $file2 > $tmp

if [ ${preserve:=""} = "-p" ]; then
    touch -r $time $tmp
    rm $time
fi

cp $preserve $tmp $file2
rm $tmp

