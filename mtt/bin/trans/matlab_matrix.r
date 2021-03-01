     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
     %%%%% Model Transformation Tools %%%%%
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Reduce function to write matrices in matlab form
% P.J.Gawthrop  March 1998
% Copyright (c) P.J.Gawthrop, 1998


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % $Id$
% % $Log$
% % Revision 1.1  1998/03/22 10:26:47  peterg
% % Initial revision
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load the general translator package
LOAD GENTRAN;
GENTRANLANG!* := 'FORTRAN;
ON GENTRANSEG;
MAXEXPPRINTLEN!* := 400;

PROCEDURE matlab_Matrix;
BEGIN
  ON NERO;
  write "mtt_matrix = zeros(", mtt_matrix_n, ",", mtt_matrix_m, ");";
  IF MTT_Matrix_n>0 THEN
    IF MTT_Matrix_m>0 THEN
    BEGIN
    FOR i := 1:MTT_Matrix_n DO
      IF MTT_Matrix_m>1 THEN
        BEGIN
          FOR j := 1:MTT_Matrix_m DO 
            GENTRAN mtt_matrix(i,j) ::=: mtt_matrix(i,j);
        END
        ELSE
        BEGIN
         GENTRAN mtt_matrix(i) ::=: mtt_matrix(i,1);
        END;
    END;
  write MTT_matrix_name, " = mtt_matrix;";
END;

END;;


