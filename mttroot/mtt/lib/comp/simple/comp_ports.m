function ports = comp_ports(comp_type,N)
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
% %% Revision 1.7  1998/06/29 12:13:36  peterg
% %% Changed FP ports to f and p
% %%
% %% Revision 1.6  1998/06/29 09:55:17  peterg
% %% Changed name to FP from ES
% %%
% %% Revision 1.5  1998/04/12 15:01:53  peterg
% %% Converted to uniform port notation - always use []
% %%
% %% Revision 1.4  1998/03/31 08:39:31  peterg
% %% Added EBTF
% %%
% %% Revision 1.3  1997/11/21 11:32:57  peterg
% %% N ports numbered 1..N
% %%
% %% Revision 1.2  1997/08/28  08:08:24  peterg
% %% Added RS component to the two-port list
% %%
% %% Revision 1.1  1997/08/02 19:35:47  peterg
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


junctions = '-zero-one-';
one_ports = '-SS-';
two_ports = '-TF-GY-AE-AF-FMR-RS-EBTF-';
N_ports   = '-R-C-I-';
comp_type = ['-', comp_type, '-'];

if length(findstr(comp_type,junctions))==1
  ports = ['[undefined]'];
elseif length(findstr(comp_type,one_ports))==1
  ports = ['[in]'];
elseif length(findstr(comp_type,two_ports))==1
  ports = ['[in]';'[out]'];
elseif length(findstr(comp_type,'[-EMTF-]'))==1
  ports = ['[in]';'[out]';'[mod]'];
elseif length(findstr(comp_type,'[-FP-]'))==1
  ports = ['[p]';'[f]'];
elseif length(findstr(comp_type,'[-PS-]'))==1
  ports = ['[in]';'[out]';'[power]'];
elseif length(findstr(comp_type,N_ports))==1
  if N==1
    ports = ['[in]'];
  elseif N==2
    ports = ['[in]';'[out]'];
  elseif N>2
    ports = '[1]';
    for i=2:N
      ports = [ports; sprintf("[%i]",i)];
    end;
  end;
end;



