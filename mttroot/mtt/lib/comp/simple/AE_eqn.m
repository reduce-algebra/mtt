function  structure = AE_eqn(name,bond_number,bonds,direction,cr,args, ...
                            structure,eqnfile);
% AE_eqn. Equation generation for effort amplifier.

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.4  1996/09/10 10:10:41  peter
% %% Now uses eqaution.m to format the equation.
% %%
% %% Revision 1.3  1996/08/30 19:03:10  peter
% %% Added argument check.
% %% Added extra name argument.
% %%
% %% Revision 1.2  1996/08/30 13:23:11  peter
% %% Added bond number check
% %%
% %% Revision 1.1  1996/08/22 13:12:34  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<6
  eqnfile = 'stdout';
end;

% Check that there are exactly two bonds.
if check_bonds(bonds,2,'AE')==0
  return
end

% There are 2 ports; extract the information
e_1 = bonds(1,1);
f_1 = bonds(1,2);
e_2 = bonds(2,1);
f_2 = bonds(2,2);


% Flow on port 1 is always zero
   fprintf(eqnfile, '%s := 0;\n', ...
      varname(name,bond_number(1), -1));
  
  
outcause = 1;
incause = 1;

if e_2 == -1 				% Unicausal: e_2 := e_1
  outbond = bond_number(2);
  inbond = bond_number(1);
  outport = 2;
  inport = 1;
else 	                                % Bicausal: e_1 := e_2      
  outbond = bond_number(1);
  inbond = bond_number(2);
  outport = 1;
  inport = 2;
end


eqn =  equation("AE",name,cr,args,outbond,outcause,outport, ...
                             inbond,incause,inport);
fprintf(eqnfile, '%s',eqn);

			  
			  
			  



