function  structure = TF_eqn(name,bond_number,bonds,direction,cr,args, ...
                            structure,eqnfile);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.2  1996/09/10 10:41:37  peter
% %% Now used equation.m to write the equations.
% %%
% %% Revision 1.1  1996/08/19 09:05:04  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

			
if nargin<8
  eqnfile = 'stdout';
end;

% Check that there are exactly two bonds.
if check_bonds(bonds,2,'TF')==0
  return
end

% There are 2 ports; extract the information
e_1 = bonds(1,1);
f_1 = bonds(1,2);
e_2 = bonds(2,1);
f_2 = bonds(2,2);


% Effort
outcause = 1;
incause = 1;
if e_1==1
  outbond = bond_number(2);
  inbond =  bond_number(1);
  outport = 2;
  inport = 1;
else
  outbond = bond_number(1);
  inbond =  bond_number(2);
  outport = 1;
  inport = 2;
end;

eqn =  equation(name,cr,args,outbond,outcause,outport, ...
                             inbond,incause,inport);
fprintf(eqnfile, '%s',eqn);

% Flow
outcause = -1;
incause = -1;
if f_1==-1
  outbond = bond_number(2);
  inbond =  bond_number(1);
  outport = 2;
  inport = 1;
else
  outbond = bond_number(1);
  inbond =  bond_number(2);
  outport = 1;
  inport = 2;
end;

eqn =  equation(name,cr,args,outbond,outcause,outport, ...
                             inbond,incause,inport);
fprintf(eqnfile, '%s',eqn);








