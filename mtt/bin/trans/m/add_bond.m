function comp_list = add_bond(comp_list,bond_number,comp_number);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Adds a new bond entry to a list of components -- pads the list appropriately.

[N,M] = size(comp_list);
if M==0
  M=1;
end;

if comp_number>N % Pad with zeros
  comp_list = [comp_list;zeros(comp_number-N,M)];
end;

this_comp = [nozeros(comp_list(comp_number,:)), bond_number];

L = length(this_comp);

[N,M] = size(comp_list);

if L<M %pad new row with zeros
  comp_list(comp_number,:) = [this_comp, zeros(1,M-L)];
elseif L>M %pad matrix with zeros and insert new row
  comp_list = [comp_list zeros(N,L-M)];
  comp_list(comp_number,:) = this_comp;
else %Sizes match so just insert
  comp_list(comp_number,:) = this_comp;
end;
