function [bonds,status] = FMR_cause(bonds);

% Causality for Flow-modulated R component

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
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

