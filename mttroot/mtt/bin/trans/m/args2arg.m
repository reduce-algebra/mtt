function arg = args2arg(args,n)
% args2arg - pulls the nth argument from a comma-separated list.
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  args2arg.m
% arg = args2arg(args,n) 
% Copyright (c) P.J. Gawthrop, 1996.


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Field separator
FS = ',';
arg = '';
L = length(args);
args_count = 0;
for i=1:n
  arg_count = 0;
  arg = '';
  if args_count == L
    break;
  end;  
  while args_count < L
    args_count = args_count+1;
    arg_count = arg_count+1;
    ch = args(args_count);
    if ch==FS
      break;
    end;
    arg(arg_count) = ch;
  end;
end;
