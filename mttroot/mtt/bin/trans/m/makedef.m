function makedef(structure,deffile);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.4  1996/08/30  19:42:36  peter
% %% Added newline at end of file.
% %%
% %% Revision 1.3  1996/08/24 15:06:22  peter
% %% Write `END;' at end to please reduce.
% %%
% %% Revision 1.2  1996/08/18 20:05:20  peter
% %% Put unded version control
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



filenum = fopen(deffile,'w');

states = structure(1);
nonstates=structure(2);
inputs=structure(3);
outputs=structure(4);
zero_outputs = structure(5);

pc = '%';
% Declare reduce constants;
fprintf(filenum, 'MTTNx := %1.0f;\n', states);
fprintf(filenum, 'MTTNz := %1.0f;\n', nonstates);
fprintf(filenum, 'MTTNu := %1.0f;\n', inputs);
fprintf(filenum, 'MTTNy := %1.0f;\n', outputs);
fprintf(filenum, 'MTTNyz := %1.0f;\n', zero_outputs);

% Declare reduce matrices
fprintf(filenum, '%s Declare reduce matrices\n', pc);
if states>0
  fprintf(filenum, 'matrix MTTx(%1.0f,1);\n', states);
  fprintf(filenum, 'matrix MTTdx(%1.0f,1);\n', states);
end;
if nonstates>0
  fprintf(filenum, 'matrix MTTz(%1.0f,1);\n', nonstates);
  fprintf(filenum, 'matrix MTTdz(%1.0f,1);\n', nonstates);
end;
if inputs>0
  fprintf(filenum, 'matrix MTTu(%1.0f,1);\n', inputs);
end;
if outputs>0
  fprintf(filenum, 'matrix MTTy(%1.0f,1);\n', outputs);
end;
if zero_outputs>0
  fprintf(filenum, 'matrix MTTyz(%1.0f,1);\n', zero_outputs);
  fprintf(filenum, 'matrix MTTui(%1.0f,1);\n', zero_outputs);
end;

% Make an Nx x Nx unit matrix
if states>0
  fprintf(filenum, 'matrix MTTI(%1.0f,%1.0f);\n', states,states);
  for i = 1:states
    fprintf(filenum, 'MTTI(%1.0f,%1.0f) := 1;\n', i, i);
  end
end;

% Make an Nx/2 x Nx/2 unit matrix
if states>1
  fprintf(filenum, 'matrix MTTIm(%1.0f,%1.0f);\n', states/2,states/2);
  for i = 1:states/2
    fprintf(filenum, 'MTTIM(%1.0f,%1.0f) := 1;\n', i, i);
  end
end;

% Set the y, yz, u, x and dx matrices
fprintf(filenum, '%s Set the y, yz, u and x matrices\n', pc);
for i=1:outputs
  fprintf(filenum, 'MTTy(%1.0f,1) := MTTy%1.0f;\n', i, i);
end;
for i=1:zero_outputs
  fprintf(filenum, 'MTTyz(%1.0f,1) := MTTyz%1.0f;\n', i, i);
  fprintf(filenum, 'MTTui(%1.0f,1) := MTTui%1.0f;\n', i, i);
end;
for i=1:inputs
  fprintf(filenum, 'MTTu(%1.0f,1) := MTTu%1.0f;\n', i, i);
end;
for i=1:states
  fprintf(filenum, 'MTTx(%1.0f,1) := MTTx%1.0f;\n', i, i);
end;
for i=1:nonstates
  fprintf(filenum, 'MTTdz(%1.0f,1) := MTTdz%1.0f;\n', i, i);
end;

fprintf(filenum, 'END;\n');
fclose(filenum);
  