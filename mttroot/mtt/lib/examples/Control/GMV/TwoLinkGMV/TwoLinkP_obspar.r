%% Reduce  GPC observability function parameters for system TwoLinkP (TwoLinkP_obspar.r)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MTTGPCNy := 2;
MTTGPCNu := 0;
Matrix MTTdU(5,1);
MTTdU(1,1) := MTTdU1;
MTTdU(2,1) := MTTdU2;
MTTdU(3,1) := MTTdU3;
MTTdU(4,1) := MTTdU4;
MTTdU(5,1) := MTTdU5;
Matrix MTTUU(2,5);
MTTUU(1,1) := MTTu1;
MTTUU(1,2) := MTTu11;
MTTUU(1,3) := MTTu12;
MTTUU(1,4) := MTTu13;
MTTUU(1,5) := MTTu14;
MTTUU(2,1) := MTTu2;
MTTUU(2,2) := MTTu21;
MTTUU(2,3) := MTTu22;
MTTUU(2,4) := MTTu23;
MTTUU(2,5) := MTTu24;
END;
