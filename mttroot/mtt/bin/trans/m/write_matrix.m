function write_matrix(matrix,name);

% Writes the matrix function file

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
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


filename = [name, '.m'];
filenum = fopen(filename,'w');

% Write the function m-file for the causal bond graph
pc = '%';
fprintf(filenum, 'function data = %s\n', name);
fprintf(filenum, '%s data = %s\n\n', pc, name);

fprintf(filenum, 'data = [\n');

[N,M] = size(matrix);
for row = 1:N
  for col = 1:M
    re = real(matrix(row,col));
    im = imag(matrix(row,col));
    fprintf(filenum, '%g', re);
    if im ~= 0
      fprintf(filenum, '+ %g*i', im);
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


