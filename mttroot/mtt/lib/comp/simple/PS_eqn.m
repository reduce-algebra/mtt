function  structure = PS_eqn(name,bond_number,bonds,direction,cr,args, ...
    structure,eqnfile);
% PS_eqn - equations for a power sensor
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  PS_eqn
% PS_eqn(name,bond_number,bonds,direction,cr,args, ...
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

% Check that there are exactly three bonds.
ports = 3;
if check_bonds(bonds,ports,'PS')==0
  return
end


% There are 3 ports; extract the information
inout_bonds = bonds(1:2,:);
power_bonds = bonds(3,:);

inout_direction = direction(1:2,:);
power_direction = direction(3,:);

% Do ports [in] and [out] - unit gain TF.
structure = TF_eqn(name,bond_number(1:2),inout_bonds,inout_direction, ...
'lin','effort,1', structure,eqnfile);

% Do port [power] - the power bit.
% This computes f_2 = e_1*f_1
fprintf(eqnfile,'%s := %s*%s;\n' , ...
    varname(name,bond_number(3), -power_bonds(1)), ...
    varname(name,bond_number(1),  1), ...
    varname(name,bond_number(1), -1) );



