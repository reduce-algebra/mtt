function cbg2fig(system_name, system_type, full_name, ...
                 stroke_length, stroke_thickness, stroke_colour, ...
                 comp_font, comp_colour_u, comp_colour_o)

  ## cbg2fig - converts causal bg to figure
  ##
  ##     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%% Model
  ##     Transformation Tools %%%%%
  ##     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  ##
  ## Matlab function  cbg_m2fig Causal bond graph:  mfile format to fig
  ## file format The resultant fig file is the original _abg.fig with
  ## additional causal strokes superimposed. cbg2fig(system_name, ...
  ## system_type, full_name, ... stroke_length, stroke_thickness,
  ## stroke_colour, ... comp_font, comp_colour_u, comp_colour_o)
  ## Note this uses geometric info from _rbg.fig - so don't use with
  ## -abg switch.  

  ## P.J.Gawthrop May 1996
  ## Copyright (c) P.J.Gawthrop, 1996.

  ## %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  ## %% Version control history
  ## %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  ## %% $Id$
  ## %% $Log$
  ## %% Revision 1.15  2001/03/23 11:20:20  gawthrop
  ## %% Fixed bug with vector components --NB takes geometric info from _rbg.fig
  ## %%
  ## %% Revision 1.14  2000/09/14 12:07:15  peterg
  ## %% Fixed overwriting of ports.
  ## %%
  ## %% Revision 1.13  2000/09/14 09:12:19  peterg
  ## %% Fixed stroke orientation bug with bent bonds
  ## %% Uses new info from the _rbg.m file - 4 new cols in rbonds
  ## %%
  ## %% Revision 1.12  2000/09/14 08:07:00  peterg
  ## %% Reformated as an Octave function
  ## %%
  ## %% Revision 1.11  2000/01/18 14:52:02  peterg
  ## %% Removed recursion --- maybe put back via a flag later
  ## %%
  ## %% Revision 1.10  1998/12/14 15:27:32  peterg
  ## %% Added separate handling of ports ( poss zero)
  ## %%
  ## %% Revision 1.9  1998/08/25 06:43:02  peterg
  ## %% Revised (partially) for data strucures - needs to include graphic info
  ## %% in abg file.
  ## %%
  ## %% Revision 1.8  1998/04/04 10:45:01  peterg
  ## %% Don't do strokes on port bonds
  ## %%
  ## %% Revision 1.7  1997/08/19 09:49:19  peterg
  ## %% Modified to take account of the expanded vector bonds. Only displays
  ## %% causality corresponding to the bond connecting the first element of
  ## %% the vector ports.
  ## %%
  ## %% Revision 1.6  1997/08/19 09:41:47  peterg
  ## %% Some debugging lines added.
  ## %%
  ## %% Revision 1.5  1997/05/16  07:33:45  peterg
  ## %% Now checks to see if sub system is a simple component before
  ## %% recursion.
  ## %% 0 --> zero
  ## %% 1 --> one
  ## %%
  ## %% Revision 1.4  1996/12/07  21:34:52  peterg
  ## %% Tests for null string with strcmp
  ## %% 
  ## %% Revision 1.3  1996/08/08  15:52:28  peter
  ## %% Recursive version.
  ## %% Fails due to octave bug - reported.
  ## %%
  ## %% Revision 1.2  1996/08/05 20:15:39  peter
  ## %% Prepared for recursive version.
  ## %%
  ## %% Revision 1.1  1996/08/05 18:12:25  peter
  ## %% Initial revision
  ## %%
  ## %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


  if nargin<4
    stroke_length = 20;
  end;

  if nargin<5
    stroke_thickness = 2;
  end;

  if nargin<6
    stroke_colour = 1; %Blue
  end;

  if nargin<7
    comp_font = 18; %Helvetica bold
  end;

  if nargin<8
    comp_colour_u = 12; %Green
  end;

  if nargin<9
    comp_colour_o = 4; %Red
  end;

  ## Create a back slash '\' character.
  bs = setstr(92);

  ## Create the (full) system name
  if strcmp(full_name,'')
    full_name = system_name;
  else
    full_name = [full_name, '_', system_name];
  end;

  full_name_type = [full_name, '_', system_type];
  ## $$$ fig_name = [full_name_type, '_cbg.fig'];
  fig_name = [full_name, '_cbg.fig']
  
  ## Return if initial fig file doesn't exist
  if exist(fig_name)~=2
    return
  end;

  ## Setup file - append to the fig file
  filenum = fopen(fig_name, 'a');

  ## Get the raw and the processed bonds
  eval(['[rbonds,rstrokes,rcomponents,port_coord,port_name,port_list] = ', system_type, '_rbg;']);
  eval(["ABG = ", system_type, "_abg;"]);
  bonds=ABG.bonds;

  ## Original number of bonds
  [n_bonds,junk] = size(rbonds);

  ## Get the causal bonds
  #eval(['[cbonds,status]=', full_name, '_cbg;']);
  eval(["CBG = ", full_name, "_cbg;"]);
  cbonds=CBG.bonds;

  ## Check sizes
  [Rows,Columns] = size(rcomponents);
  if (Columns ~= 13)
    error('Incorrect rcomponents matrix: must have 13 columns');
  end;
  M_components = Columns;
  N_rcomponents = Rows;		# Number of raw components

  [N_rports,junk] = size(port_list);
  [N_components, Columns] = size(CBG.subsystemlist); # Number of derived
						     # components

  if struct_contains(CBG,'portlist')
    [N_ports, Columns] = size(CBG.portlist);
  else
    N_ports = 0;
  end


  ## Rotation matrix
  rot = [0 -1; 1 0];


  ## Determine coordinates of the arrow end of the bond and the other end
  ## and other geometry
  other_end_1 = rbonds(:,1:2);
  arrow_end = rbonds(:,3:4);
  other_end_2 = rbonds(:,5:6);

  distance_1 = length2d(other_end_1 - arrow_end);
  distance_2 = length2d(other_end_2 - arrow_end);
  which_end = (distance_1>distance_2)*[1 1];
  one = ones(size(which_end));
  other_end = which_end.*other_end_1 + (one-which_end).*other_end_2;
  arrow_barb = which_end.*other_end_2 + (one-which_end).*other_end_1;
  arrow_vector =  arrow_barb-arrow_end;
  unit_arrow_vector = arrow_vector./(length2d(arrow_vector)*[1 1]);
  
  ## Extract directional information
  arrow_end_direction = [rbonds(:,7), rbonds(:,8)];
  other_end_direction = [rbonds(:,9), rbonds(:,10)];


  ## Get indices of bonds with changed causality -- but ignore the extra bonds
  ## due to vector bond expansion
  changed_e = bonds(1:n_bonds,1)~=cbonds(1:n_bonds,1);
  changed_f = bonds(1:n_bonds,2)~=cbonds(1:n_bonds,2);
  changed = changed_e|changed_f;

  index_e  = getindex(changed_e,1)';
  index_f  = getindex(changed_f,1)';
  index_ef  = getindex(changed,1)';

  ## Print the new strokes in fig format
  if index_ef(1,1)>0
    for i = index_e		# Do the effort stroke - opp. side to arrow
      if cbonds(i,1)==1		# Stroke at arrow end
	bond_vector = arrow_end_direction(i,:); # Directional vector
	stroke_end_1 = arrow_end(i,:);
      else
	bond_vector = other_end_direction(i,:); # Directional vector
	stroke_end_1 = other_end(i,:);
      end;

      ## Work out the direction for the stroke (right angles to bond)
      unit_bond_vector = bond_vector./(length2d(bond_vector)*[1 1]);
      unit_stroke_vector = (rot*unit_bond_vector')';
      
      sig = sign(unit_arrow_vector(i,:)*unit_stroke_vector');
      stroke_end_2 = stroke_end_1 - stroke_length*sig*unit_stroke_vector;
      

      ## print the fig3 format firstline spec.
      polyline = 2; 
      firstline = fig3(polyline,stroke_thickness,stroke_colour);
      fprintf(filenum, '%s\n', firstline);

      fprintf(filenum, '	%4.0f %4.0f %4.0f %4.0f \n', ...
	      stroke_end_1(1), stroke_end_1(2), ...
	      stroke_end_2(1), stroke_end_2(2) );
    end;

    for i = index_f		# Do the flow stroke - same side as arrow
      if cbonds(i,2)==1		# Stroke at arrow end
	bond_vector = arrow_end_direction(i,:); # Directional vector
	stroke_end_1 = arrow_end(i,:);
      else
	bond_vector = other_end_direction(i,:); # Directional vector
	stroke_end_1 = other_end(i,:);
      end;
      
      ## Work out the direction for the stroke (right angles to bond)
      unit_bond_vector = bond_vector./(length2d(bond_vector)*[1 1]);
      unit_stroke_vector = (rot*unit_bond_vector')';
      
      sig = sign(unit_arrow_vector(i,:)*unit_stroke_vector');
      stroke_end_2 = stroke_end_1 + stroke_length*sig*unit_stroke_vector;

      ## print the fig3 format firstline spec.
      polyline = 2; 
      firstline = fig3(polyline,stroke_thickness,stroke_colour);
      fprintf(filenum, '%s\n', firstline);

      fprintf(filenum, '	%4.0f %4.0f %4.0f %4.0f \n', ...
	      stroke_end_1(1), stroke_end_1(2), ...
	      stroke_end_2(1), stroke_end_2(2) );
    end;
  end;

  ## Print all the components - coloured acording to causality.
  ## Miss out the ports
  
  for i = N_rports+1:N_rcomponents
    eval(['[comp_type,comp_name] = ', system_type, '_cmp(i);']);
    eval(["comp_status = CBG.subsystems.", comp_name, ".status;"]);

#     if i>N_rports			# Subsystem
#       comp_name = CBG.subsystemlist(i-N_rports,:);
#       eval(["comp_status = CBG.subsystems.", comp_name, ".status;"]);
#     else
#       comp_name = CBG.portlist(i,:);
#       eval(["comp_status = CBG.ports.", comp_name, ".status;"]);
#     end

    
    fig_params = rcomponents(i,3:M_components);
    coords = rcomponents(i,1:2);
    
    if comp_status==-1		# Then under causal
      fig_params(3) = comp_colour_u;
      fig_params(6) = comp_font;
    end;

    if comp_status==1		# Then over causal
      fig_params(3) = comp_colour_o;
      fig_params(6) = comp_font;
    end;


    ## Now print the component in fig format
    
    if index(comp_name,"mtt")==1 # Its a dummy name
      typename = comp_type;	# just show type
    else
      typename = [comp_type,":",comp_name];
    endif;

    Terminator = [bs, '001'];  
    real_index = 8;
    for j = 1:length(fig_params)
      if j==real_index
	fprintf(filenum, '%2.4f ', fig_params(j));
      else
	fprintf(filenum, '%i ', fig_params(j));
      endif
      

    endfor
    
    

    fprintf(filenum, '%1.0f %1.0f ', coords(1), coords(2)); 
    fprintf(filenum, '%s%s\n', typename, Terminator);

  endfor

  ## Close the file
  fclose(filenum);
  return

endfunction
