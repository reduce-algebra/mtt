function [bonds,status] = AF_cause(bonds);
% AF_cause - Causality for Flow amplifier component
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  AF_cause
% [bonds,status] = AF_cause(bonds)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.

status = -1;

% Check that there are exactly two bonds.
if check_bonds(bonds,2,'AF')==0
  return
end

% There are 2 ports; extract the information
e_1 = bonds(1,1);
f_1 = bonds(1,2);
e_2 = bonds(2,1);
f_2 = bonds(2,2);

% Port 1 must impose (zero) effort and port 2 have effort imposed
if (e_1==1)|(e_2==-1) % Conflict
  status = 1;
 else 					% Do the rest of the causality

   if e_1 == 0 				% Set port 1 effort
     e_1 = -1;
   end;
   
   if e_2 == 0 				% Set port 2 effort
     e_2 = 1;
   end;
   
   number_set = sum(sum([f_1 f_2]~=zeros(1,2) ));
   if number_set==0 			% Under causal
     status = -1;
   elseif number_set==1 		% Set the causality
     if f_1 == 0
       f_1 = -f_2;
     else
       f_2 = -f_1;
     end
     status = 0;
   elseif number_set==2 		% Check the causality
     if f_1==-f_2
       status = 0;
     else
       status = 1;
     end
 end;
end;
 
 bonds = [e_1 f_1
           e_2 f_2];
