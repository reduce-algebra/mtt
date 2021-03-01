function  mat2mfile(matrix, matrix_name, filenum);
% mat2mfile - writes a matrix as part of an  m-file
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Matlab function  mat2mfile
% mat2mfile(matrix, matrix_name, filenum)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  1996/12/04 21:53:00  peterg
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Copyright (c) P.J. Gawthrop, 1996.

%Writes out a matrix as a matlab m-file

[N, M] = size(matrix);

empty = (N==1)&(M==1)&(matrix(1,1)==0);

%Write out the matrix
fprintf(filenum, '%s = [\n', matrix_name);

if ~empty
  for i = 1:N,
    for j = 1:M
      fprintf(filenum, '%1.0f ', matrix(i,j));
    end;
    fprintf(filenum, '\n');
  end;
else
  fprintf(filenum,'0');
end;
fprintf(filenum, '];\n');
fprintf(filenum, '\n');

