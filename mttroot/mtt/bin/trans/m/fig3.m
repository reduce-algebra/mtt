function first_line = fig3(object,thickness,colour)
% first_line = fig3(object,thickness,colour)
%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Matlab function fig3.m
% Provides the "first line" format for polyines and text objects
% See fig 3 documentation for details
%
% P.J.Gawthrop June 1996
% Copyright (c) P.J.Gawthrop, 1996.

red = 4;
blue = 1;

if (object==2)	%Polyline
  sub_type = 1;
  line_style = 0;

  if nargin<2
    thickness = 3;
  end;

  if nargin<3
    colour = red;
  end;
  
  fill_colour = -1;
  depth = 0;
  pen_style = 0;
  area_fill = -1;
  style_val = 0.0;
  join_style = 0;
  cap_style = 0;
  radius = -1;
  f_arrow = 0;
  b_arrow = 0;
  npoints = 2;
  first_line = [... 
    int2str(object), ' ', ... 
    int2str(sub_type), ' ', ... 
    int2str(line_style), ' ', ...
    int2str(thickness), ' ', ...
    int2str(colour), ' ', ...
    int2str(fill_colour), ' ', ...
    int2str(depth), ' ', ...
    int2str(pen_style), ' ', ...
    int2str(area_fill), ' ', ...
    num2str(style_val), ' ' ...
    int2str(join_style), ' ', ...
    int2str(cap_style), ' ', ...
    int2str(radius), ' ', ...
    int2str(f_arrow), ' ', ...
    int2str(b_arrow), ' ', ...
    int2str(npoints)];
 
elseif (object==4) %text


else
  error('Object must be 2 (polyline) or 4(text)');
end;



