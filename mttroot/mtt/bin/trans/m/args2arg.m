function arg = args2arg(args,n,FS)
% args2arg - pulls the nth argument from a FS-separated list.
% FS defaults to `;'.
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  args2arg.m
% arg = args2arg(args,n,FS) 
% Copyright (c) P.J. Gawthrop, 1996.


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  1996/08/27  12:50:43  peterg
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Field separator
if nargin<3
  FS = ';';
end;

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
    ch = str2ch(args,args_count);
    if ch==FS
      break;
    end;
    arg = [arg ch];
  end;
end;
