function [bonds,status] = PS_cause(bonds);
% Causality for PS component

%SUMMARY PS: Power sensor
%DESCRIPTION Port[in]: Inflowing bond
%DESCRIPTION Port[out]: Outflowing bond e_2=e_1; f_2=f_1.
%DESCRIPTION Port[power]: f = power = e_1*f_1 = e_2*f_2


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1997.

status = -1;

% Check that there are exactly three bonds.
if check_bonds(bonds,3,'PS')==0
  return
end

% Do the [in] and [out] ports -- like a TF
inout_bonds = bonds(1:2,:);
[inout_bonds,inout_status] = TF_cause(inout_bonds);

% Do the power port -- must have flow out and effort in
power_bonds = bonds(3,:);
for i = 1:2
  if (power_bonds(i)==1)
    power_status = 0;
  elseif (power_bonds(i)==0)
    power_bonds(i)==1;
    power_status = 0;
  else
    power_status = 1;
  end;
end;


  
  
  
  
% Reconstruct the bonds
bonds = [inout_bonds; power_bonds];

% Generate an overall status
if (inout_status==1)|(power_status==1)
  status = 1;
elseif
  (inout_status==-1)|(power_status==-1)
  status=-1;
else
  status = 0;
end;


