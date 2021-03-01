     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
     %%%%% Model Transformation Tools %%%%%
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Reduce function to write matrices in text form
% P.J.Gawthrop  Febrauary 1998
% Copyright (c) P.J.Gawthrop, 1998


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % $Id$
% % $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


PROCEDURE txt_Matrix;
BEGIN
  IF MTT_Matrix_n>0 THEN
    IF MTT_Matrix_m>0 THEN
    BEGIN
    FOR i := 1:MTT_Matrix_n DO
      IF MTT_Matrix_m>1 THEN
        BEGIN
        FOR j := 1:MTT_Matrix_m DO 
          write MTT_Matrix_name, "(", i, ",", j, ") = ",
                                            MTT_Matrix(i,j), ";";
        END
      ELSE
         write MTT_Matrix_name, "(", i, ") = ",
                                            MTT_Matrix(i,1), ";";
    END;
END;

END;;