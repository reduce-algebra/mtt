function structure =  C_eqn(bond_number,bonds,direction,cr,args, ...
                            structure,eqnfile);
% C_eqn: equation generation for C component


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


			
if nargin<7
  eqnfile = 'stdout';
end;

% Unicausal version
CorI = 1;
structure = cieqn(bond_number,bonds,direction,cr,args, structure, ...
                 CorI, eqnfile);





