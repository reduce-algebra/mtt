function list = go_list (exp0,exp1,exp2,exp3,exp4,exp5,exp6,exp7,exp8,exp9)

  ## usage:  list = go_list
  ## (exp0[,exp1,exp2,exp3,exp4,exp5,exp6,exp7,exp8,exp9])
  ## Creates a list containing the expressions in the argument list
  ## 

  ## Copyright (C) 2002 by Peter J. Gawthrop
  if nargin>10
    error("Only 10  expressions allowed in argument list");
  endif

  N = nargin;

  list=exp0;
  for i=1:N-1
    exp = eval(sprintf("exp%i;",i));
    list=sprintf("%s, %s", list, exp);
  endfor

  list = sprintf("{%s}", list);

endfunction