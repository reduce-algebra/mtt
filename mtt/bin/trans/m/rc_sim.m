function [y,x] = rc_sim(mttx_0,mttU,mttT,MTTpar);

  ## Initialise
  [MTTu]  = zero_input(1);	# Zero the input

  [MTTx] = mttx_0;	        # Read in initial state

  N = length(mttT);
  Nx = length(mttx_0);

  y = zeros(1,N);
  x = zeros(Nx,N);

  mttdt = mttT(2)-mttT(1);
  for i = 1:N
    MTTt = mttT(i);
    MTTu = mttU(i);
    [MTTy] = rc_cseo(MTTx,MTTu,MTTt,MTTpar);    # Output 
    y(1,i) = MTTy;
    x(:,i) = MTTx;
    if 1>0			# Dont if no states
      [MTTdx] = rc_cse(MTTx,MTTu,MTTt,MTTpar); # State derivative
      [mttAA] = rc_smxa(MTTx,MTTu,mttdt,MTTpar);	# (I-Adt)
      [mttAA] = reshape(mttAA,Nx,Nx);
      [mttAAx] = rc_smxax(MTTx,MTTu,mttdt,MTTpar);	# (I-Adt)x
      [MTTopen] = rc_switchopen(MTTx);        # Open switches
      [MTTx] = mtt_implicit(MTTx,MTTdx,mttAA,mttAAx,mttdt,1,MTTopen); # Implicit update
    else 
    endif;			# 1>0

  endfor;				# Integration loop

endfunction
