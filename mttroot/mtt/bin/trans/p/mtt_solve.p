PROCEDURE mtt_solve(VAR x     : StateVector;
			A     : StateMatrix;
		    VAR B     : StateVector;
			n     : integer);

{

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % $Id$
% % $Log$
% % Revision 1.2  1998/08/14 12:09:13  peterg
% % A passed by value - its destroyed by SVDcm
% %
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

(*$I mtt_solve_lud.p *)
(* I mtt_solve_svd.p *)

BEGIN{mtt_solve}
      mtt_solve_lud(xsub,AAsub,BB,Nx);
      (*** mtt_solve_svd(xsub,AAsub,BB,Nx); ***)
END{mtt_solve};
