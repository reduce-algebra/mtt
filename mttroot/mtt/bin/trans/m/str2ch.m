function ch = str2ch(str,n)
% str2ch - pulls the nth char from a string
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  str2ch.m
% ch = str2ch(str,n)
% Copyright (c) P.J. Gawthrop, 1996.


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  1996/08/30  09:54:44  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
implicit_str_to_num_ok = 1;

astr = abs(str);
if (n>0) &  (n<=length(str)) & (strcmp(str,'')==0)
  ch = setstr(astr(n));
else
  ch = '';
end;















