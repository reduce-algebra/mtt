function eqn = mtt_resolve_cr (eqn)
  ## usage:  eqn = mtt_resolve_cr (eqn)


  ###################################### 
  ##### Model Transformation Tools #####
  ######################################
  
  ###############################################################
  ## Version control history
  ###############################################################
  ## $Id$
  ## $Log$
  ## Revision 1.2  2001/07/03 22:59:10  gawthrop
  ## Fixed problems with argument passing for CRs
  ##
  ###############################################################

  ## Temporary version to resolve lin only!

  ## How many equations here?
  N = length(findstr(eqn,"="));
  EQNS = split(eqn,";");

  eqn = "";
  for i = 1:N
      
      ## Split equation
      EQN = split(EQNS(i,:),":=");
      LHS = deblank(EQN(1,:));
      RHS = deblank(EQN(2,:));

      if index(RHS,"lin(")>0	# lin cr is here

      RHS = sprintf("%s;", RHS); # Put back ;

      ## Make function into a list
      RHS = strrep(RHS,"lin(","{lin,");
      RHS = strrep(RHS,");","}");

      ## Convert "R" to R etc
      RHS = strrep(RHS,"\"","");
      
      
      RHS = g_subs(RHS, "{{lin,$6,$3,$1,$5,1,$2,$3,1}}", "{$2*$1}");
      RHS = g_subs(RHS, "{{lin,$6,$3,$1,$5,1,$2,$4,1}}", "{$2/$1}");
    endif

    eqn_i = sprintf("%s := %s;", LHS, RHS);
    eqn = sprintf("%s %s", eqn, eqn_i);
  endfor

endfunction
    