function args_out = subs_arg(args,Args)
% subs_arg - substitutes arguments into args from Args
% FS defaults to `;'.
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  subs_arg.m
% args = subs_arg(args,Args)
% Copyright (c) P.J. Gawthrop, 1996.


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  1996/12/04 21:46:52  peterg
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Symbolic argument sign
S = '$';

args_out = '';
if strcmp(args,'')==0
  L = length(args);
  args_count = 1;
  num_count=0;
  while args_count <= L
    ch = str2ch(args,args_count);
    if ch~=S % copy character
      args_out = [args_out, ch];
      args_count = args_count+1;
    else % find argument number
      args_count = args_count+1;
      ch = str2ch(args,args_count);    
      i=0;
      while (ch>='0') & (ch<='9')
	i = 10*i + abs(ch)-abs('0');
	if args_count==L
	  args_count = args_count+1;
	  break
	end;
	args_count = args_count+1;
	ch = str2ch(args,args_count);
      end;
      args_out = [args_out, args2arg(Args,i)];
    end;
  end;
end;