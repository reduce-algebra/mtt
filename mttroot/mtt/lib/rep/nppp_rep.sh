#! /bin/sh

## nppp_rep.sh
## DIY representation "nppp" for mtt
# Copyright (C) 2002 by Peter J. Gawthrop

sys=$1
rep=nppp
lang=$2

target=${sys}_${rep}.${lang}

## Make the _nppp.m file
make_nppp() {
filename=${sys}_${rep}.m
echo Creating ${filename}

cat > ${filename} <<EOF    
function [y,u,t] = ${sys}_nppp (last, ppp_names, par_names, extras)

  ## usage:  [y,u,t] = ${sys}_nppp (N, ppp_names, par_names, extras)
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
    extras.criterion = 1e-5;
    extras.emulate_timing = 0;
    extras.max_iterations = 10;
    extras.simulate = 1;
    extras.v =  1e-6;
    extras.verbose = 0;
    extras.visual = 0;
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
  w = zeros(n_y,1); w(1) = 1;
  w_s = ones(size(t_horizon))*w';


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
  
  ## Specify basis functions
  A_w = zeros(1,1);
  A_u = ppp_aug(A_w,laguerre_matrix(n_ppp-1,5.0));


  ## Do it
  [y,u,t,p,U,t_open,t_ppp,t_est,its_ppp,its_est] \
      = ppp_nlin_run ("${sys}",i_ppp,i_par,A_u,w_s,N,extras);

  ## Compute values at ends of ol intervals
  T_open = cumsum(t_open);
  T_open = T_open(1:length(T_open)-1); # Last point not in t
  j=[];
  for i = 1:length(T_open)
    j = [j; find(T_open(i)*ones(size(t))==t)];
  endfor
  y_open = y(j,:);
  u_open = u(j,:);

  if extras.visual
    ## Plots
    gset grid; xlabel "Time (sec)"; title "${sys}"
    ty = [t y] ; 
    tu =  [t u]; 
  
    ty_open = [T_open y_open];
    tu_open = [T_open u_open];
  
    gplot  tu \
        title "u", tu_open with impulses title "Sample times"
    figfig("${sys}_u","eps");
  
    gplot  ty \
        title "y", ty_open with impulses title "Sample times"
    figfig("${sys}_y","eps");
  
    system("gv ${sys}_y.eps&");
    system("gv ${sys}_u.eps&");
  endif
endfunction

EOF
}

make_model() {
    
echo "Making sensitivity simulation for system ${sys} (lang ${lang})"

if [ "${lang}" = "oct" ]; then
    oct='-oct'
fi

## System
mtt -q -stdin ${sys} sympar m
mtt -q -stdin ${sys} simpar m
mtt -q -stdin ${oct} ${sys} state ${lang}
mtt -q -stdin ${oct} ${sys} numpar ${lang}
mtt -q -stdin ${oct} ${sys} input ${lang}
mtt -q -stdin ${oct} ${sys} ode2odes ${lang}
mtt -q -stdin ${sys} sim m

## Sensitivity system
mtt -q -stdin -s s${sys} sympar m
mtt -q -stdin -s s${sys} simpar m
mtt -q -stdin ${oct} -s s${sys} state ${lang}
mtt -q -stdin ${oct} -s s${sys} numpar ${lang}
mtt -q -stdin ${oct} -s s${sys} input ${lang}
mtt -q -stdin ${oct} -s s${sys} ode2odes ${lang}
mtt -q -stdin -s s${sys} ssim m

## Additional system reps for PPP
mtt -q -stdin  ${sys} sm m
mtt -q -stdin  ${sys} def m
mtt -q -stdin  -s s${sys} def m

}

## Make the code
make_model;
make_nppp;

