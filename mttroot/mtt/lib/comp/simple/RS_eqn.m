function  structure = RS_eqn(name,bond_number,bonds,direction,cr,args, ...
    structure,eqnfile);
% RS_eqn - equations for flow-modulated resistor
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  RS_eqn
% RS_eqn(name,bond_number,bonds,direction,cr,args, ...
%    structure,eqnfile);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Copyright (c) P.J. Gawthrop, 1997.


if nargin<6
  eqnfile = 'stdout';
end;

% Check that there are exactly two bonds.
ports = 2;
if check_bonds(bonds,ports,'RS')==0
  return
end


% There are 2 ports; extract the information
in_bonds = bonds(1,:);
out_bonds = bonds(2,:);
in_direction = direction(1,:);
out_direction = direction(2,:);

% Do port [in] - a standard resistor
structure = R_eqn(name,bond_number(1),in_bonds,in_direction,cr,args, ...
    structure,eqnfile);

% Do port [out] - the thermal bit. RS is power conserving.
% This computes f_2 = e_1*f_1/e_2 or  e_2 = e_1*f_1/f_2
fprintf(eqnfile,'%s := %s*%s/%s;\n' , ...
    varname(name,bond_number(2), -out_bonds(1)), ...
    varname(name,bond_number(1),  1), ...
    varname(name,bond_number(1), -1), ...
    varname(name,bond_number(2), out_bonds(1)) );


