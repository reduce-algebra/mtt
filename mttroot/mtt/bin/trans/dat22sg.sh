#! /bin/sh

# Convert simulation data to SciGraphica (v 0.61) Project file ($sys_odes.sg)

sys=$1

write_project_header ()
{
    cat <<EOF
<?xml version="1.0"?>

<sg:Project xmlns:sg="http://scigraphica.sourceforge.net">
  <sg:Summary>
    <sg:Item>
      <sg:name>application</sg:name>
      <sg:val-string>scigraphica</sg:val-string>
    </sg:Item>
    <sg:Item>
      <sg:name>author</sg:name>
      <sg:val-string>MTT:${USER}</sg:val-string>
    </sg:Item>
  </sg:Summary>

EOF
}

write_project_footer ()
{
    echo ''
    echo '</sg:Project>'
}

write_worksheet_header ()
{
    name=$1 ; ncol=$2 ; nrow=$3
    cat <<EOF

<sgw:Worksheet xmlns:sgw="http://scigraphica.sourceforge.net">
  <sgw:Summary>
    <sgw:Item>
      <sgw:name>application</sgw:name>
      <sgw:val-string>scigraphica</sgw:val-string>
    </sgw:Item>
    <sgw:Item>
      <sgw:name>author</sgw:name>
      <sgw:val-string>MTT:${USER}</sgw:val-string>
    </sgw:Item>
  </sgw:Summary>
  <sgw:Geometry Width="400" Height="350"/>
  <sgw:Name>${name}</sgw:Name>
  <sgw:MaxCol>${ncol}</sgw:MaxCol>
  <sgw:MaxRow>${nrow}</sgw:MaxRow>
  <sgw:Begin>-1</sgw:Begin>
  <sgw:End>-1</sgw:End>
EOF
}

write_worksheet_footer ()
{
    echo ''
    echo '</sgw:Worksheet>'
}

write_column_headings ()
{
    awk '{ printf ("  <sgw:Column No=\"%d\" Width=\"80\" Title=\"%s\" Format=\"0\" Precision=\"3\">\n  </sgw:Column>\n", NR-1,$0) }'
}

write_output_headings ()
{
    sys=$1
    ${MATRIX} -q <<EOF | write_column_headings
	[u_names,y_names,x_names] = ${sys}_struc;
	printf ("Time\n");
	disp (y_names);
EOF
}

write_state_headings ()
{
    sys=$1
    ${MATRIX} -q <<EOF | write_column_headings
	[u_names,y_names,x_names] = ${sys}_struc;
	printf ("Time\n");
	disp (x_names);
EOF
}

write_cell_values ()
{
    sys=$1 ; vec=$2
    ${MATRIX} -q <<EOF
function write_cell (row,col,val)
    printf ("\n");
    printf ("  <sgw:Cell Row=\"%d\" Col=\"%d\">\n", row,col);
    printf ("    <sgw:Content>%f</sgw:Content>\n", val);
    printf ("    <sgw:Formula>%f</sgw:Formula>\n", val);
    printf ("  </sgw:Cell>\n");
endfunction

    [u_names,y_names,x_names] = ${sys}_struc;
    ncol = size(${vec}_names)(1);

    load ("${sys}_odes.dat2");
    nrow = size(mtt_data)(1);

    # write Time
    for r = 1:nrow
	write_cell (r-1,0,mtt_data(r,1));
    endfor

    if ("${vec}" == "y")
	offset = 1;
    elseif ("${vec}" == "x")
	offset = size(y_names)(1);
    endif

    for r = 1:nrow
	for c = 1:ncol
	    write_cell (r-1,c,mtt_data(r,c+offset));
	endfor
    endfor
EOF
}

file=${sys}_odes.sg

NX=`mtt_getsize ${sys} x`
NY=`mtt_getsize ${sys} y`
NTMP=`wc -l ${sys}_odes.dat2 | awk '{print $1}'`
NROW=`expr ${NTMP} - 4`		# 4 comment lines in mtt_data

{
    write_project_header
    # states
    write_worksheet_header	"X_${sys}" ${NX} ${NROW}
    write_state_headings	${sys}
    write_cell_values		${sys} x
    write_worksheet_footer
    # outputs
    write_worksheet_header	"Y_${sys}" ${NY} ${NROW}
    write_output_headings	${sys}
    write_cell_values		${sys} y
    write_worksheet_footer
    write_project_footer
} > ${file}

