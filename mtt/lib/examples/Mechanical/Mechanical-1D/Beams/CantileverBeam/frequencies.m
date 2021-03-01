function [w_r,w_a,n_null] = frequencies (A,B,C,D)

  ## usage:  [w_r,w_a] = frequencies (A,B,C,D)
  ##
  ## Resonant and antiresonant frequencies for undampled beam

  poles = eig(A);
  Np = length(poles);
  zeros = tzero(A,B,C,D);
  Nz = length(zeros);
  w_r = sort(imag(poles)); w_r = w_r(Np/2+1:Np);
  w_a = sort(imag(zeros)); w_a = nozeros(w_a(Nz/2+1:Nz))';
  n_null = (Nz/2-length(w_a))*2;
endfunction
