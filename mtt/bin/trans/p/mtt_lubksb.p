PROCEDURE mtt_lubksb(a: StateMatrix; n: INTEGER; indx: StateVector; VAR b: StateVector);

{ This file is derived from the NUMERICAL RECIPES PASCAL SHAREWARE DISKETTE.
 Please read the README file in $MTTPATH/trans/p
 }

{
###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
## Revision 1.1  1998/08/17 12:58:16  peterg
## Initial revision
##
###############################################################
}


(* Programs using LUBKSB must define the types
TYPE
   glnarray = ARRAY [1..n] OF real;
   glindx = ARRAY [1..n] OF integer;
   glnpbynp = ARRAY [1..np,1..np] OF real;
in the main routine *)
VAR
   j,ip,ii,i: integer;
   sum: real;
BEGIN
   ii := 0;
   FOR i := 1 TO n DO BEGIN
      ip := indx[i];
      sum := b[ip];
      b[ip] := b[i];
      IF  (ii <> 0) THEN BEGIN
         FOR j := ii TO i-1 DO BEGIN
            sum := sum-a[i,j]*b[j]
         END
      END ELSE IF (sum <> 0.0) THEN BEGIN
         ii := i
      END;
      b[i] := sum
   END;
   FOR i := n DOWNTO 1 DO BEGIN
      sum := b[i];
      IF (i < n) THEN BEGIN
         FOR j := i+1 TO n DO BEGIN
            sum := sum-a[i,j]*b[j]
         END
      END;
      b[i] := sum/a[i,i]
   END
END;
