function [eqn,insigs,innames] = SS_seqn (Name, name, cr, arg, outsig, insigs,innames)

  ## usage:  [eqn,inbonds] = SS_seqn (Name, cr, arg, outbond, inbonds)
  ##
  ## 
  ## Multi port SS's ??

  delim = "__";
  N = mtt_check_sigs (outsig,insigs);

  full_name = sprintf("%s%s%s", Name,delim,name);

  ## Get the special attibutes for SS
  attrib_name = split(arg,",");
  [N_a,M_a]=size(attrib_name);
  if (N_a~=2)		# Must have 2 arguments
    mtt_error(sprintf("SS should have 2 args not %i", N_a));
  end;

  effort_attribute = deblank(attrib_name(1,:));
  flow_attribute   = deblank(attrib_name(2,:));

  ## Default attributes
  if strcmp(effort_attribute,"")
    effort_attribute = "external";
  end;
  
  if strcmp(flow_attribute,"")
    flow_attribute = "external";
  end;


  if mtt_is_external("SS",outsig,insigs) # Source
    if outsig(2)==1		# effort output.
      attribute = effort_attribute;
    else
      attribute = flow_attribute;
    endif

    ## Create the equation
    LHS = varname(Name, outsig(1,1), outsig(1,2));
    RHS = Source_seqn (attribute,full_name);
    eqn = sprintf("%s := %s;", LHS, RHS);
  else				# Sensor
   if insigs(1,2)==1		# effort output.
     attribute = effort_attribute;
   else
     attribute = flow_attribute;
   endif

   ## Create the equation
   LHS = Sensor_seqn (attribute,full_name);
   RHS = varname(Name, insigs(1,1), insigs(1,2));
   eqn = sprintf("%s := %s;", LHS, RHS);
 endif
 

endfunction