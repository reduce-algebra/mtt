PROCEDURE mtt_write(t	  : REAL;
		    x	  : StateVector;
		    y	  : OutputVector;
		    nx,ny : INTEGER);

{*
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
      Pascal function mtt_write
      P.J. Gawthrop July 1998

###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
## Revision 1.1  1998/07/25 09:47:25  peterg
## Initial revision
##
###############################################################


*}
 
VAR
   i : INTEGER;
   
BEGIN
   write(t);
   FOR i := 1 TO ny DO
      write(y[i]);
   write(" # ");

   write(t);
   FOR i := 1 TO nx DO
      write(x[i]);
   writeln;
END;
   
