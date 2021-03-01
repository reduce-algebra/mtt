function [bonds,status] = RS_cause(bonds);
% Causality for RS component

%SUMMARY RS: resistor with entropy generation
%DESCRIPTION Port[in]: a simple one port resistor
%DESCRIPTION Port[out]: thermal power - effort is temperature, flow is entropy flow
%DESCRIPTION Not bicausal (yet)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Copyright (c) P.J. Gawthrop, 1997.

status = -1;

% Check that there are exactly two bonds.
if check_bonds(bonds,2,'RS')==0
  return
end

% There are 2 ports; extract the information
in_bonds = bonds(1,:);
out_bonds = bonds(2,:);

% Port [in] is an ordinary resistor
[in_bonds,in_status] = R_cause(in_bonds); 

% Port [out] has the same causality pattern as an ordinary resistor
[out_bonds,out_status] = R_cause(out_bonds); 

% Reconstruct the bonds
bonds = [in_bonds; out_bonds];

% Generate an overall status
if (in_status==1)|(out_status==1)
  status = 1;
elseif
  (in_status==-1)|(out_status==-1)
  status=-1;
else
  status = 0;
end;


