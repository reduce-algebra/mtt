     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
     %%%%% Model Transformation Tools %%%%%
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Reduce function to write matrices in latex form
% P.J.Gawthrop  January 22 1998
% Copyright (c) P.J.Gawthrop, 1998

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Version control history
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% $Id$
%% $Log$
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


PROCEDURE Latex_Matrix;
BEGIN
  IF MTT_Matrix_n>0 THEN
    IF MTT_Matrix_m>0 THEN
    BEGIN
      write "\begin{equation}";
      write MTT_Matrix_name, " = \begin{pmatrix}";
      FOR Row := 1:MTT_Matrix_n DO
      BEGIN
        FOR Col := 1:MTT_Matrix_m DO
        BEGIN
          write "{", MTT_Matrix(Row,Col), "}";
          IF Col<MTT_Matrix_m THEN Write "&"
        END;

	IF Row<MTT_Matrix_n THEN Write "\cr";
      END;
      write "\end{pmatrix}";
      write "\end{equation}";
    END;
END;

END;;