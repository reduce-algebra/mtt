function mtt_info(info, infofile);
  ## mtt_info(info, infofile);

  ## function [bonds, status] = abg2cbg(bonds,components,system_name,filename)
  ## 
  ##     ###################################### 
  ##     ##### Model Transformation Tools #####
  ##     ######################################

  ## ###############################################################
  ## ## Version control history
  ## ###############################################################
  ## ## $Id$
  ## ## $Log$
  ## ## Revision 1.3  2000/11/12 17:10:51  peterg
  ## ## Close file if it is opened
  ## ## Reformated  octave style
  ## ##
  ## ## Revision 1.2  1997/02/11 10:06:42  peterg
  ## ## Removed a debugging line.
  ## ##
  ## ## Revision 1.1  1996/08/18  20:06:57  peter
  ## ## Initial revision
  ## ##
  ## ###############################################################

  ## Set default file if it isn't there already

  if nargin<2
    nofile = 1;
  elseif infofile<0
    nofile = 1;
  else
    nofile = 0;
  endif
  
  if nofile
    infofile = fopen("mtt_info.txt","a");
  end;

  fprintf(infofile, "INFORMATION: %s\n", info);

  if nofile
    fclose(infofile);
  end;

endfunction





