#! /bin/sh

## nppp_rep.sh
## DIY representation "nppp" for mtt
# Copyright (C) 2002 by Peter J. Gawthrop

sys=$1
rep=nppp
lang=$2
mtt_parameters=$3
rep_parameters=$4

## Some names
target=${sys}_${rep}.${lang}
def_file=${sys}_def.r
dat2_file=${sys}_nppp.dat2
dat2s_file=${sys}_nppps.dat2
nppp_numpar_file=${sys}_nppp_numpar.m
option_file=${sys}_nppp_mtt_options.txt

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

## Make the _nppp.m file
make_nppp() {
filename=${sys}_${rep}.m
echo Creating ${filename}

cat > ${filename} <<EOF    
function [y,u,t] = ${sys}_nppp (last, ppp_names, par_names, A_u, A_w, w, Q, extras)

  ## usage:  [y,u,t] = ${sys}_nppp (last, ppp_names, par_names, A_u, A_w, w, Q, extras)
  ##
  ## last      last time in run
  ## ppp_names Column vector of names of ppp params
  ## par_names Column vector of names of estimated params
  ## extras    Structure containing additional info

  ##Sanity check
  if nargin<2
    printf("Usage: [y,u,t] = ${sys}_nppp(N, ppp_names[, par_names, extras])\n");
    return
  endif

  if nargin<4
    ## Set up optional parameters
    extras.criterion = 1e-3;
    extras.emulate_timing = 0;
    extras.max_iterations = 15;
    extras.simulate = 1;
    extras.v =  1e-6;
    extras.verbose = 0;
    extras.visual = 1;
  endif
  
  ## System info
  [n_x,n_y,n_u,n_z,n_yz] = ${sys}_def;
  sympar  = ${sys}_sympar;
  simpar  = ${sys}_simpar;
  sympars  = s${sys}_sympar;
  simpars  = s${sys}_simpar;
  t_ol = simpar.last;
    
  ## Number of intervals needed
  N = ceil(last/t_ol);

  ## Setpoints
  if extras.verbose
    printf("Open-loop interval %3.2f \n", simpar.last);
    printf(" -- using info in ${sys}_simpar.txt\n");
    printf("PPP optimisation from %3.2f to %3.2f\n", simpars.first, simpars.last);
    printf(" -- using info in s${sys}_simpar.txt\n");
  endif
  
  t_horizon = [simpars.first+simpars.dt:simpars.dt:simpars.last]';
  w_s = ones(length(t_horizon)-1,1)*w';

  ## Setup the indices of the adjustable stuff
  if nargin<2
    i_ppp = []
  else
    i_ppp = ppp_indices (ppp_names,sympar,sympars); # Parameters
  endif

  n_ppp = length(i_ppp(:,1));

  if nargin<3
    i_par = []
  else
    i_par = ppp_indices (par_names,sympar,sympars); # Parameters
  endif
  

  if extras.visual		# Do some simulations
    ## System itself
    par = ${sys}_numpar;
    x_0_ol = ${sys}_state(par);
    [y_ol,x_ol, t_ol] =  ${sys}_sim(x_0_ol, par, simpar, ones(1,n_u));
    simpar_OL = simpar;
    simpar_OL.last = simpars.last;
    [y_OL,x_OL, t_OL] =  ${sys}_sim(x_0_ol, par, simpar_OL, ones(1,n_u));

    pars = s${sys}_numpar;
    x_0_ppp = s${sys}_state(pars);
    [y_ppp,y_par,x_ppp, t_ppp] =  s${sys}_ssim(x_0_ppp, pars, simpars, ones(1,n_u));

    simpar_PPP = simpars;
    simpar_PPP.first = simpar.first;
    [y_PPP,y_par,x_PPP, t_PPP] =  s${sys}_ssim(x_0_ppp, pars, simpar_PPP, ones(1,n_u));



    figure(2); 	
    grid; title("Outputs of ${sys}_sim and s${sys}_ssim");
    plot(t_ol,y_ol, '*', t_ppp, y_ppp, '+', t_OL, y_OL, t_PPP, y_PPP);

    ## Basis functions
    Us = ppp_ustar(A_u,1,t_OL',0,0)';

    figure(3); 	
    grid; title("Basis functions");
    plot(t_OL, Us);

  endif



  ## Do it
  [y,u,t,p,U,t_open,t_ppp,t_est,its_ppp,its_est] \
      = ppp_nlin_run ("${sys}",i_ppp,i_par,A_u,w_s,N,Q,extras);

  ## Compute values at ends of ol intervals
  T_open = cumsum(t_open);
  T_open = T_open(1:length(T_open)-1); # Last point not in t
  j=[];
  for i = 1:length(T_open)
    j = [j; find(T_open(i)*ones(size(t))==t)];
  endfor
  y_open = y(j,:);
  u_open = u(j,:);

  ## Plots

    gset nokey
    gset format x "%i"
    gset format y "%4.1f"
    gset term fig monochrome portrait fontsize 20 size 20 20 metric \
	     thickness 4
    gset output "${sys}_nppp.fig"

    title("");
    grid;
    xlabel("Time (s)");
    ylabel("u");
    subplot(2,1,2); plot(t,u,'-',  T_open, u_open,"^");  
    grid;
    ylabel("y");
    subplot(2,1,1); plot(t,y,'-', T_open, y_open,"^"); 

endfunction

EOF
}

make_nppp_numpar() {
echo Creating ${nppp_numpar_file}
cat > ${sys}_nppp_numpar.m <<EOF
function [last, ppp_names, par_names, A_u, A_w, w, Q, extras] = ${sys}_nppp_numpar 

## usage:  [last, ppp_names, par_names, A_u, A_w, w, Q, extras] = ${sys}_nppp_numpar ()
##
## 

  ## Last time of run
  last = 10;

  ## Specify basis functions
  A_w = zeros(1,1);
  n_ppp = ${nu};
  A_u = ppp_aug(A_w,laguerre_matrix(n_ppp-1,2.0));

 
  ## Names of ppp parameters
  ppp_names = "";
  for i=1:n_ppp
    name = sprintf("ppp_%i", i);
    ppp_names = [ppp_names; name];
  endfor

  ## Estimated parameters
  par_names = [];

  ## Weights
  Q = ones(${ny},1);

  ## Setpoint
  w = zeros(${ny},1); w(1) = 1;

  ## Set up optional parameters
  extras.criterion = 1e-3;
  extras.emulate_timing = 0;
  extras.max_iterations = 15;
  extras.simulate = 1;
  extras.v =  1e-6;
  extras.verbose = 0;
  extras.visual = 0;

endfunction
EOF
}

make_dat2() {

## Inform user
echo Creating ${dat2_file}

## Use octave to generate the data
octave -q <<EOF
  [last, ppp_names, par_names, A_u, A_w, w, Q, extras] = ${sys}_nppp_numpar;
  [y,u,t] = ${sys}_nppp(last, ppp_names, par_names, A_u, A_w, w, Q, extras);
  data = [t,y,u];
  save -ascii ${dat2_file} data
EOF
}

case ${lang} in
    numpar.m)
        ## Make the numpar stuff
        make_nppp_numpar;
	;;
    m)
        ## Make the code
        make_nppp;
	;;
    dat2|fig)
    ## The dat2 language (output data) & fig file
	make_dat2; 
	;;
    gdat)
        cp ${dat2_file} ${dat2s_file} 
	dat22dat ${sys} ${rep} 
        dat2gdat ${sys} ${rep}
	;;
#    fig)
#	gdat2fig ${sys}_${rep}
#	;;
    ps)
	fig2dev -Leps ${sys}_${rep}.fig > ${sys}_${rep}.ps
	;;

    view)
	echo Viewing ${sys}_${rep}.ps
        gv ${sys}_${rep}.ps&
	;;
    *)
	echo Language ${lang} not supported by ${rep} representation
        exit 3
esac


