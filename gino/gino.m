function res = gino (op,arg1,arg2,arg3)

  ## Gino is the octave interface to ginsh - the GiNaC shell interface.
  ## The simplest way to use gino is via the octave functions  go_fun.
  ## where "fun" is a ginsh function - type gino("??") for a list.
  ## usage:  res = gino (op,arg1,arg2,arg3)
  ## 
  ## Please set default_eval_print_flag = 0
  ##
  ## Part of the gino (ginsh-octave) toolbox
  ## Copyright (C) 2002 by Peter J. Gawthrop

  if nargin<1
    error("usage: gino(op,[arg1,arg2,arg3])p");
  elseif (nargin==1)||(length(arg1)==0)
    go_in = sprintf("%s", op);
  elseif (nargin==2)||(length(arg2)==0)
    go_in = sprintf("%s(%s)", op, arg1);
  elseif (nargin==3)||(length(arg3)==0)
    go_in = sprintf("%s(%s,%s)", op, arg1, arg2);
  elseif (nargin==4)
    go_in = sprintf("%s(%s,%s,%s)", op, arg1, arg2, arg3);
  else
    error("usage: gino(op,[arg1,arg2,arg3]");
  endif

  res = ginsh(go_in);

endfunction