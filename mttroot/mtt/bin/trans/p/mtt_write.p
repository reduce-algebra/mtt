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
## Revision 1.5  1999/03/15 21:57:38  peterg
## Removed the # symbol
##
## Revision 1.4  1998/11/26 13:31:30  peterg
## Put missing space after 2nd t
##
## Revision 1.3  1998/07/25 20:41:38  peterg
## Spaces between numbers
##
## Revision 1.2  1998/07/25 14:04:14  peterg
## Changed format
##
## Revision 1.1  1998/07/25 09:47:25  peterg
## Initial revision
##
###############################################################


*}

CONST TAB=9;
 
VAR
   i : INTEGER;
   
BEGIN
   write(t,chr(TAB));
   FOR i := 1 TO ny DO
      write(y[i],chr(TAB));

   write(t,chr(TAB));
   FOR i := 1 TO nx DO
      write(x[i],chr(TAB));
   writeln;
END;
   
