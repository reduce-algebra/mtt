PROCEDURE zero_matrix(VAR A : StateMatrix;
			  N : INTEGER);
VAR i,j	:  INTEGER;
   
BEGIN
   FOR i:=1 TO N DO
      FOR j:=1 TO N DO
	 A[i,j] := 0.0;
END;


