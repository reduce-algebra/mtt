PROCEDURE mtt_update(VAR xnew	    : StateVector;
		         dx,x,AAx   : StateVector;
		     VAR AA	    : StateMatrix;
			 DT	    : REAL;
			 STEPFACTOR : INTEGER;
			 Nx	    : INTEGER;
			 METHOD	    : IntegrationMethod);

{
 ###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
## Revision 1.4  1998/08/14 10:54:58  peterg
## Use sparse computation where possible
##
###############################################################
}

CONST
   Small = 0.000001;
   
VAR
   i,j : INTEGER;
   BB  : StateVector;
   DDT : REAL;
   
(*$I mtt_solve.p *)
(*$I mtt_sparse.p *)
   
BEGIN{mtt_update}
   
   IF Method=1 THEN {Euler}
   BEGIN{Euler}
      DDT := DT/STEPFACTOR;
	 FOR i := 1 TO  Nx DO
	    xnew[i] := xnew[i] + dx[i]*DDT;
   END {Euler}
   ELSE IF (Method=2) OR (METHOD=3) OR (METHOD=4) THEN {Implicit}
      BEGIN {Implicit methods}
	 
	 FOR i := 1 TO  Nx DO {BB is (1-A*dt)*x +dx*dt}
	    BB[i] := AAx[i] + DT*dx[i];

	 {Solve the equation AAx = B}
	 IF (Method=2) OR (METHOD=3) THEN {Use SVD}
	    mtt_solve(xnew,AA,BB,Nx,Small)
	 ELSE {Sparse CG solution}
	    mtt_sparse(BB,Nx,STEPFACTOR,xnew);
      END{Implicit methods}
      ELSE
	 Writeln("Method >4 is not defined");
   
END{mtt_update};




