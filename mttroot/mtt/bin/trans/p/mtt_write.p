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
###############################################################


*}
 
VAR
   i : INTEGER;
   
BEGIN
   write(t);
   FOR i := 1 TO nx DO
      write(x[i]);
   FOR i := 1 TO ny DO
      write(y[i]);
   writeln;
END;
   
