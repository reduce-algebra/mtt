PROCEDURE mtt_solve(VAR x     : StateVector;
			A     : StateMatrix;
		    VAR B     : StateVector;
			n     : integer;
			Small : real);

{

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % $Id$
% % $Log$
% % Revision 1.1  1998/08/13 08:51:57  peterg
% % Initial revision
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 }

VAR
   i	     : integer;
   wmax,wmin : real;
   w	     : StateVector ;
   v	     : StateMatrix;

(*$I svdcmp.p *)
(*$I svbksb.p *)

BEGIN{mtt_solve}
(* decompose matrix A using SVD *)
   svdcmp(A,n,n,w,v);
   
(* find maximum singular value *)
   wmax := 0.0;
   FOR i := 1 to n DO BEGIN
      IF  (w[i] > wmax) THEN  wmax := w[i]
   END;
   
(* define "small" *)
   wmin := wmax*Small;
   
(* zero the "small" singular values *)
   FOR i := 1 to n DO BEGIN
      IF  (w[i] < wmin) THEN  w[i] := 0.0
   END;
   
(* backsubstitute for B *)
      svbksb(A,w,v,n,n,B,x);
   
END{mtt_solve};
