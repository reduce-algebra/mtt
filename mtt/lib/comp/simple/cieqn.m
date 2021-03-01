function structure =  cieqn(name, bond_number,bonds,direction,cr,args, ...
    structure,CorI,eqnfile);
% cieqn - Equation function for a (multi-port) unicausal C or I component
% CorI = 1 for C, -1 for I; 0 for ISW

% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  cieqn


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.3  1998/06/29 13:05:08  peterg
% %% Changed cieqn so that sign ignored.
% %%
% %% Revision 1.2  1997/12/04 13:48:00  peterg
% %% Added sign info to take account of direction of bonds.
% %%
% %% Revision 1.1  1997/04/09  10:18:26  peterg
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.

if nargin<8
  eqnfile = 'stdout';
end;

if (CorI==1)
  comp_type = "C";
else
  comp_type = "I";
endif

CorIorISW = CorI;
if CorIorISW==0 % ISW
   CorI = -1;
end;


% Find the number of ports
[ports,junk] = size(bonds);

% Right-hand side causality
RHS_cause = (bonds(:,1)==CorI*ones(ports,1))*CorI
state_cause = zeros(ports,1); % State causality

for outport = 1:ports

#  % Sort out direction
#  if direction(outport,1) == 1
#    sign = '+';
#  else
#    sign = '-';
#  end;

  sign = '+';  
  LHS_number = bond_number(outport);
  if bonds(outport,1) == -CorI % Integral causality on this port
    state = structure(1)+1;
    LHS_cause = CorI;

    % Print equation of form x_i = MTTx(i)
    fprintf(eqnfile, '%s := MTTx(%1.0f,1);\n', ...
        varname(name,LHS_number, state_cause), state);

    % Print equation of form xdot = input - with sign
    fprintf(eqnfile, 'MTTdX(%1.0f,1) := %s%s;\n', state, sign, ...
                     varname(name,LHS_number,-LHS_cause));
    % Print equation of form output = CR (state) 
    eqn =  equation(comp_type,name,cr,args,LHS_number,LHS_cause,outport, ...
                             bond_number,state_cause,1:ports);
    fprintf(eqnfile, '%s',eqn);
    structure(1) = state;
  else % Derivative causality
    nonstate = structure(2)+1;
    LHS_cause = -CorI;

    % Print equation of form zdot = MTTdz(i) -- with sign 
    fprintf(eqnfile, '%s := %sMTTdz(%1.0f,1);\n', ...
                             varname(name,LHS_number,LHS_cause), sign, ...
                             nonstate);
    % Print equation of form MTTz(i) = z_i
    fprintf(eqnfile, 'MTTz(%1.0f,1) := %s;\n', nonstate, ...
             varname(name,LHS_number, state_cause));
				 
   % Print equation of form z_i = CR(input)
      eqn =  equation(comp_type,name,cr,args,LHS_number,state_cause, outport, ...
                             bond_number,RHS_cause,1:ports);
    fprintf(eqnfile, '%s',eqn);
    structure(2) = nonstate;
 end;
end;









