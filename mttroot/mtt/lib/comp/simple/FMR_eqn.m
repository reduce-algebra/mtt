function  structure = FMR_eqn(name,bond_number,bonds,direction,cr,args, ...
    structure,eqnfile);
% FMR_eqn - equations for flow-modulated resistor
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  FMR_eqn
% FMR_eqn(name,bond_number,bonds,direction,cr,args, ...
%    structure,eqnfile);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  1996/08/30 16:38:25  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.


if nargin<6
  eqnfile = 'stdout';
end;

% Check that there are exactly two bonds.
if check_bonds(bonds,2,'FMR')==0
  return
end


% There are 2 ports; extract the information
e_1 = bonds(1,1);
f_1 = bonds(1,2);
e_2 = bonds(2,1);
f_2 = bonds(2,2);

if f_2 == -1 				% Standard with modulation
  if f_1 == 1 				% Flow out
    op = '*';
  else                                  % Effort out
    op = '/';
  end;
  
  fprintf(eqnfile, '%s := %s%s%s;\n', ...
      varname(name,bond_number(1), -e_1), ...
      varname(name,bond_number(1), e_1), ...
      op, ...
      varname(name,bond_number(2), -1));
else 					% Deduce modulation
  
   fprintf(eqnfile, '%s := %s/%s;\n', ...
      varname(name,bond_number(2), -1), ...
      varname(name,bond_number(1), -1), ...
      varname(name,bond_number(1), 1));
end;

% Effort on port 2 is always zero
   fprintf(eqnfile, '%s := 0;\n', ...
      varname(name,bond_number(2), 1));

 
      


 



