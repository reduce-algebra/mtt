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
 mtt_n_parameters = argc-1;
  for (i=1;i<argc;i++)\[
    mtt_parameters[i-1] = strtod(argv[i],0);
  \]
\]
}