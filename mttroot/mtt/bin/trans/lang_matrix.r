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
% % Revision 1.2  1998/05/23 15:00:27  peterg
% % Removed the name = matrix statement - now done by sed.
% %
% % Revision 1.1  1998/05/23 10:49:25  peterg
% % Initial revision
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



PROCEDURE Lang_Matrix();
BEGIN
  ON NERO;
  IF MTT_Matrix_n>0 THEN
    IF MTT_Matrix_m>0 THEN
    BEGIN
    FOR i := 1:MTT_Matrix_n DO
      FOR j := 1:MTT_Matrix_m DO 
          GENTRAN mtt_matrix(i,j) ::=: mtt_matrix(i,j);
    END;
END;

END;;


