function [bonds,components] = rbg2abg(name,rbonds,rstrokes,rcomponents,port_coord,port_name,infofile)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.12  1997/08/02 19:37:53  peterg
% %% Now uses named ports.
% %%
% %% Revision 1.11  1997/04/29 09:12:37  peterg
% %% Added error message if port label near to >1 bond.
% %%
% %% Revision 1.10  1997/03/17  13:45:42  peterg
% %% Added more error info.
% %%
% %% Revision 1.9  1996/12/31  11:25:57  peterg
% %% Clearer error messages for incorrect ports.
% %%
% %% Revision 1.8  1996/12/04 21:52:39  peterg
% %% Now uses fopen.
% %%
% %% Revision 1.7  1996/11/01 18:01:57  peterg
% %% Rationalised port ordering.
% %% Fixed port bug.
% %%
% %% Revision 1.6  1996/08/25 08:27:14  peter
% %% Now checks ports correctely - I hope.
% %%
% %% Revision 1.5  1996/08/24 19:21:26  peter
% %% More specific error messages.
% %%
% %% Revision 1.4  1996/08/24 18:00:33  peter
% %% Fixed bug with finding ports.
% %%
% %% Revision 1.3  1996/08/09 08:26:35  peter
% %% Cosmetic tidy up.
% %%
% %% Revision 1.2  1996/08/04 18:37:57  peter
% %% Fixed  no causal strokes bug.
% %%
% %% Revision 1.1  1996/08/04 18:30:14  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargin<5
  infofile='stdout';
else
  fnum = fopen(infofile, 'w');
end;

%Default to no components
components = [0];

% Xfig scaling factor
scale = 1200.0/2.54546;

% Rotation matrix
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

% Find the number of ports refered to within the component
[n_ports,columns] = size(port_coord)

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
% col 1 of port_near_bond contains a signed bond number (+ for arrow end)
% col 2  of port_near_bond contains the corresponding port index
for i = 1:n_ports
   near_bond = adjbond(port_coord(i,1:2),arrow_end,other_end);
   [rows,cols]=size(near_bond);
   if rows>1
     error(sprintf ...
	 ("A port is near to more than one bond at coordinates %g,%g\n", ...
	 port_coord(i,1)/scale,  port_coord(i,2)/scale));
   end;

  %The (signed) bond corresponding to the ith port label
  port_bond(i) = near_bond(1)*sign(1.5-near_bond(2));
end;

%We now have the (signed) bond (port_bond(i)) correponding to the
% ith port label within the component 

% Locate the components at the ends of each bond
% col 1 of comp_near_bond contain the component nearest to the arrow end
% col 2 of comp_near_bond contain the component nearest to the other end
for i = 1:n_bonds
  comp_near_bond(i,:) = adjcomp(arrow_end(i,:),other_end(i,:),rcomponents);
end;

%We now have a list (comp_near_bond) of the component(s) at each end
%of each bond


% Produce a list of bonds on each component (within this component) 
%  - sorted if explicit port numbers
for i = 1:n_components    

  %Get component type
  eval(['[comp_type, comp_name] = ', name, '_cmp(i)']);

  %Convert junction names
  if comp_type=='0'
    comp_type = 'zero';
  end

  if comp_type=='1'
    comp_type = 'one';
  end

  %Find the port list for this component
    if exist([comp_type, '_cause'])==0
      eval(['[junk1,junk2,junk3,junk4,junk5,port_list]=', comp_type, '_rbg;']);
    else
      port_list=comp_ports(comp_type);
    end;

  % There are n_comp_bonds bonds on this component with corresponding index
  [index,n_comp_ports] = getindex(comp_near_bond,i);
  
  % Error message in case we need it!
  port_error = sprintf(... 
      'Component at (%1.3f,%1.3f) has inconsistent port numbers', ...
      rcomponents(i,1)/scale, rcomponents(i,2)/scale);

  if index(1,1) ~= 0 % Then its a genuine component 
    
    % Create the signed list of bonds on this component
    one = ones(n_comp_ports,1);
    bond_list = index(:,1); %  bond at component
    bond_end = index(:,2);  % which end of bond at component?
    direction = -sign(bond_end-1.5*one);
    signed_bond_list = bond_list.*direction;

    unsorted_port_list="";
    if n_ports>0 % then there are some numbered ports
      % so find those associated with the bonds on this component.
      k=0; 
      for j = 1:n_comp_ports
	b = signed_bond_list(j); 
	% Find the port label on component end of bond (if any)
	[port_index,m] = getindex(port_bond,b);
	if m==1
	  k=k+1;
	  unsorted_port_list(k,:) = port_name(port_index,:);
	  end;
      end;
     
      %Either all or non ports should be labelled - write error
      %message if this is not so
      if (k~=0)&(k~=n_comp_ports)
        mtt_info(['Component ', comp_name, ' (', comp_type, ') has wrong number of labels'], infofile); 
        mtt_info(sprintf("\tit has %1.0f labels but should have 0 or %1.0f",k,n_comp_ports), infofile); 
      end;

      [n_unsorted_ports,m_unsorted_ports] = size(unsorted_port_list);
      if m_unsorted_ports<2
        n_unsorted_ports = 0;
      end;

      unsorted_port_list


      % One port defaults:
      if n_comp_ports==1
        if n_unsorted_ports==0
          unsorted_port_list(1,:) = port_list(1,:);
        end; 
      end;
      
      % Junctions (order of ports unimportant)
      if (comp_type=='zero')|(comp_type=='one')
        for j = 1:n_comp_ports
          components(i,j) = signed_bond_list(j);
        end
      else %Order of ports is important
      %Write out the signed bond list in the correct order
        for j = 1:n_comp_ports
          name_k = unsorted_port_list(j,:);
          k = name_in_list(name_k, port_list)
          if k==0
            mtt_info(['Component ', comp_name, ' (', comp_type, ') has an unrecognised port: ', name_k], infofile); 
          else
          components(i,j) = signed_bond_list(k);     
          end;
        end;
      end;
    end;
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
fclose(fnum);




