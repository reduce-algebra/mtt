function  structure = ES_eqn(name,bond_number,bonds,direction,cr,args, ...
    structure,eqnfile);
% ES_eqn - equations for ES component
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  ES_eqn
% ES_eqn(name,bond_number,bonds,direction,cr,args, ...
%    structure,eqnfile);



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
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
if check_bonds(bonds,ports,'ES')==0
  return
end


% There are 2 ports; extract the information
e_bond = bonds(1,:);
s_bond = bonds(2,:);

% The efforts are the same - but the enthalpy side has relative T
if e_bond(1)==1 %effort imposed on the enthalpy bond 
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
if e_bond(2)==-1 %flow imposed on the enthalpy bond 
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
