function [A,B,C,D] = NMPsystem ()

  ## usage:  [A,B,C,D] = NMPsystem ()
  ##
  ## NMP system example (2-s)/(s-1)^3

  A = [3 -3 1
       1  0  0
       0  1  0];

  B = [1 
       0 
       0];

  C = [0 -0.5 1];

  D = 0;



endfunction