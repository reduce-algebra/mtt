PROCEDURE mtt_update(VAR xnew	: StateVector;
			 dx,x	: StateVector;
			 DT	: REAL;
			 Nx	: INTEGER;
			 METHOD	: IntegrationMethod);

VAR
i : INTEGER;
   
BEGIN
   FOR i := 1 TO  Nx DO
      xnew[i] := xnew[i] + dx[i]*DT;
END;


