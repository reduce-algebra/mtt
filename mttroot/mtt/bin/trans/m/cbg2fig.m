function cbg2fig(bonds, cbonds, rbonds, ...
                 rcomponents, status, systemname, ...
                 stroke_length, stroke_thickness, stroke_colour, ...
                 comp_font, comp_colour_u, comp_colour_o, ...
                 filename)


	     
%
%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Matlab function  cbg_m2fig
% Causal bond graph:  mfile format to fig file format
% The resultant fig file is the original _abg.fig with
% additional causal strokes superimposed.
%
% P.J.Gawthrop May 1996
% Copyright (c) P.J.Gawthrop, 1996.

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Check sizes
[N_components,Columns] = size(rcomponents);
if (Columns ~= 13)
  error('Incorrect rcomponents matrix: must have 13 columns');
end;
M_components = Columns;


if nargin<7
  stroke_length = 20;
end;

if nargin<8
  stroke_thickness = 2;
end;

if nargin<9
  stroke_colour = 1; %Blue
end;

if nargin<10
  comp_font = 18; %Helvetica bold
end;

if nargin<11
  comp_colour_u = 12; %Green
end;

if nargin<12
  comp_colour_o = 4; %Red
end;

if nargin<13
  filename = 'stdout';
end;


% Rotation matrix
rot = [0 -1; 1 0];


% Determine coordinates of the arrow end of the bond and the other end
% and other geometry
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
bond_vector = (arrow_end - other_end);
unit_bond_vector = bond_vector./(length2d(bond_vector)*[1 1]);
unit_stroke_vector = (rot*unit_bond_vector')';
  
% Get indices of bonds with changed causality
changed_e = bonds(:,1)~=cbonds(:,1);
changed_f = bonds(:,2)~=cbonds(:,2);
changed = changed_e|changed_f;
index_e  = getindex(changed_e,1)';
index_f  = getindex(changed_f,1)';
index  = getindex(changed,1)';

% Print the new strokes in fig format
if index(1,1)>0
  for i = index_e % Do the effort stroke - opp. side to arrow

    if cbonds(i,1)==1 % Stroke at arrow end
      stroke_end_1 = arrow_end(i,:);
    else
      stroke_end_1 = other_end(i,:);
    end;
    
    sig = sign(unit_arrow_vector(i,:)*unit_stroke_vector(i,:)');
    stroke_end_2 = stroke_end_1 - stroke_length*sig*unit_stroke_vector(i,:);
    

    %print the fig3 format firstline spec.
    polyline = 2; 
    firstline = fig3(polyline,stroke_thickness,stroke_colour);
    fprintf(filename, '%s\n', firstline);

    fprintf(filename, '	%4.0f %4.0f %4.0f %4.0f \n', ...
	stroke_end_1(1), stroke_end_1(2), ...
	stroke_end_2(1), stroke_end_2(2) );
  end;

  for i = index_f % Do the flow stroke - same side as arrow

    if cbonds(i,2)==1 % Stroke at arrow end
      stroke_end_1 = arrow_end(i,:);
    else
      stroke_end_1 = other_end(i,:);
    end;
    
    sig = sign(unit_arrow_vector(i,:)*unit_stroke_vector(i,:)');
    stroke_end_2 = stroke_end_1 + stroke_length*sig*unit_stroke_vector(i,:);
    

    %print the fig3 format firstline spec.
    polyline = 2; 
    firstline = fig3(polyline,stroke_thickness,stroke_colour);
    fprintf(filename, '%s\n', firstline);

    fprintf(filename, '	%4.0f %4.0f %4.0f %4.0f \n', ...
	stroke_end_1(1), stroke_end_1(2), ...
	stroke_end_2(1), stroke_end_2(2) );
  end;
end;

% Print all the components - coloured acording to causality.
for i = 1:N_components
  fig_params = rcomponents(i,3:M_components);
  coords = rcomponents(i,1:2);
  
  if status(i)==-1  %Then under causal
    fig_params(3) = comp_colour_u;
    fig_params(6) = comp_font;
  end;

  if status(i)==1  %Then over causal
    fig_params(3) = comp_colour_o;
    fig_params(6) = comp_font;
  end;


  %Now print the component in fig format
  eval(['[comp_type,comp_name] = ', systemname, '_cmp(i);']);
  Terminator = '\\001';   
  for j = 1:length(fig_params)
    fprintf(filename, '%1.0f ', fig_params(j));
  end;
  fprintf(filename, '%1.0f %1.0f ', coords(1), coords(2)); 
  % don't print the auto-numbered labels
  fprintf(filename, '%s:%s%s\n', comp_type, comp_name, Terminator);
  
end;
















