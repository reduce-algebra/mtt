function ports = comp_ports(comp_type)
%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  comp_ports
% ports = comp_ports(comp_type)
% Returns the port list for simple components


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  1997/08/02 19:35:47  peterg
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


junctions = '-zero-one-';
one_ports = '-SS-R-C-I-';
two_ports = '-TF-GY-AE-AF-FMR-RS-';

comp_type = ['-', comp_type, '-'];

if length(findstr(comp_type,junctions))==1
  ports = ['undefined]'];
elseif length(findstr(comp_type,one_ports))==1
  ports = ['in'];
elseif length(findstr(comp_type,two_ports))==1
  ports = ['in';'out'];
elseif length(findstr(comp_type,'[-EMTF-]'))==1
  ports = ['in';'out';'mod'];
end;




