function  structure = FP_eqn(name,bond_number,bonds,direction,cr,args, ...
    structure,eqnfile);
% FP_eqn - equations for FP component
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  FP_eqn
% FP_eqn(name,bond_number,bonds,direction,cr,args, ...
%    structure,eqnfile);



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.2  1998/06/29 09:54:16  peterg
% %% Changed name from ES to FP
% %%
% %% Revision 1.1  1998/06/29 09:53:22  peterg
% %% Initial revision
% %%
% %% Revision 1.3  1998/03/27 10:59:43  peterg
% %% Zapped t_0 again ...
% %%
% %% Revision 1.2  1998/02/25 16:59:56  peterg
% %% Corrected enthalpy-entropy conversion -- use temp on the entropy side.
% %%
% %% Revision 1.1  1998/02/25 15:03:51  peterg
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1997.


if nargin<6
  eqnfile = 'stdout';
end;

% Check that there are exactly two bonds.
ports = 2;
if check_bonds(bonds,ports,'FP')==0
  return
end


% There are 2 ports; extract the information
f_bond = bonds(1,:);
p_bond = bonds(2,:);

% The efforts are the same - but the enthalpy side has relative T
if f_bond(1)==1 %effort imposed on the enthalpy bond 
%  fprintf(eqnfile,'%s := %s + t_0;\n' , ...
  fprintf(eqnfile,'%s := %s;\n' , ...
    varname(name,bond_number(2), 1), ...
    varname(name,bond_number(1), 1) );
else %effort imposed on the entropy bond 
%  fprintf(eqnfile,'%s := %s - t_0;\n' , ...
  fprintf(eqnfile,'%s := %s;\n' , ...
    varname(name,bond_number(1), 1), ...
    varname(name,bond_number(2), 1) );
end;

% The flows need to be converted - use the absolute temp on the
% entropy side
if f_bond(2)==-1 %flow imposed on the enthalpy bond 
  fprintf(eqnfile,'%s := %s/%s;\n' , ...
    varname(name,bond_number(2), -1), ...
    varname(name,bond_number(1), -1), ...
    varname(name,bond_number(2), 1) );
else % flow imposed on the entropy bond 
    fprintf(eqnfile,'%s := %s*%s;\n' , ...
    varname(name,bond_number(1), -1), ...
    varname(name,bond_number(2), -1), ...
    varname(name,bond_number(2), 1) );
end;
