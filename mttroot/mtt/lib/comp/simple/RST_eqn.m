function  structure = RT_eqn(name,bond_number,bonds,direction,cr,args, ...
    structure,eqnfile);
% RT_eqn - equations for flow-modulated resistor
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  RT_eqn
% RT_eqn(name,bond_number,bonds,direction,cr,args, ...
%    structure,eqnfile);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% VeRTion control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  1997/09/03  09:30:45  peterg
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Copyright (c) P.J. Gawthrop, 1997.


if nargin<6
  eqnfile = 'stdout';
end;

% Check that there are exactly two bonds.
ports = 2;
if check_bonds(bonds,ports,'RT')==0
  return
end


% There are 2 ports; extract the information
in_bonds = bonds(1,:);
out_bonds = bonds(2,:);
in_direction = direction(1,:);
out_direction = direction(2,:);

% Do port [in] - a standard resistor -- except for modulation by e_2
structure = R_eqn(name,bond_number(1),in_bonds,in_direction,cr,args, ...
    structure,eqnfile);

% Resistance is multiplied by effort e_1 + e_2 (ie effort on upsteam side of
% the 1 junction)
if in_bonds(1) == 1 % Flow output - divide by e_1+e_2
  fprintf(eqnfile,'%s := %s/(%s+%s);\n' , ...
    varname(name,bond_number(1), -1), ...
    varname(name,bond_number(1), -1), ...
    varname(name,bond_number(1), 1), ...
    varname(name,bond_number(2), 1) );
else
   % Effort output - multiply by e_1+e_2
  fprintf(eqnfile,'%s := %s*(%s+%s);\n' , ...
    varname(name,bond_number(1), 1), ...
    varname(name,bond_number(1), 1), ...
    varname(name,bond_number(1), 1), ...
    varname(name,bond_number(2), 1) );
end;


% Do port [out] - the thermal bit. RT is power conserving.
% This computes f_2 = e_1*f_1/e_2 or  e_2 = e_1*f_1/f_2
fprintf(eqnfile,'%s := %s*%s/%s;\n' , ...
    varname(name,bond_number(2), -out_bonds(1)), ...
    varname(name,bond_number(1),  1), ...
    varname(name,bond_number(1), -1), ...
    varname(name,bond_number(2), out_bonds(1)) );


