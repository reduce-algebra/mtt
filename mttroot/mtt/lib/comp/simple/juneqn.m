function juneqn(bond_number,bonds,direction,cr,args,jun,eqnfile)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Equations for  both  effort and flow on  either zero or one junctions

if nargin<7
  eqnfile = 'stdout';
end;



% Same causality as junction
column =  (3-jun)/2; 
[causing_bond,n,other_bonds,m] = getindex(bonds(:,column),jun);
for i=other_bonds'
  oneeqn(bond_number(i), jun, bond_number(causing_bond), jun, '', '',eqnfile);
end;


% Opposite causality to junction
column =  (3+jun)/2;
[caused_bond,n,other_bonds,m] = getindex(bonds(:,column),jun);
fprintf(eqnfile, '%s\t:= \n',  varname(bond_number(caused_bond),-jun));
for i=other_bonds'
  term_sign = -direction(caused_bond,column)*direction(i,column);
  fprintf(eqnfile, '\t\t%s %s\n', sign2name(term_sign), ...
      varname(bond_number(i),-jun));
end;
fprintf(eqnfile, ';\n');
