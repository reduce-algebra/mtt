function [eqn,insigs,innames] = CI_seqn (comp_type,Name, name, cr, arg, outsig, insigs ,innames)

  ## usage:  [eqn,inbonds] = CI_seqn (Name, cr, arg, outbond, inbonds)
  ##
  ## 
  ## Multi port C's ??

  delim = "__";
  N = mtt_check_sigs (outsig,insigs);

  state_index=3;
  
  i_cause = outsig(2);		# Extract causality

  state_equation=((i_cause==1)&&strcmp(comp_type,"C"))\
      ||((i_cause==-1)&&strcmp(comp_type,"I"));

  ## Create the equation
  if state_equation			# output/state
    LHS = varname(Name, outsig(1,1), state_index);
    RHS = sprintf("MTTx_%s%s%s", Name, delim, name);
    eqn_1 = sprintf("%s := %s;", LHS, RHS);
    
    inports = [1:N]; 
    comp_type_str=sprintf("""%s""", comp_type);
    eqn_2 = equation(comp_type_str,Name,cr,arg,outsig(1),outsig(2),outsig(3),\
	     insigs(:,1),state_index,inports);
    
    eqn = sprintf("%s\n%s", eqn_1, eqn_2);
  else			# state derivative
    RHS = varname(Name, insigs(1,1), insigs(1,2));
    LHS = sprintf("MTTdx_%s%s%s", Name, delim, name);
    eqn = sprintf("%s := %s;", LHS, RHS);
  endif
  
endfunction