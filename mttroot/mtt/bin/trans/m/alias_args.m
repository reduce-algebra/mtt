function args = alias_args(args,alias,delim,message,FileID,sys_name)

###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
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


  if is_struct(alias)
    if !isempty(args)
      Args = split(args,delim); args="";
      [N,M]= size(Args);
      for i=1:N
        arg = deblank(Args(i,:));
        arg_ = strrep(arg,",","__");
        if struct_contains(alias,arg_)
          eval(["new_arg = alias.", arg_,";"]);
  	  mtt_info(["Replacing ", arg, "\t by ",\
		    new_arg, message],FileID);
  	  mtt_save_alias(arg,sys_name);

          arg = new_arg;
	else
	  mtt_info(["NOT replacing ", arg, message],FileID);
        end
        SEPS = ",+-*/()";
        for j = 1:length(SEPS)
	  if length(findstr(arg,SEPS(j)))>0
	    arg = alias_args(arg,alias,SEPS(j),message,FileID,sys_name);
	  end 
	end;
        args = sprintf("%s%s%s", args, delim, arg);
      end
      args = substr(args,2); % loose leading ;
    end
  end;
endfunction;
