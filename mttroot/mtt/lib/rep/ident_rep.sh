#! /bin/sh

## ident_rep.sh
## DIY representation "ident" for mtt
# Copyright (C) 2002 by Peter J. Gawthrop

ps=ps

sys=$1
rep=ident
lang=$2
mtt_parameters=$3
rep_parameters=$4

## Some names
target=${sys}_${rep}.${lang}
def_file=${sys}_def.r
dat2_file=${sys}_ident.dat2
dat2s_file=${sys}_idents.dat2
ident_numpar_file=${sys}_ident_numpar.m
option_file=${sys}_ident_mtt_options.txt

## Get system information
if [ -f "${def_file}" ]; then
 echo Using ${def_file}
else
  mtt -q ${sys} def r
fi

ny=`mtt_getsize $1 y`
nu=`mtt_getsize $1 u`

check_new_options() {
    if [ -f "${option_file}" ]; then
	old_options=`cat ${option_file}`
        if [ "${mtt_options}" != "${old_options}" ]; then
	   echo ${mtt_options} > ${option_file}
	fi
    else
	echo ${mtt_options} > ${option_file}
    fi
}

## Make the _ident.m file
make_ident() {
filename=${sys}_${rep}.m
date=`date`
echo Creating ${filename}

cat > ${filename} <<EOF    
function [epar,Y] = ${sys}_ident (y,u,t,par_names,Q,extras)

  ## usage:  [epar,Y] = ${sys}_ident (y,u,t,par_names,Q,extras)
  ##
  ## last      last time in run
  ## ppp_names Column vector of names of ppp params
  ## par_names Column vector of names of estimated params
  ## extras    Structure containing additional info
  ##
  ## Created by MTT on ${date}
 
  ## Sensitivity system name
  system_name = "s${sys}"

  ##Sanity check
  if nargin<3
    printf("Usage: [y,u,t] = ${sys}_ident(y,u,t,par_names,Q,extras);");
    return
  endif

  if nargin<6
    ## Set up optional parameters
    extras.criterion = 1e-3;
    extras.emulate_timing = 0;
    extras.max_iterations = 10;
    extras.simulate = 2;
    extras.v =  1e-2;
    extras.verbose = 1;
    extras.visual = 1;
  endif
  
  ## System info
  [n_x,n_y,n_u,n_z,n_yz] = ${sys}_def;
  sympar  = ${sys}_sympar;
  simpar  = ${sys}_simpar;
  sympars  = s${sys}_sympar;
  simpars  = s${sys}_simpar;

  ## Parameter indices
  i_par = ppp_indices (par_names,sympar,sympars);

  ## Initial model state
  x_0 = zeros(2*n_x,1);

  ## Initial model parameters
  par_0 = s${sys}_numpar;

  ## Reset simulation parameters
  [n_data,m_data] = size(y);
  dt = t(2)-t(1);
  simpars.last = (n_data-1)*dt;
  simpars.dt = dt;

  ## Identification
  [epar,Par,Error,Y,iterations,x] = ppp_optimise(system_name,x_0,par_0,simpars,u,y,i_par,Q,extras);
  
  ## Do some plots
  figure(1);
  title("Comparison of data");
  xlabel("t");
  ylabel("y");
  [N,M] = size(Y);
  plot(t,Y(:,M-n_y+1:M),"1;Estimated;", t,y,"3;Actual;");
  figfig("${sys}_ident_comparison");

  ## Create a table of the parameters
  [n_par,m_par] = size(i_par);
  fid = fopen("${sys}_ident_par.tex", "w");
  fprintf(fid,"\\\\begin{table}[htbp]\\n");
  fprintf(fid," \\\\centering\\n");
  fprintf(fid," \\\\begin{tabular}{|l|l|}\\n");
  fprintf(fid,"  \\\\hline\\n");
  fprintf(fid,"  Name & Value \\\\\\\\ \\n");
  fprintf(fid,"  \\\\hline\\n");
  for i = 1:n_par
    fprintf(fid,"$%s$ & %4.2f \\\\\\\\ \\n", par_names(i,:), epar(i_par(i,1)));
  endfor
  fprintf(fid,"  \\\\hline\\n");
  fprintf(fid,"\\\\end{tabular}\\n");
  fprintf(fid,"\\\\caption{Estimated Parameters}\\n");
  fprintf(fid,"\\\\end{table}\\n");
  fclose(fid);

endfunction
EOF
}

make_ident_numpar() {
echo Creating ${ident_numpar_file}
cat > ${sys}_ident_numpar.m <<EOF
function [y,u,t,par_names,Q,extras] = ${sys}_ident_numpar;

  ## usage: [y,u,t,par_names,Q,extras] = ${sys}_ident_numpar;
  ## Edit for your own requirements
  ## Created by MTT on ${date}

    
  ## This section sets up the data source
  ## simulate = 0  Real data (you supply ${sys}_ident_data.dat)
  ## simulate = 1  Real data input, simulated output
  ## simulate = 2  Unit step input, simulated output
  simulate = 2;
  

  ## System info
  [n_x,n_y,n_u,n_z,n_yz] = ${sys}_def;
  simpars = s${sys}_simpar;

  ## Access or create data
  if (simulate<2)		# Get the real data
    if (exist("${sys}_ident_data.dat")==2)
      printf("Loading ${sys}_ident_data.dat\n");
      load ${sys}_ident_data.dat
    else
      printf("Please create a loadable file ${sys}_ident_data.dat containing y,u and t\n");
      return
    endif
  else 
    switch simulate
      case 2			# Step simulation
	t = [0:simpars.dt:simpars.last]';
	u = ones(size(t));
      otherwise
	error(sprintf("simulate = %i not implemented", simulate));
    endswitch
  endif
  
  if (simulate>0)
    par = ${sys}_numpar();
    x_0 = ${sys}_state(par);
    dt = t(2)-t(1);
    simpars.dt = dt;
    simpars.last = t(length(t));
    y =  ${sys}_sim(zeros(n_x,1), par, simpars, u);
  endif

  ## Default parameter names - Put in your own here
  sympar = ${sys}_sympar;	# Symbolic params as structure
  par_names = struct_elements (sympar);	# Symbolic params as strings
  [n,m] = size(par_names);	# Size the string list

  ## Sort by index
  for [i,name] = sympar
    par_names(i,:) = sprintf("%s%s",name, blanks(m-length(name)));
  endfor
  
  ## Output weighting vector
  Q = ones(n_y,1);
  
  ## Extra parameters
  extras.criterion = 1e-5;
  extras.emulate_timing = 0;
  extras.max_iterations = 10;
  extras.simulate = simulate;
  extras.v =  1e-2;
  extras.verbose = 1;
  extras.visual = 1;
  extras.domain = "time";

endfunction
EOF
}

make_dat2() {

## Inform user
echo Creating ${dat2_file}

## Use octave to generate the data
octave -q <<EOF
  [y,u,t,par_names,Q,extras] = ${sys}_ident_numpar;
  [epar,Y] = ${sys}_ident (y,u,t,par_names,Q,extras);
  [N,M] = size(Y);
  y_est = Y(:,M);
  data = [t,y_est,u];
  save -ascii ${dat2_file} data
EOF

## Tidy up the latex stuff - convert foo_123 to foo_{123}
cat ${sys}_ident_par.tex > mtt_junk
sed  -e "s/_\([a-z0-9,]*\)/_{\1}/g" < mtt_junk >${sys}_ident_par.tex
rm mtt_junk
}

case ${lang} in
    numpar.m)
        ## Make the numpar stuff
        make_ident_numpar;
	;;
    m)
        ## Make the code
        make_ident;
	;;
    dat2)
        ## The dat2 language (output data) & fig file
	make_dat2; 
	;;
    gdat)
        cp ${dat2_file} ${dat2s_file} 
	dat22dat ${sys} ${rep} 
        dat2gdat ${sys} ${rep}
	;;
    fig)
        gdat2fig ${sys}_${rep}
	;;
    ps)
        figs=`ls ${sys}_ident*.fig | sed -e 's/\.fig//'`
	for fig in ${figs}; do
            fig2dev -Leps ${fig}.fig > ${fig}.ps
	done
	texs=`ls ${sys}_ident*.tex | sed -e 's/\.tex//'`
	for tex in ${texs}; do
          makedoc "" "${sys}" "ident_par" "tex" "" "" "$ps"
          doc2$ps ${sys}_ident_par "$documenttype"
	done
	;;
    view)
	pss=`ls ${sys}_ident*.ps` 
        echo Viewing ${pss}
        for ps in ${pss}; do
          ${PSVIEW} ${ps}&
	done
	;;
    *)
	echo Language ${lang} not supported by ${rep} representation
        exit 3
esac


