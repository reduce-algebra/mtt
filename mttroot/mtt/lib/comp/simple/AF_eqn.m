function  structure = AF_eqn(name,bond_number,bonds,direction,cr,args, ...
    structure,eqnfile);
% AF_eqn - equations for flow amplifier
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  AF_eqn
% structure = AF_eqn(bond_number,bonds,direction,cr,args, ...
%    structure,eqnfile);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  1996/08/30 18:38:57  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.

if nargin<6
  eqnfile = 'stdout';
end;

% Check that there are exactly two bonds.
if check_bonds(bonds,2,'AF')==0
  return
end

% There are 2 ports; extract the information
e_1 = bonds(1,1);
f_1 = bonds(1,2);
e_2 = bonds(2,1);
f_2 = bonds(2,2);

% Effort on port 1 is always zero
   fprintf(eqnfile, '%s := 0;\n', ...
      varname(name,bond_number(1), 1));
  
outcause = -1;
incause = -1;

if f_2 == 1 				% Unicausal: f_2 := f_1
  outnumber = bond_number(2);
  innumber = bond_number(1);
else 	                                % Bicausal: f_1 := f_2      
  outnumber = bond_number(1);
  innumber = bond_number(2);
end

% $$$ oneeqn(name,outnumber,outcause,innumber,incause,cr,args,eqnfile);
eqn =  equation(name,cr,args,outbond,outcause,outport, ...
                             inbond,incause,inport);
fprintf(eqnfile, '%s',eqn);







