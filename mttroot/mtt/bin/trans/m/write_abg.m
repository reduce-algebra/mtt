function write_abg(system_name,bonds,connections);

###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
## Revision 1.1  1998/08/25 06:22:02  peterg
## Initial revision
##
###############################################################


  fid=fopen([system_name,"_abg.m"], "w");
  [N,M]=size(connections);
  Sformat = "  %s.subsystems.%s.%s = \"%s\";\n";
  PSformat = "  %s.ports.%s.%s = \"%s\";\n";
  Iformat = "  %s.subsystems.%s.%s = %i;\n";
  PIformat = "  %s.ports.%s.%s = %i;\n";
  Cformat = "  %s.subsystems.%s.connections = [";
  PCformat = "  %s.ports.%s.connections = [";
  Bformat = "  %s.bonds = [\n";

  fprintf(fid,"function [%s] =  %s_abg\n", system_name, system_name);
  fprintf(fid,"# This function is the acausal bond graph representation of %s\n",system_name);
  fprintf(fid,"# Generated by MTT on %s",ctime(time));
  fprintf(fid,"# The file is in Octave format\n");

  
  fprintf(fid,"\n# Subsystems and Ports\n");
  i_port=0;
  for i=1:N
    eval(["[comp_type, name, cr, arg, repetitions] = ", system_name, "_cmp(i);"]);

    
    if index(name,"[")==0	# Not a port
      fprintf(fid,"\n# Component %s\n", name);
      fprintf(fid,Sformat,system_name,name,"type",comp_type);
      fprintf(fid,Sformat,system_name,name,"cr",cr);
      fprintf(fid,Sformat,system_name,name,"arg",arg);
      fprintf(fid,Iformat,system_name,name,"repetitions",repetitions);

      c = nozeros(connections(i,:));# Connections to this component
      m = length(c);		# Number of connections

      fprintf(fid,Cformat,system_name,name);
      for j=1:m
      	fprintf(fid,"%i ", c(j));
      endfor;
      fprintf(fid,"];\n");
    else
      name=name(2:length(name)-1); # Strip []
      fprintf(fid,"\n# Port %s\n", name); 
      fprintf(fid,PIformat,system_name,name,"index",++i_port);
      fprintf(fid,PSformat,system_name,name,"type",comp_type);
      fprintf(fid,PSformat,system_name,name,"cr",cr);
      fprintf(fid,PSformat,system_name,name,"arg",arg);
      fprintf(fid,PIformat,system_name,name,"repetitions",repetitions);

      c = nozeros(connections(i,:));# Connections to this component
      m = length(c);		# Number of connections

      fprintf(fid,PCformat,system_name,name);
      for j=1:m
      	fprintf(fid,"%i ", c(j));
      endfor;
      fprintf(fid,"];\n");
    endif;
  endfor;

  
  fprintf(fid,"\n# Bonds \n");
  [N,M]=size(bonds);		# Bonds
  fprintf(fid,Bformat,system_name);
  for i=1:N
    fprintf(fid,"      ");
    for j=1:M
      fprintf(fid,"%i ", bonds(i,j));
    endfor;
    fprintf(fid,"\n");
  endfor;
  fprintf(fid,"      ];\n");
    
  fprintf(fid,"\n# Aliases \n");
  fprintf(fid,"# A double underscore __ represents a comma \n");
  eval(["alias = ", system_name, "_alias;"]);
  if is_struct(alias)
    for [val,key] = alias
      fprintf(fid,"%s.alias.%s = \"%s\";\n", system_name,key,val);
    endfor
  endif

  fclose(fid);
  

