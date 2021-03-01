function  structure = R_eqn(name,bond_number,bonds,direction,cr,args, ...
    structure,eqnfile);
% R_eqn - Equation function for a (multi-port) unicausal R component
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  R_eqn
% structure = R_eqn(name,bond_number,bonds,direction,cr,args, ...
%    structure,eqnfile)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.4  1996/09/12 19:28:11  peter
% %% Added defaults (with no constitutive relationship)
% %%
% %% Revision 1.3  1996/09/12 16:40:45  peter
% %% Now does a default (when no constitutive relationship) with a unit
% %% constitutive relationship on each port.
% %%
% %% Revision 1.2  1996/09/12 13:12:04  peter
% %% Removed an fprintf that was a mistake.
% %%
% %% Revision 1.1  1996/09/12 11:00:56  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.

if nargin<8
  eqnfile = 'stdout';
end;


% Find the number of ports
[ports,junk] = size(bonds);


for outport = 1:ports
  outcause = -bonds(outport,1);
  outnumber = bond_number(outport);
  if length(cr)>0
    incause = bonds(:,1);
    inport = 1:ports;
    inbond = bond_number;
  else % default if no cr: unit cr on each port
    incause = bonds(outport,1);
    inport = outport;
    inbond = outnumber;
  end;
  
  eqn =  equation("R",name,cr,args,outnumber,outcause,outport, ...
                               inbond,incause,inport);
  fprintf(eqnfile, '%s',eqn);
end;


