function  structure = TF_eqn(bond_number,bonds,direction,cr,args, ...
                            structure,eqnfile);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

			
if nargin<6
  eqnfile = 'stdout';
end;

% Needs port labels etc...

% Effort
if bonds(1,1)==1
  oneeqn(bond_number(2),1,bond_number(1),1,cr,args,eqnfile);
else
  oneeqn(bond_number(1),1,bond_number(2),1,cr,args,eqnfile);
end;

% Flow
if bonds(1,2)==-1
  oneeqn(bond_number(2),-1,bond_number(1),-1,cr,args,eqnfile);
else
  oneeqn(bond_number(1),-1,bond_number(2),-1,cr,args,eqnfile);
end;
