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
%% Revision 1.7  2000/11/02 14:28:08  peterg
%% and up to 10 ...
%%
%% Revision 1.6  2000/10/10 21:02:42  peterg
%% *** empty log message ***
%%
%% Revision 1.5  2000/08/09 10:41:39  peterg
%% Changed criterion form 3 to 5
%%
%% Revision 1.4  1998/11/10 14:15:36  peterg
%% Now does matrix style for m<3
%%
%% Revision 1.3  1998/03/14 11:07:09  peterg
%% Removed comma from array subscript
%%
%% Revision 1.2  1998/02/25 22:11:28  peterg
%% Added big matrix version
%%
%% Revision 1.1  1998/01/22 09:59:36  peterg
%% Initial revision
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



PROCEDURE Latex_Matrix;
BEGIN
IF MTT_Matrix_m<10 THEN %% Do matrix style version
BEGIN
  IF MTT_Matrix_n>0 THEN
    IF MTT_Matrix_m>0 THEN
    BEGIN
      write "\begin{equation}";
      write MTT_Matrix_name, " = \begin{matrix}";
      FOR Row := 1:MTT_Matrix_n DO
      BEGIN
        FOR Col := 1:MTT_Matrix_m DO
        BEGIN
          write "{", MTT_Matrix(Row,Col), "}";
          IF Col<MTT_Matrix_m THEN Write "&"
        END;

	IF Row<MTT_Matrix_n THEN Write "\cr";
      END;
      write "\end{matrix}";
      write "\end{equation}";
    END;
END
ELSE  %% write out the elements one-by-one.
  IF MTT_Matrix_n>0 THEN
    IF MTT_Matrix_m>0 THEN
    BEGIN
      FOR Row := 1:MTT_Matrix_n DO
      BEGIN
        FOR Col := 1:MTT_Matrix_m DO
        BEGIN
          MTT_element := MTT_Matrix(Row,Col);
          IF MTT_element NEQ 0 THEN
          BEGIN
            write "\begin{equation}";
            write MTT_Matrix_name, "_", Row, Col, " = {", MTT_element, "}\cr";
            write "\end{equation}";
          END;
        END;
      END;
    END;
END;
END;

END;;
