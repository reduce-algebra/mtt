function  structure = GY_eqn(name,bond_number,bonds,direction,cr,args, ...
    structure,eqnfile);
% GY_eqn - equations for GY component
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  GY_eqn
% structure = GY_eqn(bond_number,bonds,direction,cr,args, ...
%    structure,eqnfile);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  2000/12/28 11:51:06  peterg
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.


if nargin<8
  eqnfile = 'stdout';
end;


% There are 2 ports; extract the information
e_1 = bonds(1,1);
f_1 = bonds(1,2);
e_2 = bonds(2,1);
f_2 = bonds(2,2);


% Effort - flow
if e_1==1
  outbond = bond_number(2);
  inbond =  bond_number(1);
  outport = 2;
  inport = 1;
  outcause = -1;
  incause = 1;
else
  outbond = bond_number(1);
  inbond =  bond_number(2);
  outport = 1;
  inport = 2;
  outcause = 1;
  incause = -1;
end;

eqn =  equation("GY",name,cr,args,outbond,outcause,outport, ...
                             inbond,incause,inport);
fprintf(eqnfile, '%s',eqn);

% Flow-effort
if f_1==-1
  outbond = bond_number(2);
  inbond =  bond_number(1);
  outport = 2;
  inport = 1;
  outcause = 1;
  incause = -1; 
else
  outbond = bond_number(1);
  inbond =  bond_number(2);
  outport = 1;
  inport = 2;
  outcause = -1;
  incause = 1; 
end;

eqn =  equation("GY",name,cr,args,outbond,outcause,outport, ...
                             inbond,incause,inport);
fprintf(eqnfile, '%s',eqn);

