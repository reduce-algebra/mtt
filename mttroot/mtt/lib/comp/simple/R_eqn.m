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
  fprintf(eqnfile, '%s\t:= ', varname(name,outnumber, outcause));
  incause = bonds(:,1);
  eqn =  equation(name,cr,args,outnumber,outcause,outport, ...
                               bond_number,incause,1:ports);
  fprintf(eqnfile, '%s',eqn);
end;


