PROCEDURE mtt_implicit(VAR xnew,x,dx : StateVector;
		       VAR AA	     : StateMatrix;
		       VAR AAx	     : StateVector;
			   dt	     : REAL;
			   Nx	     : INTEGER);

VAR
   i : INTEGER;
   BB  : StateVector;

(*$I $MTTPATH/trans/p/mtt_ludcmp.p *)
(*$I $MTTPATH/trans/p/mtt_lubksb.p *)
(*$I $MTTPATH/trans/p/mtt_solve_lud.p *)

BEGIN{mtt_implicit}
   FOR i := 1 TO  Nx DO {BB is (1-A*dt)*x +dx*dt}
      BB[i] := AAx[i] + dt*dx[i];
   mtt_solve_lud(xnew,AA,BB,Nx); {Solve AAx=BB}
END;{mtt_implicit}			  