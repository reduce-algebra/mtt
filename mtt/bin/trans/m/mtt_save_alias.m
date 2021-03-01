function mtt_save_alias (arg,system_name)

  ## usage:  mtt_save_alias (arg,system_name,FileID)
  ##
  ##
  ##     ###################################### 
  ##     #### Model  Transformation Tools #####
  ##     ######################################

  ## ############################################################### 
  ## Version
  ## control history
  ## ############################################################### ## $Id:
  ## mtt_info.m,v 1.2 1997/02/11 10:06:42 peterg Exp peterg $ ## $Log:
  ## mtt_info.m,v $ ## Revision 1.2  1997/02/11 10:06:42  peterg ##
  ## ###############################################################

  fileid = fopen('mtt_aliased.txt','at');
  fprintf(fileid, "%s\t%s\n", arg,system_name);
  fclose(fileid);
endfunction