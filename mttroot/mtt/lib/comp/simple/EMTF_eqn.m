function  structure = EMTF_eqn(name,bond_number,bonds,direction,cr,args, ...
                            structure,eqnfile);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


			
if nargin<8
  eqnfile = 'stdout';
end;

% Check that there are exactly two bonds.
if check_bonds(bonds,3,'EMTF')==0
  return
end

% There are 3 ports; extract the information
e_1 = bonds(1,1);
f_1 = bonds(1,2);
e_2 = bonds(2,1);
f_2 = bonds(2,2);
e_3 = bonds(3,1);


% Effort
outcause = 1;
incause = [1;1];
if e_1==1
  outbond = bond_number(2);
  inbond =  bond_number([1 3]);
  outport = 2;
  inport = [1;3];
else
  outbond = bond_number(1);
  inbond =  bond_number([2 3]);
  outport = 1;
  inport = [2;3];
end;

eqn =  equation(name,cr,args,outbond,outcause,outport, ...
                             inbond,incause,inport);
fprintf(eqnfile, '%s',eqn);

% Flow
outcause = -1;
incause = [-1;1];
if f_1==-1
  outbond = bond_number(2);
  inbond =  bond_number([1 3]);
  outport = 2;
  inport = [1;3];
else
  outbond = bond_number(1);
  inbond =  bond_number([2 3]);
  outport = 1;
  inport = [2;3];
end;

eqn =  equation(name,cr,args,outbond,outcause,outport, ...
                             inbond,incause,inport);
fprintf(eqnfile, '%s',eqn);

% Modulation: flow on port 3 is always zero
  fprintf(eqnfile, '%s := 0;\n', ...
      varname(name,bond_number(3), -1));







