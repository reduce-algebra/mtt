
mttdt = 1;
mttx=(zeros(200,1));
mttu=(zeros(200,1));
BigHeatedRod_numpar;
alpha = BigHeatedRod_smx(mttx,mttu,mttdt);
show_matrix (alpha);
psfig("sparsity.ps");


[N,junk] = size(alpha);
A =  eye(N) - alpha;
plot(log10(abs(eig(A))))
grid;
xlabel("i");
ylabel("e_i");
psfig("eig.ps");
