     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
     %%%%% Model Transformation Tools %%%%%
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Reduce function to write matrices in computer - language form
% P.J.Gawthrop  March 1998, May 1988
% Copyright (c) P.J.Gawthrop, 1998



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % $Id$
% % $Log$
% % Revision 1.6  2000/08/25 09:23:40  peterg
% % Made both names the same!
% %
% % Revision 1.5  2000/08/24 17:12:01  peterg
% % Now optimises using SCOPE
% %
% % Revision 1.4  1998/07/27 17:34:59  peterg
% % Sorted syntax errors
% %
% % Revision 1.3  1998/07/27 16:31:10  peterg
% % Sorted out to work with mtt_r2m
% %
% % Revision 1.2  1998/05/23 15:00:27  peterg
% % Removed the name = matrix statement - now done by sed.
% %
% % Revision 1.1  1998/05/23 10:49:25  peterg
% % Initial revision
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



PROCEDURE Lang_Matrix();
BEGIN
    FOR row := 1:MTT_Matrix_n DO
    BEGIN
      IF MTT_Matrix_m>1 THEN
      BEGIN
        FOR col := 1:MTT_Matrix_m DO
        BEGIN
              IF (row EQ 1) AND (col EQ 1) THEN DELAYOPTS;
              INAME(mtt_o); % Set temp name
              gentran declare mtt_matrix_element:REAL;
              gentran declare mtt_matrix:REAL;
              mtt_matrix_element := mtt_matrix(row,col);
              GENTRAN mtt_matrix(row,col) ::=: mtt_matrix_element;
              IF (row EQ MTT_matrix_n) AND (col EQ MTT_Matrix_m) THEN MAKEOPTS;
            END;
      END
      ELSE
        BEGIN
          IF (row EQ 1) THEN DELAYOPTS;
          INAME(mtt_o); % Set temp name
          GENTRAN mtt_matrix(row) ::=: mtt_matrix(row,1);
          IF (row EQ MTT_matrix_n) THEN MAKEOPTS;
        END;
    END
END;

END;;


