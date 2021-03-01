function  structure = EBTF_eqn(name,bond_number,bonds,direction,cr,args, ...
                            structure,eqnfile);

if nargin<8
  eqnfile = 'stdout';
end;

% Check that there are exactly two bonds.
if check_bonds(bonds,2,'EBTF')==0
  return
end

% There are 2 ports; extract the information
e_1 = bonds(1,1);
f_1 = bonds(1,2);
e_2 = bonds(2,1);
f_2 = bonds(2,2);


% Effort -- no equation

% Flow
effort1_name = varname(name,bond_number(1), 1);
effort2_name = varname(name,bond_number(2), 1);
flow1_name = varname(name,bond_number(1), -1);
flow2_name = varname(name,bond_number(2), -1);

if f_1==-1 %Write flow on port 2
  fprintf(eqnfile,'%s := (%s/%s)*%s;\n' , ...
      flow2_name, ...
      effort1_name, ...
      effort2_name, ...
      flow1_name);
else %Write flow on port 1
  fprintf(eqnfile,'%s := (%s/%s)*%s;\n' , ...
      flow1_name, ...
      effort2_name, ...
      effort1_name, ...
      flow2_name);
end;

 









