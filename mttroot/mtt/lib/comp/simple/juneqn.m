function  juneqn(name,bond_number,bonds,direction,cr,args,jun,filenumber)
% juneqn - Equations for  both  effort and flow on  either 
% zero or one junctions
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  juneqn
% juneqn(name,bond_number,bonds,direction,cr,args,jun,filenumber)

% Copyright (c) P.J. Gawthrop, 1996.

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.2  1996/08/08  18:09:10  peter
% %% Changed to finenumber format.
% %%
% %% Revision 1.1  1996/08/08 16:38:50  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Same causality as junction
column =  (3-jun)/2; 
[causing_bond,n,other_bonds,m] = getindex(bonds(:,column),jun);
for i=other_bonds'
  fprintf(filenumber, '%s \t:=\t%s;\n', ...
      varname(name, bond_number(i),jun), ...
      varname(name, bond_number(causing_bond),jun) ...
  );
end;


% Opposite causality to junction
column =  (3+jun)/2;
[caused_bond,n,other_bonds,m] = getindex(bonds(:,column),jun);
fprintf(filenumber, '%s\t:= \n',  varname(name, bond_number(caused_bond),-jun));
for i=other_bonds'
  term_sign = -direction(caused_bond,column)*direction(i,column);
  fprintf(filenumber, '\t\t%s %s\n', sign2name(term_sign), ...
      varname(name, bond_number(i),-jun));
end;
fprintf(filenumber, ';\n');
