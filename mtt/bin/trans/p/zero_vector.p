PROCEDURE zero_vector(VAR x : StateVector;
			  N : INTEGER);
VAR i : INTEGER;
   
BEGIN
   FOR i:=1 TO N DO
      x[i] := 0.0;
END;


