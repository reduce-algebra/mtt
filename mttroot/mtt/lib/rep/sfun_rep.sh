#! /bin/sh

set -e

debug=0
if [ $debug -eq 1 ]; then
    set -x
    make_debug='--debug=a'
else
    set +x
    make_debug=''
fi

check_for_errors ()
{
    errno=0
    # check stuff
    case $errno in
	0)
	    ;; # ok
	*)
	    echo "E $errno";
	    exit $errno;
	    ;;
    esac
}

check_for_errors $*

OPTS="$1" SYS="$2" REP="$3" LANG="$4" make $make_debug -f ${MTT_REP}/sfun_rep/Makefile ${2}_${3}.${4}
exit 0