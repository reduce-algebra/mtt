PROCEDURE mtt_solve_lud.p(VAR x     : StateVector;
			A     : StateMatrix;
		        B     : StateVector;
			n     : integer);

{
Linear equation solution via LU factorisation}

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % $Id$
% % $Log$
% % Revision 1.1  1998/08/17 12:41:37  peterg
% % Initial revision
% %
% % Revision 1.2  1998/08/14 12:09:13  peterg
% % A passed by value - its destroyed by SVDcm
% %
% % Revision 1.1  1998/08/13 08:51:57  peterg
% % Initial revision
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 }

VAR
   i : integer;
   d : real;

(*$I ludcmp.p *)
(*$I lubksb.p *)

BEGIN{mtt_solve}
   (* decompose matrix A using LU decomposition *)
   ludcmp(A,n,Index,d);
   
   (* backsubstitute for B *)
   lubksb(A,n,Index,B);

   (* x now lives in B *)
   FOR i := 1 TO n DO
      x[i] := B[i];
   
END{mtt_solve};






