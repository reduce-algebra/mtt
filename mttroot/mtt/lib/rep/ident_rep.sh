#! /bin/sh

## ident_rep.sh
## DIY representation "ident" for mtt
# Copyright (C) 2002 by Peter J. Gawthrop

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
echo Creating ${filename}

cat > ${filename} <<EOF    
function [y,u,t] = ${sys}_ident (last, ppp_names, par_names, A_u, A_w, w, Q, extras)

  ## usage:  [y,u,t] = ${sys}_ident (last, ppp_names, par_names, A_u, A_w, w, Q, extras)
  ##
  ## last      last time in run
  ## ppp_names Column vector of names of ppp params
  ## par_names Column vector of names of estimated params
  ## extras    Structure containing additional info

  ##Sanity check
  if nargin<2
    printf("Usage: [y,u,t] = ${sys}_ident(N, ppp_names[, par_names, extras])\n");
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
  
    ## Do some simulations to check things out
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

    ## Basis functions
    Us = ppp_ustar(A_u,1,t_OL',0,0)';


  if extras.visual		#Show some graphs
    figure(2); 	
    grid; title("Outputs of ${sys}_sim and s${sys}_ssim");
    plot(t_ol,y_ol, '*', t_ppp, y_ppp, '+', t_OL, y_OL, t_PPP, y_PPP);


    figure(3); 	
    grid; title("Basis functions");
    plot(t_OL, Us);

  endif



  ## Do it
  [y,u,t,P,U,t_open,t_ppp,t_est,its_ppp,its_est] \
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
    gset nogrid
    #eval(sprintf("gset xtics %g", simpar.last));
    #gset noytics
    gset format x "%.1f"
    gset format y "%.2f"
    gset term fig monochrome portrait fontsize 20 size 20 20 metric \
	     thickness 4
    gset output "${sys}_ident.fig"

    title("");
    xlabel("Time (s)");
    ylabel("u");
    subplot(2,1,2); plot(t,u,'-',  T_open, u_open,"+");
    #subplot(2,1,2); plot(t,u);   
    ylabel("y");
    subplot(2,1,1); plot(t,y,'-',  T_open, y_open,"+"); 
    #subplot(2,1,1); plot(t,y); 
    oneplot;
    gset term fig monochrome portrait fontsize 20 size 20 10 metric \
	     thickness 4
    gset output "${sys}_ident.basis.fig"
    title("");
    xlabel("Time (s)");
    ylabel("Basis functions");
    plot(t_OL, Us);


    ## Create plot against time
    TTT = [ [0;T_open] [T_open; last] ]';
    TT = TTT(:);

    [n,m] = size(P);
    if m>0
      P = P(1:n-1,:);  # Loose last point
      PP = [];
      for j=1:m
        pp = [P(:,j) P(:,j)]';
        PP = [PP pp(:)];
      endfor

      oneplot;
      gset output "${sys}_ident.par.fig"
      title("");
      xlabel("Time (s)");
      ylabel("Parameters");
      plot(TT,PP);
    endif

    [n,m] = size(U);
    if m>0    oneplot;
      gset output "${sys}_ident.U.fig"
      title("");
      xlabel("Time (s)");
      ylabel("U");
      [n,m] = size(U);
      U = U(1:n-1,:);  # Loose last point
      UU = [];
      for j=1:m
        uu = [U(:,j) U(:,j)]';
        UU = [UU uu(:)];
      endfor
      plot(TT,UU);
    endif

endfunction

EOF
}

make_ident_numpar() {
echo Creating ${ident_numpar_file}
cat > ${sys}_ident_numpar.m <<EOF
function [last, ppp_names, par_names, A_u, A_w, w, Q, extras] = ${sys}_ident_numpar 

## usage:  [last, ppp_names, par_names, A_u, A_w, w, Q, extras] = ${sys}_ident_numpar ()
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
  [last, ppp_names, par_names, A_u, A_w, w, Q, extras] = ${sys}_ident_numpar;
  [y,u,t] = ${sys}_ident(last, ppp_names, par_names, A_u, A_w, w, Q, extras);
  data = [t,y,u];
  save -ascii ${dat2_file} data
EOF
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
    dat2|fig|basis.fig|par.fig|U.fig)
        ## The dat2 language (output data) & fig file
        rm ${sys}_ident*.fig
	make_dat2; 
	;;
    gdat)
        cp ${dat2_file} ${dat2s_file} 
	dat22dat ${sys} ${rep} 
        dat2gdat ${sys} ${rep}
	;;
    ps|basis.ps|par.ps|U.ps)
        figs=`ls ${sys}_ident*.fig | sed -e 's/\.fig//'`
        echo $figs
	for fig in ${figs}; do
            fig2dev -Leps ${fig}.fig > ${fig}.ps
	done
	;;
    view)
	pss=`ls ${sys}_ident*.ps` 
        echo Viewing ${pss}
        for ps in ${pss}; do
          gv ${ps}&
	done
	;;
    *)
	echo Language ${lang} not supported by ${rep} representation
        exit 3
esac


