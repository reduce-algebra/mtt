function structure =  C_eqn(name,bond_number,bonds,direction,cr,args, ...
    structure,eqnfile);
% C_eqn - equation generation for C component
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  C_eqn
% structure =  C_eqn(name,bond_number,bonds,direction,cr,args, ...
%    structure,eqnfile);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.2  1997/04/09 13:00:28  peterg
% %% *** empty log message ***
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.

			
if nargin<8
  eqnfile = 'stdout';
end;

% Unicausal version
CorI = 1;
structure = cieqn(name,bond_number,bonds,direction,cr,args, structure, \
                 CorI, eqnfile);







