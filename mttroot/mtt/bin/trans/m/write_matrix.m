function write_matrix(matrix,name);

% Writes the matrix function file

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
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
    fprintf(filename, '\t%g', matrix(i,j));
  end;
  fprintf(filename, '\n');
end;

fprintf(filename, '];\n');
fprintf(filename, '\n');

fclose(filenum);


