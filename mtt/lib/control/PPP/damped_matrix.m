function A = damped_matrix (frequency,damping)

  ## usage:  A = damped_matrix (frequency,damping)
  ##
  ## Gives an A matrix with eigenvalues with specified 
  ## frequencies and damping ratio

  N = length(frequency);

  if nargin<2
    damping = zeros(size(frequency));
  endif
  
  if length(damping) != N
    error("Frequency and damping vectors have different lengths");
  endif
  
  A = zeros(2*N,2*N);
  for i=1:N
    j = 2*(i-1)+1;
    A_i = [-2*damping(i)*frequency(i) -frequency(i)^2
	   1                           0];
    A(j:j+1,j:j+1) = A_i;
  endfor
  
endfunction