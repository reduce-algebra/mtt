function  structure = AE_eqn(bond_number,bonds,direction,cr,args, ...
                            structure,eqnfile);
% AE_eqn. Equation generation for effort amplifier.

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<6
  eqnfile = 'stdout';
end;

% There are 2 ports; extract the information
e_1 = bonds(1,1);
f_1 = bonds(1,2);
e_2 = bonds(2,1);
f_2 = bonds(2,2);


% Flow on port 1 is always zero
   fprintf(eqnfile, '%s := 0;\n', ...
      varname(bond_number(1), -1));
  
  
LHS_cause = 1;
RHS_cause = 1;

if e_2 == -1 				% Unicausal: e_2 := e_1
  LHS_number = bond_number(2);
  RHS_number = bond_number(1);
else 	                                % Bicausal: e_1 := e_2      
  LHS_number = bond_number(1);
  RHS_number = bond_number(2);
end

oneeqn(LHS_number,LHS_cause,RHS_number,RHS_cause,cr,args,eqnfile);

 



