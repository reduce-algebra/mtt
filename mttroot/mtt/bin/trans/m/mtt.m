function mtt (sys,rep,lang)

  ## usage:  mtt (system[,representation,language])
  ##
  ## Invokes mtt from octave to generate system_representation.language
  ## Ie equivalent to "mtt system representation language" at the shell
  ## Representation and language defualt to "sm" and "m" respectively

  if nargin<2
    rep='sm';
  endif
  
  if nargin<3
    lang='m';
  endif

  filename = sprintf("%s_%s.%s", sys, rep, lang);
  if !exist(filename)
    command = sprintf("mtt -q %s %s %s", sys, rep, lang);
    system(command);
  endif

endfunction