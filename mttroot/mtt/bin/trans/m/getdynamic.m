function [name,prefered] = getdynamic(subsystems);
# Get the index of a dynamic components which is not set.

# ###############################################################
# ## Version control history
# ###############################################################
# ## $Id$
# ## $Log$
# ## Revision 1.2  1996/08/16 12:51:22  peter
# ## Removed debugging lines.
# ##
# ## Revision 1.1  1996/08/16 12:50:41  peter
# ## Initial revision
# ##
# ###############################################################

  prefered = 0;			# No prefered causality to start with
  for [subsystem,name] = subsystems
    if subsystem.status==-1 # Undercausal
      if strcmp(subsystem.type,'C')
      	prefered=-1;
      	break;
      endif;
      if strcmp(subsystem.type,'I')
      	prefered=1;
      	break;
      endif;
    endif;
  endfor;

  if prefered==0
    name = "";
  end;
  
endfunction

