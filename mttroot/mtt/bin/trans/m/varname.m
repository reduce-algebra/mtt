function name = varname(name,index,causality);
  ## varname - Creates name of bond graph variable
  ## Usage: name = varname(name,index,causality);
 
##     ###################################### 
##     ##### Model Transformation Tools #####
##     ######################################
## 
## Matlab function  varname.m
## Copyright (C) 1994-2003 by Peter J. Gawthrop


# ###############################################################
# ## Version control history
# ###############################################################
# ## $Id$
# ## $Log$
# ## Revision 1.4  2003/03/24 09:09:52  gawthrop
# ## Reformated to octave standard
# ## Now writes variables in non-matrix form
# ##
# ## Revision 1.3  2003/03/13 14:22:34  gawthrop
# ## No negative bond numbers
# ##
# ## Revision 1.2  2000/12/27 16:06:15  peterg
# ## *** empty log message ***
# ##
# ## Revision 1.1  1996/08/27 08:08:44  peterg
# ## Initial revision
# ##
# ###############################################################


# # bond_name = [name,'_bond'];
# # name =sprintf('%s%1.0f_%s', bond_name, index, cause2name(causality));

# # bond_name = [name,'('];
# # name =sprintf('%s(%1.0f,%1.0f)', name, abs(index), cause2num(causality));

  name =sprintf('%s_%i_%s', name, abs(index), cause2name(causality));

endfunction
