function [bonds,status] = EMTF_cause(bonds);
% EMTF_cause - causality for a modulated TF component
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  EMTF_cause
% [bonds,status] = EMTF_cause(bonds)
% Causality for effort-modulated EMTF 
% At the moment, modulation can NOT be inverted.

%SUMMARY EMTF: effort-modulated transformer
%DESCRIPTION Energy conserving three-port
%DESCRIPTION Ports [1] and [2] as for TF
%DESCRIPTION e_1 = f(f_2); f_1 = f(e_2)
%DESCRIPTION Effort on port[3] modulates the CR


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.

status = -1;

% Check that there are exactly three bonds.
if check_bonds(bonds,3,'EMTF')==0
  return
end

% Extract the bond information
TF_bonds = bonds(1:2,:);
e_3 = bonds(3,1);
f_3 = bonds(3,2);

%Causality of EMTF is same as that of a TF on ports 1 and 2
[TF_bonds,TF_status] = TF_cause(TF_bonds);


% Effort is the modulation - imposed on component.
if e_3==-1 				% Conflict
  mod_status_e = 1;
else 					% Do the rest of the causality
  if e_3==0 				% Set to the fixed causality
    e_3 = 1;
  end;
  mod_status_e = 0;
end;
 
% Zero flow imposed by component.
if f_3==-1 				% Conflict
  mod_status_f = 1;
else 					% Do the rest of the causality
  if f_3==0 				% Set to the fixed causality
    f_3 = 1;
  end;
  mod_status_f = 0;
end;
 
bonds = [TF_bonds
         e_3 f_3];
	
if (TF_status == 0) & (mod_status_e == 0) & (mod_status_f == 0)
  status = 0;
end;

if (TF_status == 1) | (mod_status_e == 1) | (mod_status_f == 1)
  status = 1;
end;

 
 
 
 
 
   

