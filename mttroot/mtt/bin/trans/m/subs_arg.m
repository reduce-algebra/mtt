function args_out = subs_arg(args,Args, ...
    default,full_name,comp_type,comp_name,fileID)
% subs_arg - substitutes arguments into args from Args
% FS defaults to `;'.
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  subs_arg.m
% args_out = subs_arg(args,Args,default,comp_type,comp_name,infofile)
% Copyright (c) P.J. Gawthrop, 1996.


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.5  1998/07/21 16:43:26  peterg
% %% Now writes to an explicit fileID - otherwise we may run out of IDs.
% %%
% %% Revision 1.4  1996/12/10 16:04:11  peterg
% %% Changed file handling on mtt_info.
% %%
% %% Revision 1.3  1996/12/07  18:19:39  peterg
% %% Replaces null argument by a default and tells user.
% %%
% %% Revision 1.2  1996/12/04 21:47:41  peterg
% %% Skips main loop when arg is null.
% %%
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
      arg_out = args2arg(Args,i);


      % Test for empty argument -- replace by default and tell user
      message = 'Argument %1.0f of component %s(%s) of system %s is undefined - \n replacing by %s';
      if strcmp(arg_out,'')
	info = sprintf(message, ...
	    i, comp_name, comp_type, full_name, default);
	arg_out = default;
      else
	info = sprintf("Replacing $%i \t by %s for component %s (%s) \
	within %s", i, arg_out, comp_name, comp_type, full_name);
      end;
      mtt_info(info,fileID);
      args_out = [args_out, arg_out];
    end;
  end;
end;
