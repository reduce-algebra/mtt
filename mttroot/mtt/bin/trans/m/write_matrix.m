function write_matrix(matrix,name);

% Writes the matrix function file

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  1996/08/14 08:21:27  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


filename = [name, '.m'];
filenum = fopen(filename,'w');

% Write the function m-file for the causal bond graph
pc = '%';
fprintf(filenum, 'function data = %s\n', name);
fprintf(filenum, '%s m = %s\n\n', pc, name);

fprintf(filename, 'm = [\n');

[N,M] = size(matrix);
for i = 1:N,
  for j = 1:M
    fprintf(filename, '%g', matrix(i,j));
    if j<M
      fprintf(filename, '\t');
    end
  end;
  fprintf(filename, '\n');
end;

fprintf(filename, '];\n');
fprintf(filename, '\n');

fclose(filenum);


