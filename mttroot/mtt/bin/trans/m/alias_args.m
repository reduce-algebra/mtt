function args = alias_args(args,alias,delim,message,FileID,sys_name)

###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
## Revision 1.8  2001/06/13 16:07:15  gawthrop
## Fixed bug with three separators in a row eg )/(
##
## Revision 1.7  2001/06/13 14:50:15  gawthrop
## Operator ^ now ok in args in abg and/or lbl
##
## Revision 1.6  2001/04/23 16:23:30  gawthrop
## Now stips ; from bottlom level argument list - allows aliasing of
## parts of a,b,c (eg a,b by using a,b;c
##
## Revision 1.5  2000/10/12 19:27:20  peterg
## Now writes out the aliased args ...
##
## Revision 1.4  2000/09/14 13:35:43  peterg
## appended '(' and ')' to SEPS
##   -- otherwise first argument after '(' doesn't get substituted
## (Fixed by Geraint)
##
## Revision 1.3  1998/08/11 14:09:05  peterg
## Replaced incorrect length(args>0) with !isempty(args)
##
## Revision 1.2  1998/07/27 10:24:20  peterg
## Included , in the the list of seperators (SEPS)
## This makes it substitute for bits of args separated by commas.
##
## Revision 1.1  1998/07/03 18:29:40  peterg
## Initial revision
##
###############################################################

  if isstruct(alias)
    if !isempty(args)
      Args = split(args,delim); args="";
      [N,M]= size(Args);
      for i=1:N
        arg = deblank(Args(i,:));
        arg_ = strrep(arg,",","__");
        if isfield(alias,arg_)
          eval(["new_arg = alias.", arg_,";"]);
  	  mtt_info(["Replacing ", arg, "\t by ",\
		    new_arg, message],FileID);
  	  mtt_save_alias(arg,sys_name);
##	  printf("%s --> %s\n",arg,new_arg);
          arg = new_arg;
## 	else
## 	  mtt_info(["NOT replacing ", arg, message],FileID);
        end
        SEPS = ",+-*/()^";
        for j = 1:length(SEPS)
	  if (length(arg)>1)&&(length(findstr(arg,SEPS(j)))>0)
	    arg = alias_args(arg,alias,SEPS(j),message,FileID,sys_name);
	  end 
	end;
        args = sprintf("%s%s%s", args, delim, arg);
      end
      if (length(args)>1)
	if (substr(args,1,1)==delim)
	  args = substr(args,2); # loose leading delimiter
	endif
      endif
      
    end
  end;
endfunction;





