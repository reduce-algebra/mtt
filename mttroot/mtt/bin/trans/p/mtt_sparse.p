PROCEDURE mtt_sparse(	 b   : glnarray;
			 n   : integer;
		     VAR x   : glnarray;
		     VAR rsq : real);
{*
###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
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
LABEL 1,99;
CONST
  {** eps	 = 0.00000;**}
   iters = 500;
   
VAR
   j,iter,irst: integer;
   rp,gg,gam,eps2,dgg,bsq,anum,aden: real;
   g,h,xi,xj: glnarray;
   
BEGIN
{**   eps2 := n*sqr(eps);
    irst := 0;
1:   irst := irst+1; **}
   mtt_asub(x,xi,n);
   rp := 0.0;
   bsq := 0.0;
   FOR j := 1 TO n DO BEGIN
     {* bsq := bsq+sqr(b[j]);*}
      xi[j] := xi[j]-b[j];
     {* rp := rp+sqr(xi[j]) *}
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
      IF (aden = 0.0) THEN BEGIN
         writeln('pause in routine SPARSE');
         writeln('very singular matrix'); {***readln ***}
      END;
      anum := anum/aden;
      FOR j := 1 TO n DO BEGIN
         xi[j] := x[j];
         x[j] := x[j]+anum*h[j]
      END;
      mtt_asub(x,xj,n);
      {***
       rsq := 0.0;
       **}
      FOR j := 1 TO n DO BEGIN
         xj[j] := xj[j]-b[j];
         {***rsq := rsq+sqr(xj[j])**}
      END;
      {***
      IF ((rsq = rp) OR (rsq <= bsq*eps2)) THEN GOTO 99;
      IF (rsq > rp) THEN BEGIN
       ***}{**
         FOR j := 1 TO n DO BEGIN
             x[j] := xi[j]
	 END;**}
      {***
         IF (irst >= 3) THEN GOTO 99;
         GOTO 1
      END;
      rp := rsq;
       ***}
      mtt_atsub(xj,xi,n);
      gg := 0.0;
      dgg := 0.0;
      FOR j := 1 TO n DO BEGIN
         gg := gg+sqr(g[j]);
         dgg := dgg+(xi[j]+g[j])*xi[j]
      END;
      {**IF (gg = 0.0) THEN GOTO 99;**}
      gam := dgg/gg;
      FOR j := 1 TO n DO BEGIN
         g[j] := -xi[j];
         h[j] := g[j]+gam*h[j]
      END
   END;
   {***writeln('pause in routine SPARSE');
   writeln('too many iterations'); readln; **}

{**99:writeln("---",iter,rsq);**}
END;
