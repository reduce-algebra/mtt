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
  ## ## Revision 1.2  1997/02/11 10:06:42  peterg
  ## ## Removed a debugging line.
  ## ##
  ## ## Revision 1.1  1996/08/18  20:06:57  peter
  ## ## Initial revision
  ## ##
  ## ###############################################################

  ## Set default file if it isn't there already
  if nargin<2
    infofile = fopen("mtt_info.txt","a");
  end;

  fprintf(infofile, "INFORMATION: %s\n", info);

  if nargin<2
    fclose(infofile);
  end;

endfunction





