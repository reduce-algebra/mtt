#! /bin/sh

SYS=$1
REP=$2
TARGET=${3:-cc}
PARSER=${4:-indent}

IN=${SYS}_${REP}.m
OUT=${SYS}_${REP}.${TARGET}
TMP=${SYS}_${REP}_m2cc.tmp

rep_declarations ()
{
(case ${REP} in
    simpar)
	cat <<EOF
  struct {
    double first;
    double dt;
    double last;
    int    stepfactor;
    int    wmin;
    int    wmax;
    int    wsteps;
    int    input;
  } mttsimpar;

EOF
	;;
    *)
	;;
esac)
echo ""
};

rep_footer ()
{
(case ${REP} in
    simpar)
	cat <<EOF
  mttsimpar_map(0)	= (double) mttsimpar.first;
  mttsimpar_map(1)	= (double) mttsimpar.last;
  mttsimpar_map(2)	= (double) mttsimpar.dt;
  mttsimpar_map(3)	= (double) mttsimpar.stepfactor;
  mttsimpar_map(4)	= (double) mttsimpar.wmin;
  mttsimpar_map(5)	= (double) mttsimpar.wmax;
  mttsimpar_map(6)	= (double) mttsimpar.wsteps;
  mttsimpar_map(7)	= (double) mttsimpar.input;
EOF
	;;
    *)
	;;
esac)
};

find_code ()
{
    file_in=${1:-${IN}}
    portion=${2:-"body"}
    head=`cat ${file_in} | gawk '($2 == "BEGIN" && $3 == "Code") { print NR }'`
    foot=`cat ${file_in} | gawk '($2 == "END"   && $3 == "Code") { print NR }'`
    case ${portion} in
	head)
	    start=0
	    end=${head}
	    ;;
	body)
	    start=${head}
	    end=${foot}
	    ;;
	foot)
	    start=${foot}
	    end=end
	    ;;
	*)
	    echo "Error in find_code: portion unknown"
	    return -1
	    ;;
    esac
    cat ${file_in} |\
    gawk --assign start=${start} --assign end=${end} '
	(start < NR && NR < end) { print $0 }'
};


strip_junk ()
{
case ${REP} in
    numpar)
	grep -v "mttpar = \[\]"
	;;
    switchopen)
	grep -v "\[open\] = zero"
	;;
    *)
	cat
	;;
esac
};

fix_comment_delimiter ()
{
    language=${1:-cc}
    case $language in
    # it would be preferable if we didn't use '%' as a delimiter
    # (a % b) gives the remainder of ((int)a / (int)b) in C/C++
	c)
	    sed 's/[%#]\(.*\)/\/* \1 *\//'
	    ;;
	cc | *)
	    sed 's/[%#]/\/\//g' | sed 's/\/\/\/\//\/\//g'
	    ;;
    esac
};

decrement_indices ()
{    
    # first section appends '-1' to container indices
    # to convert from FORTRAN-type numbering to C-type numbering
    sed 's/mtta(\([0-9][0-9]*\),\([0-9][0-9]*\))/mtta[\1-1,\2-1]/g'	|\
    sed 's/mttax(\([0-9][0-9]*\))/mttax[\1-1]/g'			|\
    sed 's/mttdx(\([0-9][0-9]*\))/mttdx[\1-1]/g'			|\
    sed 's/mttedx(\([0-9][0-9]*\))/mttedx[\1-1]/g'			|\
    sed 's/mttpar(\([0-9][0-9]*\))/mttpar[\1-1]/g'			|\
    sed 's/mttu(\([0-9][0-9]*\))/mttu[\1-1]/g'				|\
    sed 's/mttx(\([0-9][0-9]*\))/mttx[\1-1]/g'				|\
    sed 's/mtty(\([0-9][0-9]*\))/mtty[\1-1]/g'				|\
    sed 's/mttyz(\([0-9][0-9]*\))/mttyz[\1-1]/g'			|\
    sed 's/mttz(\([0-9][0-9]*\))/mttz[\1-1]/g'				|\
    sed 's/mttopen(\([0-9][0-9]*\))/mttopen[\1-1]/g'				|\
									 \
    # next sections tidy the code up a bit, but are not necessary
    sed 's/1\-1\([\,\)]\)/0\1/g'       			       		|\
    sed 's/2\-1\([\,\)]\)/1\1/g'       			       		|\
    sed 's/3\-1\([\,\)]\)/2\1/g'       			       		|\
    sed 's/4\-1\([\,\)]\)/3\1/g'       			       		|\
    sed 's/5\-1\([\,\)]\)/4\1/g'       			       		|\
    sed 's/6\-1\([\,\)]\)/5\1/g'       			       		|\
    sed 's/7\-1\([\,\)]\)/6\1/g'       			       		|\
    sed 's/8\-1\([\,\)]\)/7\1/g'       			       		|\
    sed 's/9\-1\([\,\)]\)/8\1/g'       			       		|\
									 \
    sed 's/10\-1\([\,\)]\)/9\1/g'     			       		|\
    sed 's/20\-1\([\,\)]\)/19\1/g'	       		       		|\
    sed 's/30\-1\([\,\)]\)/29\1/g'		       	       		|\
    sed 's/40\-1\([\,\)]\)/39\1/g'			       		|\
    sed 's/50\-1\([\,\)]\)/49\1/g'		               		|\
    sed 's/60\-1\([\,\)]\)/59\1/g'		      	       		|\
    sed 's/70\-1\([\,\)]\)/69\1/g'		       	       		|\
    sed 's/80\-1\([\,\)]\)/79\1/g'		       	       		|\
    sed 's/90\-1\([\,\)]\)/89\1/g'		       	       		|\
									 \
    sed 's/100\-1\([\,\)]\)/99\1/g'   			       		|\
    sed 's/200\-1\([\,\)]\)/199\1/g'	       		       		|\
    sed 's/300\-1\([\,\)]\)/299\1/g'		       	       		|\
    sed 's/400\-1\([\,\)]\)/399\1/g'			       		|\
    sed 's/500\-1\([\,\)]\)/499\1/g'			       		|\
    sed 's/600\-1\([\,\)]\)/599\1/g'			       		|\
    sed 's/700\-1\([\,\)]\)/699\1/g'			       	       	|\
    sed 's/800\-1\([\,\)]\)/799\1/g'			       		|\
    sed 's/900\-1\([\,\)]\)/899\1/g'			       		|\
    sed 's/\([(,]\)0\([0-9]\)/\1\2/g'
};

fortran_to_c_paren ()
{
    # converts [i] to (i)
    sed 's/\[\([^[]*\)\]/(\1)/g'
}
	
fix_pow ()
{
    # matches number^number where number is one or more digits and one or zero decimal points
    # converts to pow (number, number)
    sed 's/\([0-9]*\)\(\.\)\{0,1\}\([0-9]*\)\^\([0-9]*\)\(\.\)\{0,1\}\([0-9]*\)/pow \(\1\2\3,\4\5\6\)/g'
};


echo Creating ${OUT}

case ${TARGET} in
    c)
	mtt_header ${SYS} ${REP} "c"	>  ${TMP}
	find_code ${TMP} head		>  ${OUT}
	find_code ${IN} body		|\
	    decrement_indices		|\
	    fix_comment_delimiter c	|\
	    fix_pow			|\
	    strip_junk			|\
	    ${PARSER}			>> ${OUT}
	find_code ${TMP} foot		>> ${OUT}
	rm ${TMP}
	;;
    cc | *)
	mtt_header ${SYS} ${REP} "oct"	>  ${TMP}
	find_code ${TMP} head		>  ${OUT}
	rep_declarations		>> ${OUT}
	find_code ${IN} body   		|\
	    decrement_indices		|\
	    fortran_to_c_paren		|\
	    fix_comment_delimiter cc	|\
	    fix_pow			|\
	    strip_junk			|\
	    ${PARSER}			>> ${OUT}
	rep_footer			>> ${OUT}
	find_code ${TMP} foot		>> ${OUT}
	rm ${TMP}
	;;
esac


