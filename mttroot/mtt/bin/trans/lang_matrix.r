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
    FOR i := 1:MTT_Matrix_n DO
    BEGIN
      IF MTT_Matrix_m>1 THEN
      BEGIN
        FOR j := 1:MTT_Matrix_m DO 
            GENTRAN mtt_matrix(i,j) ::=: mtt_matrix(i,j);
      END
      ELSE
        GENTRAN mtt_matrix(i) ::=: mtt_matrix(i,1);
    END
END;

END;;


