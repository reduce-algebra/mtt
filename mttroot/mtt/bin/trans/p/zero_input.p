PROCEDURE zero_input(VAR x : InputVector;
			 N : INTEGER);
VAR i : INTEGER;
   
BEGIN
   FOR i:=1 TO N DO
      x[i] := 0.0;
END;


