function mtt (sys,rep,lang)

  ## usage:  mtt (system[,representation,language])
  ##
  ## Invokes mtt form octave to generate system_representation.language

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