function [bonds,status] = AE_cause(bonds);
% AE_cause - Causality for Flow amplifier component
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  AE_cause
% [bonds,status] = AE_cause(bonds)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.


status = -1;

% Check that there are exactly two bonds.
if check_bonds(bonds,2,'AE')==0
  return
end

% There are 2 ports; extract the information
e_1 = bonds(1,1);
f_1 = bonds(1,2);
e_2 = bonds(2,1);
f_2 = bonds(2,2);

% Port 1 must impose (zero) flow and port 2 have flow imposed
if (f_1==-1)|(f_2==1) % Conflict
  status = 1;
 else 					% Do the rest of the causality

   if f_1 == 0 				% Set port 1 effort
     f_1 = 1;
   end;
   
   if f_2 == 0 				% Set port 2 effort
     f_2 = -1;
   end;
   
   number_set = sum(sum([e_1 e_2]~=zeros(1,2) ));
   if number_set==0 			% Under causal
     status = -1;
   elseif number_set==1 		% Set the causality
     if e_1 == 0
       e_1 = -e_2;
     else
       e_2 = -e_1;
     end
     status = 0;
   elseif number_set==2 		% Check the causality
     if e_1==-e_2
       status = 0;
     else
       status = 1;
     end
 end;
end;
 
 bonds = [e_1 f_1
           e_2 f_2];

