PROCEDURE mtt_sparse(	 b	 : glnarray;
			 n,iters : INTEGER;
		     VAR x	 : glnarray);

{ This file is derived from the NUMERICAL RECIPES PASCAL SHAREWARE DISKETTE.
 Please read the README file in $MTTPATH/trans/p
 }
{*
###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
## Revision 1.5  1998/08/15 13:49:19  peterg
## iters now passed as an argument.
##
## Revision 1.4  1998/08/15 09:33:25  peterg
## Deleted the commented out stuff
##
## Revision 1.3  1998/08/15 09:30:05  peterg
## Commented out the cariabel iteration stuff
##
## Revision 1.2  1998/08/15 08:26:30  peterg
## This is variable interations version - now going on to fixed
## iterations
##
## Revision 1.1  1998/08/13 14:58:35  peterg
## Initial revision
##
## Revision 1.1  1998/08/13 08:40:40  peterg
## Initial revision
##
###############################################################
*}

(* Programs using routine SPARSE must define the type
TYPE
   glnarray = ARRAY [1..n] OF real;
in the main routine. They must also provide two routines,
PROCEDURE asub(x: glnarray; VAR y: glnarray; n: integer);
and
PROCEDURE atsub(x: glnarray; VAR z: glnarray; n: integer);
which calculate A*x and (A transpose)*x *)
   
VAR
   j,iter,irst: integer;
   rp,gg,gam,eps2,dgg,bsq,anum,aden: real;
   g,h,xi,xj: glnarray;
   
BEGIN {mtt_sparse}
   mtt_asub(x,xi,n);
   rp := 0.0;
   bsq := 0.0;
   FOR j := 1 TO n DO BEGIN
      xi[j] := xi[j]-b[j];
   END;
   mtt_atsub(xi,g,n);
   FOR j := 1 TO n DO BEGIN
      g[j] := -g[j];
      h[j] := g[j]
   END;
   FOR iter := 1 TO iters DO BEGIN
      mtt_asub(h,xi,n);
      anum := 0.0;
      aden := 0.0;
      FOR j := 1 TO n DO BEGIN
         anum := anum+g[j]*h[j];
         aden := aden+sqr(xi[j])
      END;
      anum := anum/aden;
      FOR j := 1 TO n DO BEGIN
         xi[j] := x[j];
         x[j] := x[j]+anum*h[j]
      END;
      mtt_asub(x,xj,n);
      FOR j := 1 TO n DO BEGIN
         xj[j] := xj[j]-b[j];
      END;
      mtt_atsub(xj,xi,n);
      gg := 0.0;
      dgg := 0.0;
      FOR j := 1 TO n DO BEGIN
         gg := gg+sqr(g[j]);
         dgg := dgg+(xi[j]+g[j])*xi[j]
      END;
      gam := dgg/gg;
      FOR j := 1 TO n DO BEGIN
         g[j] := -xi[j];
         h[j] := g[j]+gam*h[j]
      END
   END;
END {mtt_sparse};
