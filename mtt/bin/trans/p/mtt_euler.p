PROCEDURE mtt_euler(VAR x_out, x,dx : StateVector;
			dt	    : REAL;
			Nx	    : INTEGER;
			Open	    : StateVector);

VAR i : INTEGER;
   
BEGIN{mtt_euler}
   FOR i := 1 TO Nx DO
   BEGIN
      IF Open[i]>0.5 THEN{Open switch}
	 x_out[i] := 0.0
      ELSE
	 x_out[i] := x[i] + dx[i]*dt;
   END;
END;{mtt_euler}
