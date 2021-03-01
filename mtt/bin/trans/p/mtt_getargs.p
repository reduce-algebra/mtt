{ Substitute for p2c PASCAL_MAIN
   Copies pogramme arguments in to mtt_parameters array
   This c code is embedded in a pascal routine in a p2c compatible way
}

{EMBED
Static Void  PASCAL_MAIN(argc, argv)
int argc;
char *argv[];

\[
 int i;
 mttnpar = argc-1;
 if (mttnpar>0) \[
   for (i=0;i<MTT_Nx;i++)\[
     x[i] = strtod(argv[i+1],0);
  \]
   for (i=0;i<MTT_Npar;i++)\[
     par[i] = strtod(argv[i+MTT_Nx+1],0);
  \]
 simpar.first=strtod(argv[MTT_Nx+MTT_Npar+1],0);
 simpar.dt=strtod(argv[MTT_Nx+MTT_Npar+2],0);
 simpar.last=strtod(argv[MTT_Nx+MTT_Npar+3],0);
 \]
\]
}