PROCEDURE mtt_implicit(VAR xnew	: StateVector;
			   x,dx	: StateVector;
			   AA	: StateMatrix;
			   AAx	: StateVector;
			   dt	: REAL;
			   Nx	: INTEGER;
			   open	: StateVector);

VAR
   i,ii,j,jj,Nxsub : INTEGER;
   BB,xsub   : StateVector;
   AAsub     : StateMatrix;
   
(*$I $MTTPATH/trans/p/mtt_solve.p *)

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

   Nxsub := ii; {New size}
   mtt_solve(xsub,AAsub,BB,Nxsub); {Solve AAx=BB}

   ii := 0;
   FOR i := 1 TO Nx DO
      BEGIN
	 IF open[i]<0.5 THEN
	 BEGIN
	    ii := ii+1; 
	    xnew[i] := xsub[ii];
	 END
	 ELSE
	 xnew[i] := 0.0;
      END;
END;{mtt_implicit}			  

