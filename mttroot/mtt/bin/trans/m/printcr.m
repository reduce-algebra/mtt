function  printcr(name,outport,bond_number,cr,args,RHS_cause,eqnfile)
## printcr - prints cr and arguments
## Assumes that the (multiport) component is unicausal.
## 
##     ###################################### 
##     ##### Model Transformation Tools #####
##     ######################################
## 
## Octave function  printcr
## printcr(name,outport,bond_number,cr,args,RHS_cause,eqnfile


## ###############################################################
## ## Version control history
## ###############################################################
## ## $Id$
## ## $Log$
## ## Revision 1.1  1998/07/25 09:47:43  peterg
## ## Initial revision
## ##
## ###############################################################



  if nargin<7
    eqnfile = "stdout";
  endif

  ## Find the number of ports
  ports = length(RHS_cause);

  ## Print the CR
  if length(cr) == 0 # No CR given - use unity CR
    fprintf(eqnfile, "%s;\n", varname(name,bond_number(outport), \
				      RHS_cause(outport)));
  else # CR exists
    fprintf(eqnfile, "%s(%s", cr, name); # The CR name and component type
    if ports>1 # Multi ports - port no. is first arg of CR
      fprintf(eqnfile, "#1.0f,", outport);
    endif
    fprintf(eqnfile, "%s", args); # Print the arguments
    for port = 1:ports # Print the input causalities and values
      fprintf(eqnfile, "\n\t\t,%s,%s", cause2name(RHS_cause(port)), ...
	      varname(name,bond_number(port), RHS_cause(port)));
    endif
    fprintf(eqnfile, "\n\t\t);\n");
  endif
endfunction


