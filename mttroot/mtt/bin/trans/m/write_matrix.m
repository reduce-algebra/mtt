function write_matrix(matrix,name,extn);

% Writes the matrix function file

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.8  2004/09/12 22:27:27  geraint
% %% Appended 't' to fopen mode string to open in text mode.
% %%
% %% Revision 1.7  2002/05/15 16:37:30  gawthrop
% %% Added third argument (file extension)
% %%
% %% Revision 1.6  2000/12/27 16:06:17  peterg
% %% *** empty log message ***
% %%
% %% Revision 1.5  1998/02/03 08:40:39  peterg
% %% Fixed a horrible bug -- changed filename -> filenum
% %%
% %% Revision 1.4  1996/08/15  11:56:11  peter
% %% Does complex matrices.
% %%
% %% Revision 1.3  1996/08/14 19:20:41  peter
% %% Fixed output naming bug.
% %%
% %% Revision 1.2  1996/08/14 08:36:52  peter
% %% Puts a tab between columns.
% %%
% %% Revision 1.1  1996/08/14 08:21:27  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargin<3
  extn="m";
endif

filename = sprintf("%s.%s", name, extn);
filenum = fopen(filename,'wt');

% Write the function m-file for the causal bond graph
pc = '%';
fprintf(filenum, 'function data = %s\n', name);
fprintf(filenum, '%s data = %s\n\n', pc, name);

fprintf(filenum, 'data = [\n');

[N,M] = size(matrix);
for row = 1:N
  for col = 1:M
    value = matrix(row,col);
    if is_complex(value)
	fprintf(filenum, '%g*e^(%g*i)', abs(value),angle(value));
    else
	fprintf(filenum, '%g', value);
    end
    if col<M
      fprintf(filenum, '\t');
    end
  end;
  fprintf(filenum, '\n');
end;

fprintf(filenum, '];\n');
fprintf(filenum, '\n');

fclose(filenum);


