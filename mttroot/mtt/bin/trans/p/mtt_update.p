PROCEDURE mtt_update(VAR xnew	: StateVector;
			 dx,x	: StateVector;
			 DT	: REAL;
			 Nx	: INTEGER;
			 METHOD	: IntegrationMethod;
		     VAR A	: StateMatrix);

CONST
   Small = 0.000001;
   
VAR
   i,j	 : INTEGER;
   AA	 : StateMatrix;
   BB,Ax : StateVector;
   
(*$I mtt_solve.p *)
   
BEGIN{mtt_update}
   IF Method=1 THEN {Euler}
      FOR i := 1 TO  Nx DO
	 xnew[i] := xnew[i] + dx[i]*DT
      ELSE IF (Method=2) OR (METHOD=3) THEN {Implicit}
      BEGIN
	 {Set up the solution matrices:
	  AA = eye(Nx)-A*dt
	  BB = x + dt*(dx - A*x)}
	 FOR i := 1 TO  Nx DO
	 BEGIN
	    Ax[i] := 0.0;
	    FOR j := 1 TO  Nx DO
	    BEGIN
	       AA[i,j] := -A[i,j]*DT;
	       Ax[i] := Ax[i] + A[i,j]*x[j];
	       IF i=j THEN
		  AA[i,j] := AA[i,j] + 1.0;
	    END
	 END;
	 
	 FOR i := 1 TO  Nx DO
	    BB[i] := x[i] + DT*(dx[i]-Ax[i]);

	 {Solve the equation AAx = B}
	 mtt_solve(xnew,AA,BB,Nx,Small);
      END
      ELSE
	 Writeln("Method >2 is not defined");
   
END{mtt_update};


