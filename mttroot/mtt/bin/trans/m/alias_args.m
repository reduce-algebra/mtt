function args = alias_args(args,alias,delim,message)

###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
###############################################################


  if is_struct(alias)
    if length(args>0)
      Args = split(args,delim); args="";
      [N,M]= size(Args);
      for i=1:N
        arg = deblank(Args(i,:));
        _arg = strrep(arg,",","__");
        if struct_contains(alias,_arg)
          eval(["new_arg = alias.", _arg,";"]);
  	  mtt_info(["Replacing ", arg, "\t by ",\
		    new_arg, message]);
          arg = new_arg;
        end
        OPS = "+-*/";
        for j = 1:length(OPS)
	  if length(findstr(arg,OPS(j)))>0
	    arg = alias_args(arg,alias,OPS(j),message);
	  end 
	end;
        args = sprintf("%s%s%s", args, delim, arg);
      end
      args = substr(args,2); % loose leading ;
    end
  end;
endfunction;

# " for component ", comp_name,\
#		    " (", comp_type,") within ", full_name]);




