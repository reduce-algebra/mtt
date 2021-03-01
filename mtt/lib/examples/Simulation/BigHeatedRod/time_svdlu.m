function [N,Ts,Tl]=time_svdlu;

  N=[100:100:700];

  Ts=[]; Tl=[];
  for n=N
    n
    M=rand(n,n);
    ts=time; svd(M); ts=time-ts
    tl=time; lu(M); tl=time-tl
    Ts=[Ts,ts];
    Tl=[Tl,tl];
  endfor;

endfunction;
  