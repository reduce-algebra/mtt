PROCEDURE mtt_implicit(VAR xnew,x,dx : StateVector;
		       VAR AA	     : StateMatrix;
		       VAR AAx	     : StateVector;
			   dt	     : REAL;
			   Nx	     : INTEGER;
		       VAR   open    : StateVector);

VAR
   i,ii,j,jj : INTEGER;
   BB,xsub   : StateVector;
   AAsub     : StateMatrix;
   
(*$I $MTTPATH/trans/p/mtt_ludcmp.p *)
(*$I $MTTPATH/trans/p/mtt_lubksb.p *)
(*$I $MTTPATH/trans/p/mtt_solve_lud.p *)

BEGIN{mtt_implicit}
   ii := 0;
   FOR i := 1 TO  Nx DO {BB is (1-A*dt)*x +dx*dt}
   BEGIN
      IF open[i]<0.5 THEN
      BEGIN
	 ii := ii+1; jj := 0;
	 BB[ii] := AAx[i] + dt*dx[i];
	 FOR j := 1 TO Nx DO
	    IF open[j]<0.5 THEN
	    BEGIN
	       jj := jj+1;
	       AAsub[ii,jj] := AA[i,j];
	    END;
      END;
   END;

   Nx := ii; {New size}
   mtt_solve_lud(xsub,AAsub,BB,Nx); {Solve AAx=BB}

   ii := 0;
   FOR i := 1 TO Nx DO
      IF open[i]<0.5 THEN
      BEGIN
	 ii := ii+1;
	 xnew[i] := xsub[ii];
      END ELSE
	 xnew[i] := x[i];
END;{mtt_implicit}			  

