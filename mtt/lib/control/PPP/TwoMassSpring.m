function [A,B,C,D] = TwoMassSpring (k,m_1,m_2)

  ## usage:  [A,B,C,D] = TwoMassSpring (k,m_1,m_2)
  ##
  ## Two mass-spring example from Middleton et al.  EE9908

  ###############################################################
  ## Version control history
  ###############################################################
  ## $Id$
  ## $Log$
  ## Revision 1.2  1999/05/18 22:31:26  peterg
  ## Fixed error in dim of D
  ##
  ## Revision 1.1  1999/05/18 22:28:56  peterg
  ## Initial revision
  ##
  ###############################################################


  A = [0    1 0 0
       -k/m_1 0 k/m_1 0
       0    0 0 1
       k/m_2 0 -k/m_2 0];
  B = [0
       1/m_1
       0 
       0];
  C = [1 0 0 0
       0 0 1 0];

  D = zeros(2,1);

endfunction
