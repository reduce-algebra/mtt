function  structure = FMR_eqn(name,bond_number,bonds,direction,cr,args, ...
    structure,eqnfile);
% FMR_eqn - equations for flow-modulated resistor
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  FMR_eqn
% FMR_eqn(name,bond_number,bonds,direction,cr,args, ...
%    structure,eqnfile);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.3  1996/09/12 19:30:31  peter
% %% Updated to use new eqaution.m
% %%
% %% Revision 1.2  1996/08/30 18:35:43  peter
% %% New name argument added.
% %%
% %% Revision 1.1  1996/08/30 16:38:25  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.


if nargin<6
  eqnfile = 'stdout';
end;

% Check that there are exactly two bonds.
ports = 2;
if check_bonds(bonds,ports,'FMR')==0
  return
end


% There are 2 ports; extract the information
e_1 = bonds(1,1);
f_1 = bonds(1,2);
e_2 = bonds(2,1);
f_2 = bonds(2,2);

if length(cr)==0  % Then do default unity CR
  if f_2 == -1 				% Standard with modulation
    if f_1 == 1 			% Flow out
      op = '*';
    else                                % Effort out
      op = '/';
    end;
    
    fprintf(eqnfile, '%s := %s%s%s;\n', ...
	varname(name,bond_number(1), -e_1), ...
	varname(name,bond_number(1), e_1), ...
	op, ...
	varname(name,bond_number(2), -1));
  else 					% Deduce modulation
    
    fprintf(eqnfile, '%s := %s/%s;\n', ...
	varname(name,bond_number(2), -1), ...
	varname(name,bond_number(1), -1), ...
	varname(name,bond_number(1), 1));
  end;
else  % write the full works
  if f_2 == -1 				% Standard with modulation
    outport = 1;
    outnumber = bond_number(1);
    if f_1 == 1 			% Flow out
      outcause = -1;
    else                                % Effort out
      outcause = 1;
    end;    
    incause = [-outcause; -1]; % Flow input on port 2
    eqn =  equation("FMR",name,cr,args,outnumber,outcause,outport, ...
                               bond_number,incause,1:ports);
    fprintf(eqnfile, '%s',eqn);

  else % Modulation is output
    outport = 2;
    outcause = -1;
    outnumber = bond_number(2);
    innumber = bond_number(1)*[1;1];    
    incause = [1; -1]; % Effort and flow on port 1
    inports = [1; 1];
    eqn =  equation("FMR",name,cr,args,outnumber,outcause,outport, ...
                               innumber,incause,inports);
    fprintf(eqnfile, '%s',eqn);
  end;
end;

  % Effort on port 2 is always zero
  fprintf(eqnfile, '%s := 0;\n', ...
      varname(name,bond_number(2), 1));

 
      


 



