function [bonds,status] = FMR_cause(bonds);

% Causality for Flow-modulated R component

%SUMMARY FMR: flow-modulated resistor
%DESCRIPTION Port[in]: a simple one port resistor
%DESCRIPTION Port[out]: flow provides modulation for the resistor
%DESCRIPTION Used with the lin CR, with parameters flow,r this gives
%DESCRIPTION a resistance r*f_m where f_m is the flow on port [out]
%DESCRIPTION Can be bicausal - deduces modulation from e and f on port[in]

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.3  1996/11/01 11:53:48  peterg
% %% Documentation
% %%
% %% Revision 1.2  1996/08/30 13:29:05  peter
% %% Error check on bond numbers.
% %%
% %% Revision 1.1  1996/08/09 08:28:02  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


status = -1;

% Check that there are exactly two bonds.
if check_bonds(bonds,2,'FMR')==0
  return
end


% There are 2 ports; extract the information
e_1 = bonds(1,1);
f_1 = bonds(1,2);
e_2 = bonds(2,1);
f_2 = bonds(2,2);

% e_2 must be effort causality (imposes zero effort)
 if e_2 == 1 				% Conflict
   status = 1;
 else 					% Do the rest of the causality
   if e_2==0 				% Set to the fixed causality
     e_2 = -1;
   end;
   
   number_set = sum(sum([e_1 f_1 f_2]~=zeros(1,3) ));
   if number_set<2 			% Under causal
     status = -1;
   elseif number_set==2 		% Set the causality
     if f_2 == -1 			% Unicausal
       if e_1 == 0
 	e_1 = f_1;
       else
	 f_1 = e_1;
       end;
     elseif f_2 == 1 			% Bicausal
       e_1 = 1;
       f_1 = -1;
     elseif f_2 == 0
       if e_1==f_1
	 f_2 = -1;                      % Unicausal
       else
	 f_2 = 1;                      % Bicausal
       end;
     end;
     status = 0;
   elseif number_set==3 		% Check the causality
     if ( (f_2==-1)&(e_1~=f_1) )|( (f_2==1)&(e_1==f_1) )
       status = 1;
     else
       status = 0;
     end;
   end;
 end;
 
 bonds = [e_1 f_1
           e_2 f_2];

