function i_ppp = ppp_ippp (n_ppp,sympar,sympars)

  ## usage:  i_ppp = ppp_ippp (n_ppp,sympar,sympars)
  ## nppp   number of ppp parameters
  ## sympar symbolic parameter structure for system
  ## sympar symbolic parameter structure for sensitivity system
  ## Returns a matrix i_ppp with n_ppp rows and 3 columns
  ## First  col: index of ith ppp parameter of sensitivity system
  ## Second col: index of ith ppp sensitivity parameter of sensitivity system
  ## Third col : index of ith ppp sensitivity parameter of system
  ## Copyright (C) 2002 by Peter J. Gawthrop

  i_ppp = [];
  for i=1:n_ppp
    i_ppp_i = eval(sprintf("[sympars.ppp_%i, sympars.ppp_%is \
			     sympar.ppp_%i];",i,i,i));
    i_ppp = [i_ppp ; i_ppp_i];
  endfor

endfunction