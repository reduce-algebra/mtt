function makedef(structure,deffile);

if nargin<2
  deffile = 'stdout';
end;

states = structure(1);
nonstates=structure(2);
inputs=structure(3);
outputs=structure(4);
zero_outputs = structure(5);

pc = '%';
% Declare reduce constants;
fprintf(deffile, 'MTTNx := %1.0f;\n', states);
fprintf(deffile, 'MTTNz := %1.0f;\n', nonstates);
fprintf(deffile, 'MTTNu := %1.0f;\n', inputs);
fprintf(deffile, 'MTTNy := %1.0f;\n', outputs);
fprintf(deffile, 'MTTNyz := %1.0f;\n', zero_outputs);

% Declare reduce matrices
fprintf(deffile, '%s Declare reduce matrices\n', pc);
if states>0
  fprintf(deffile, 'matrix MTTx(%1.0f,1);\n', states);
  fprintf(deffile, 'matrix MTTdx(%1.0f,1);\n', states);
end;
if nonstates>0
  fprintf(deffile, 'matrix MTTz(%1.0f,1);\n', nonstates);
  fprintf(deffile, 'matrix MTTdz(%1.0f,1);\n', nonstates);
end;
if inputs>0
  fprintf(deffile, 'matrix MTTu(%1.0f,1);\n', inputs);
end;
if outputs>0
  fprintf(deffile, 'matrix MTTy(%1.0f,1);\n', outputs);
end;
if zero_outputs>0
  fprintf(deffile, 'matrix MTTyz(%1.0f,1);\n', zero_outputs);
  fprintf(deffile, 'matrix MTTui(%1.0f,1);\n', zero_outputs);
end;

% Make an Nx x Nx unit matrix
if states>0
  fprintf(deffile, 'matrix MTTI(%1.0f,%1.0f);\n', states,states);
  for i = 1:states
    fprintf(deffile, 'MTTI(%1.0f,%1.0f) := 1;\n', i, i);
  end
end;

% Set the y, yz, u, x and dx matrices
fprintf(deffile, '%s Set the y, yz, u and x matrices\n', pc);
for i=1:outputs
  fprintf(deffile, 'MTTy(%1.0f,1) := MTTy%1.0f;\n', i, i);
end;
for i=1:zero_outputs
  fprintf(deffile, 'MTTyz(%1.0f,1) := MTTyz%1.0f;\n', i, i);
  fprintf(deffile, 'MTTui(%1.0f,1) := MTTui%1.0f;\n', i, i);
end;
for i=1:inputs
  fprintf(deffile, 'MTTu(%1.0f,1) := MTTu%1.0f;\n', i, i);
end;
for i=1:states
  fprintf(deffile, 'MTTx(%1.0f,1) := MTTx%1.0f;\n', i, i);
end;
for i=1:nonstates
  fprintf(deffile, 'MTTdz(%1.0f,1) := MTTdz%1.0f;\n', i, i);
end;


  