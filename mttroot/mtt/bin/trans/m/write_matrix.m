function write_matrix(matrix,name);

% Writes the matrix function file

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
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

fprintf(filename, 'data = [\n');

[N,M] = size(matrix);
for row = 1:N
  for col = 1:M
    re = real(matrix(row,col));
    im = imag(matrix(row,col));
    fprintf(filename, '%g', re);
    if im ~= 0
      fprintf(filename, '+ %g*i', im);
    end
    if col<M
      fprintf(filename, '\t');
    end
  end;
  fprintf(filename, '\n');
end;

fprintf(filename, '];\n');
fprintf(filename, '\n');

fclose(filenum);


