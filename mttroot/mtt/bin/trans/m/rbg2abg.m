function [bonds,components] = rbg2abg(rbonds,rstrokes,rcomponents,rports,infofile)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.2  1996/08/04 18:37:57  peter
% %% Fixed  no causal strokes bug.
% %%
% %% Revision 1.1  1996/08/04 18:30:14  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargin<5
  infofile='stdout';
end;

% Xfig scaling factor
scale = 1200.0;

%Rotation matrix
rot = [0 -1; 1 0];

% Find number of strokes
[n_strokes,columns] = size(rstrokes);
if (columns ~= 4)&(n_strokes>0)
  error('Incorrect rstrokes matrix: must have 4 columns');
end;

% Find number of bonds
[n_bonds,columns] = size(rbonds);
if (columns ~= 6)&(n_bonds>0)
  error('Incorrect rbonds matrix: must have 6 columns');
end;

% Find number of components
[n_components,columns] = size(rcomponents);

% Find number of ports
[n_ports,columns] = size(rports);

% Determine coordinates of the arrow end of the bond and the other end
other_end_1 = rbonds(:,1:2);
arrow_end   = rbonds(:,3:4);
other_end_2 = rbonds(:,5:6);

distance_1   = length2d(other_end_1 - arrow_end);
distance_2   = length2d(other_end_2 - arrow_end);
which_end    = (distance_1>distance_2)*[1 1];
one          = ones(size(which_end));
other_end    = which_end.*other_end_1 + (one-which_end).*other_end_2;
arrow_vector = ( which_end.*other_end_2 + (one-which_end).*other_end_1 ) - ...
    arrow_end;
 
% Locate the bond end nearest to each port
for i = 1:n_ports
  near_bond = adjbond(rports(i,1:2),arrow_end,other_end);
  port_near_bond(i,:) = [near_bond, rports(i,3)];
end;

% Locate the components at the ends of each bond
for i = 1:n_bonds
  comp_near_bond(i,:) = adjcomp(arrow_end(i,:),other_end(i,:),rcomponents);
end;

% Produce a list of bonds on each component - sorted if explicit port numbers
for i = 1:n_components
  [index,n] = getindex(comp_near_bond,i);

  if index(1,1) ~= 0 % Then its a genuine component 
    one = ones(n,1);
    bond_list = index(:,1);
    
    % Default sort of bonds (ie no change)
    sort_index = [1:n]'; 
    
    if n_ports>0
      % Are the component ports numbered? (either they all are or none are)
      k=0;
      for j = 1:n
	[port_index,m] = getindex(port_near_bond(:,1),bond_list(j));
	if m==1 % exactly one number on this bond
	  if index(j,2)==port_near_bond(port_index,2) % same end
	    k=k+1;
	    port_number(k,1) = port_near_bond(port_index,3);
	  end;
	end;
      end;
      
      % Must have a lable for each port or non at all
      if k==n
	[junk,sort_index]=sort(port_number);
      elseif k~=0
	info = sprintf(... 
	    'Component at (%1.3f,%1.3f) has inconsistent port numbers', ...
	    rcomponents(i,1)/scale, rcomponents(i,2)/scale);
	mtt_info(info,infofile);
      end;
    end;
  end;

  % direction is 1 if arrow at component else -1
  direction = -sign(index(:,2)-1.5*one);
  signed_bond_list = bond_list.*direction;
  
  % Write out bond list sorted by port number (if any)
  for j = 1:length(sort_index)
    jj = sort_index(j);
    components(i,j) = signed_bond_list(jj);
  end;
end;

% Deduce causality from the strokes (if any).
causality = zeros(n_bonds,2);
if n_strokes>0
  % Find out location of centre and ends of stroke.
  stroke_end_1 = [rstrokes(:,1) rstrokes(:,2)];
  stroke_end_2 = [rstrokes(:,3) rstrokes(:,4)];
  
  stroke_centre = (stroke_end_1 + stroke_end_2)/2;
  stroke_vector = (stroke_end_1 - stroke_end_2);
  stroke_length = length2d(stroke_vector);

% Deduce bond causality from the strokes 
  for i = 1:n_strokes
    stroke = [stroke_centre(i,:) 
    stroke_end_1(i,:)
    stroke_end_2(i,:)];


    % Find the nearest bond end.
    [index,distance] = adjbond(stroke(1,:),arrow_end,other_end);
    if (distance>2*stroke_length(i))
      info = sprintf('Stroke at (%4.3f,%4.3f) is %4.3f away from the nearest bond\n', ...
	stroke(1,1)/scale, stroke(1,2)/scale, distance/scale);
    end;
  
    % Bond end coordinates
    j = index(1,1);
    which_end = index(1,2)==1;
    bond_end = arrow_end(j,:)*which_end + other_end(j,:)*(1-which_end);
  
    % Now decide which bit of the stroke is nearest
    stroke_index = adjbond(bond_end,stroke,zeros(size(stroke)));
  
    if stroke_index(1)==1 % uni-causal stroke
      causality(j,1:2) = (2*which_end-1)*[1 1];
    else % bicausal stroke
      % Find out whether stroke is on flow side of bond
      stroke_direction = stroke(1,:) - stroke(stroke_index(1),:);
      flow_side = stroke_direction*arrow_vector(j,:)'>0;
      causality(j,1+flow_side) = 2*which_end-1;
    end;
  end;
end;

bonds = causality;
