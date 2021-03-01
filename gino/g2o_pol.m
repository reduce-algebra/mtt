function o_pol = g2o_pol (g_pol, object)

  ## usage:  o_pol = g2o_pol (g_pol)
  ##
  ## Converts a ginsh polynomial to an octave polynomial
  ## Both o_pol and g_pol are strings
  ## o_pol can be an argument to eval

  if nargin<1
    error("usage:  o_pol = g2o_pol (g_pol)");
  endif
  
  if nargin<2
    object="s";
  endif
  
  g_pol = g_expand(g_pol);
  n = g_degree(g_pol, object);
  n = eval([n,";"]);
  o_pol = "";
  for i=n:-1:0
    pol_i = g_coeff(g_pol,object,int2str(i));
    o_pol = sprintf("%s %s", o_pol, pol_i);
  endfor
  o_pol = sprintf("[%s ];", o_pol);

endfunction