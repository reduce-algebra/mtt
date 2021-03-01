PROCEDURE mtt_solve_lud(VAR x     : StateVector;
			A     : StateMatrix;
		        B     : StateVector;
			n     : integer);

{
Linear equation solution via LU factorisation

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % $Id$
% % $Log$
% % Revision 1.3  1999/10/26 23:37:20  peterg
% % Put include files here.
% %
% % Revision 1.2  1998/08/17 15:56:10  peterg
% % Uses LU decomposition - much faster than SVD when N>100
% %
% % Revision 1.1  1998/08/17 12:52:16  peterg
% % Initial revision
% %
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
   i	 : integer;
   d	 : real;
   Index : StateVector;


(*$I $MTTPATH/trans/p/mtt_ludcmp.p *)
(*$I $MTTPATH/trans/p/mtt_lubksb.p *)

BEGIN{mtt_solve_lud}
   (* decompose matrix A using LU decomposition *)
   mtt_ludcmp(A,n,Index,d);
   
   (* backsubstitute for B *)
   mtt_lubksb(A,n,Index,B);

   (* x now lives in B *)
   FOR i := 1 TO n DO
      x[i] := B[i];
   
END{mtt_solve_lud};






