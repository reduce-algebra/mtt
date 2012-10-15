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
  ## Revision 1.2  2003/03/24 12:20:28  gawthrop
  ## *** empty log message ***
  ##
  ## Revision 1.1  2003/03/24 10:19:42  gawthrop
  ## Documentation added
  ##
  ###############################################################

  ## Temporary version to resolve lin only!

  ## How many equations here?
  N = length(findstr(eqn,"="));
  EQNS = char(strsplit(eqn,";"));

  eqn = "";
  for i = 1:N
      
      ## Split equation
      EQN = char(strsplit(EQNS(i,:),":="));
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
    