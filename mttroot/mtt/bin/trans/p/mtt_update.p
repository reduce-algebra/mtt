PROCEDURE mtt_update(VAR xnew	: StateVector;
			 dx,x	: StateVector;
			 DT	: REAL;
			 Nx	: INTEGER;
			 METHOD	: IntegrationMethod;
			 AA	: StateMatrix );

{
 ###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
###############################################################
}

CONST
   Small = 0.000001;
   
VAR
   i,j	 : INTEGER;
   BB,Ax : StateVector;
   rsq	 : REAL;
   
(*$I mtt_solve.p *)
(*$I mtt_sparse.p *)
   
BEGIN{mtt_update}
   IF Method=1 THEN {Euler}
      FOR i := 1 TO  Nx DO
	 xnew[i] := xnew[i] + dx[i]*DT
	 
      ELSE IF (Method=2) OR (METHOD=3) OR (METHOD=4) THEN {Implicit}
      BEGIN {Implicit methods}
	 mtt_asub(x,Ax,Nx); {Sparse computation of (1-A*dt)*x}
	 FOR i := 1 TO  Nx DO {BB is (1-A*dt)*x +dx*dt}
	    BB[i] := Ax[i]+ DT*dx[i];

	 {Solve the equation AAx = B}
	 IF (Method=2) OR (METHOD=3) THEN {Use SVD}
	    mtt_solve(xnew,AA,BB,Nx,Small)
	 ELSE {Sparse CG solution}
	    mtt_sparse(BB,Nx,xnew,rsq);
      END{Implicit methods}
      ELSE
	 Writeln("Method >4 is not defined");
   
END{mtt_update};




