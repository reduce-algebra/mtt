function args = alias_args(args,alias,delim,message,FileID)

###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
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
          arg = new_arg;
        end
        SEPS = ",+-*/";
        for j = 1:length(SEPS)
	  if length(findstr(arg,SEPS(j)))>0
	    arg = alias_args(arg,alias,SEPS(j),message,FileID);
	  end 
	end;
        args = sprintf("%s%s%s", args, delim, arg);
      end
      args = substr(args,2); % loose leading ;
    end
  end;
endfunction;
