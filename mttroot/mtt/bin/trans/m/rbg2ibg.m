## -*-octave-*-

function [bonds] = \
      rbg2ibg(name,rbonds,rstrokes,rcomponents,port_coord,port_name, \
	      infofile, errorfile)

  rbonds
  rstrokes
  rcomponents
  port_coord
  port_name

  ## Default to no components
  components = [0];

  ## Xfig scaling factor
  scale = 1200.0/2.54546;

  ## Rotation matrix
  rot = [0, -1; 1, 0];

  ## Find number of strokes
  [n_strokes,columns] = size(rstrokes);
  if ((columns ~= 4) & (n_strokes > 0))
    error('Incorrect rstrokes matrix: must have 4 columns');
  endif

  ## Find number of bonds
  [n_bonds,columns] = size(rbonds);
  if ((columns ~= 6) & (n_bonds > 0))
    error('Incorrect rbonds matrix: must have 6 columns');
  endif

  ## Find number of components
  [n_components,columns] = size(rcomponents);

  ## Find number of ports referred to
  [n_ports,columns] = size(port_coord);
  
  ## If port_name empty, make it empty string
  if (length(port_name) == 0)
    port_name="";
  endif
  
  ## Determine coordinates of arrow end of bond and other end
  other_end_1	= rbonds(:,1:2);
  arrow_end	= rbonds(:,3:4);
  other_end_2	= rbonds(:,5:6);

  distance_1	= length2d(other_end_1 - arrow_end);
  distance_2	= length2d(other_end_2 - arrow_end);
  which_end	= (distance_1 > distance_2) * [1, 1];
  one		= ones(size(which_end));
  other_end	= which_end .* other_end_1 + (one - which_end) .* \
      other_end_2;
  arrow_vector	= (which_end .* other_end_2 + (one - which_end) .* \
		   other_end_1) - arrow_end;
  
  ## Locate bond end nearest each port
  ## col 1 of port_near_bond contains a signed bond number (+ for arrow
  ## end)
  ## col 2 of port_near_bond contains the corresponding port index
  port_bond = [];
  for i = 1:n_ports
    near_bond = adjbond(port_coord(i,1:2), arrow_end, other_end);
    [rows,cols] = size(near_bond);
    if (rows > 1)
      error(sprintf ...
	    ("A port is near to more than one bond at coordinates \
	  %g,%g %s\n", ...
	     port_coord(i,1)/scale, port_coord(i,2)/scale, \
	     deblank(port_name(i,:))));
    endif
    
    ## The (signed) bond corresponding to the ith port label
    port_bond(i) = near_bond(1) * sign(1.5 - near_bond(2));
  endfor
  port_bond

  ## Now have (signed) bond (port_bond(i)) corresponding to the ith port
  ## Create inverse mapping
  for i = 1:n_bonds
    eval(sprintf('bond_port_head%i = "[]"', i))
    eval(sprintf('bond_port_tail%i = "[]"', i))
  endfor  
  for i = 1:n_ports
    if (port_bond(i) > 0)
      eval(sprintf('bond_port_head%i = "%s"', port_bond(i), \
		   deblank(port_name(i,:))))
    else
      eval(sprintf('bond_port_tail%i = "%s"', -port_bond(i), \
		   deblank(port_name(i,:))))
    endif
  endfor
  
  ## Locate the components at the ends of each bond
  ## col 1 of comp_near_bond contains component nearest to the arrow end
  ## col 2 of comp_near_bond contains component nearest other end
  for i = 1:n_bonds
    comp_near_bond(i,:) = adjcomp(arrow_end(i,:), other_end(i,:), \
				  rcomponents);
  endfor
  comp_near_bond

  ## Deduce causality from the strokes (if any)
  causality = zeros(n_bonds,2);
  if (n_strokes > 0)
    ## Find location of centre and ends of stroke
    stroke_end_1	= [rstrokes(:,1), rstrokes(:,2)];
    stroke_end_2	= [rstrokes(:,3), rstrokes(:,4)];

    stroke_centre	= (stroke_end_1 + stroke_end_2)/2;
    stroke_vector	= (stroke_end_1 - stroke_end_2);
    stroke_length	= length2d(stroke_vector);

    for i = 1:n_strokes
      stroke = [stroke_centre(i,:)
		stroke_end_1(i,:)
		stroke_end_2(i,:)];


      ## Find the nearest bond end
      [index,distance] = adjbond(stroke(1,:),arrow_end,other_end);
      if (distance > (2 * stroke_length(i)))
	info = sprintf('Stroke at (%4.3f,%4.3f) is %4.3f away from the nearest bond\n', ...
		       stroke(1,1)/scale, stroke(1,2)/scale, \
		       distance/scale);
      endif

      ## Bond end coordinates
      j = index(1,1);
      which_end = (index(1,2) == 1);
      bond_end = arrow_end(j,:) * which_end + other_end(j,:) * (1 - \
								which_end);
      
      ## Now decide which bit of the stroke is nearest
      stroke_index = adjbond(bond_end, stroke, zeros(size(stroke)));

      if (stroke_index(1) == 1)	# uni-causal stroke
	causality(j,1:2) = (2 * which_end - 1) * [1, 1];
      else			# bi-causal stroke
	stroke_direction = stroke(1,:) - stroke(stroke_index(1),:);
	flow_side = stroke_direction * arrow_vector(j,:)' > 0;
	causality(j,1+flow_side) = 2 * which_end - 1;
      endif
    endfor
  endif
  causality

  ## Write data
  for i = 1:n_bonds
    [hc_type, hc_name] = eval([name, '_cmp(comp_near_bond(i,1))']);
    [tc_type, tc_name] = eval([name, '_cmp(comp_near_bond(i,2))']);
    ## components
    eval(sprintf("bonds.bond%i.head.component\t= '%s:%s'", i, hc_type, \
		 hc_name));
    eval(sprintf("bonds.bond%i.tail.component\t= '%s:%s'", i, tc_type, \
		 tc_name));
    ## ports
    eval(sprintf("bonds.bond%i.head.ports\t= bond_port_head%i", i, i));
    eval(sprintf("bonds.bond%i.tail.ports\t= bond_port_tail%i", i, i));
    ## causality
    if (causality(i,1) == 1)
      effort_causality = "head"
    elseif (causality(i,1) == -1)
      effort_causality = "tail"
    else
      effort_causality = "none"
    endif

    if (causality(i,2) == 1)
      flow_causality = "tail"
    elseif (causality(i,2) == -1)
      flow_causality = "head"
    else
      flow_causality = "none"
    endif
    
    eval(sprintf("bonds.bond%i.causality.effort\t= '%s'", i, effort_causality));
    eval(sprintf("bonds.bond%i.causality.flow\t= '%s'", i, flow_causality));
  endfor

endfunction