function write_cbg(system_name,system);

###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
###############################################################


  fid=fopen([system_name,"_cbg.m"], "w");# Open file

  Sformat = "  %s.subsystems.%s.%s = \"%s\";\n";
  PSformat = "  %s.ports.%s.%s = \"%s\";\n";
  Iformat = "  %s.subsystems.%s.%s = %i;\n";
  Cformat = "  %s.subsystems.%s.connections = [";
  PCformat = "  %s.ports.%s.connections = [";
  Bformat = "  %s.bonds = [\n";

  fprintf(fid,"function [%s] =  %s_cbg\n", system_name, system_name);
  
  if struct_contains(system,"ports")
    for [port,name]=system.ports
      fprintf(fid,"\n# Port %s\n", name);
      fprintf(fid,PSformat,system_name,name,"arg",port.arg);
      
      m = length(port.connections);		# Number of connections
      fprintf(fid,PCformat,system_name,name);
      for j=1:m
      	fprintf(fid,"%i ", port.connections(j));
      endfor;
      fprintf(fid,"];\n");
    endfor;
  endif
  
  fprintf(fid,"\n# Components \n");
  if struct_contains(system,"subsystems")
    for [subsystem,name]=system.subsystems
    
      fprintf(fid,"\n# Component %s\n", name);
      fprintf(fid,Sformat,system_name,name,"type",subsystem.type);
      fprintf(fid,Sformat,system_name,name,"cr",subsystem.cr);
      fprintf(fid,Sformat,system_name,name,"arg",subsystem.arg);
      fprintf(fid,Iformat,system_name,name,"repetitions",subsystem.repetitions);
      fprintf(fid,Iformat,system_name,name,"status",subsystem.status);

      m = length(subsystem.connections);		# Number of connections

      fprintf(fid,Cformat,system_name,name);
      for j=1:m
      	fprintf(fid,"%i ", subsystem.connections(j));
      endfor;
      fprintf(fid,"];\n");
    endfor
  endif
  
  

  [N,M]=size(system.bonds);		# Bonds
  fprintf(fid,"\n# Bonds \n");
  fprintf(fid,Bformat,system_name);
  for i=1:N
    fprintf(fid,"      ");
    for j=1:M
      fprintf(fid,"%i ", system.bonds(i,j));
    endfor;
    fprintf(fid,"\n");
  endfor;
  fprintf(fid,"      ];\n");
    
  fprintf(fid,"\n# Aliases \n");
  if struct_contains(system,"alias")
    for [val,key] = system.alias
      fprintf(fid,"%s.alias.%s = \"%s\";\n", system_name,key,val);
    endfor
  endif

  fclose(fid);
  

