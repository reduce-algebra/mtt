% Set up the parameters
imacmic_numpar;   

% Range of damping for the macro controller
D_1 = [0:0.1:2];

% Compute the damping factor d and save in arrray DD
% -- uses zeros of system
% $$$ DD = [];
% $$$ for d_1 = D_1
% $$$  [A,B,C,D] = macmic_dm(m_1,m_2,b_1,b_2,k_2,k_t,b_t,b_3,m_3,p_1,d_1);
% $$$  zz = ss2zp(A,B,C,D,1);
% $$$  z = (zz(:,2));
% $$$  re = sort(real(z));
% $$$  im = sort(imag(z));
% $$$  d = -re./sqrt(re.^2 + im.^2);
% $$$  d = sort(d);
% $$$  DD = [DD d];
% $$$ end;
% $$$ 
% $$$ plot(D_1,min(DD)); grid
% $$$ xlabel('Derivative gain');
% $$$ ylabel('Damping factor');
% $$$ 
% $$$ 

% Compute the damping factor d and save in arrray DD
% -- uses poles of inverse system
DD1 = [];
for d_1 = D_1
 [A] = imacmic_sm;
 z = eig(A);

 re = (real(z));
 im = (imag(z));
 d = -re./sqrt(re.^2 + im.^2);
 d = sort(d);
 DD1 = [DD1 d];
end;
minDD1 = min(DD1);

plot(D_1,minDD1); grid
xlabel('Derivative gain');
ylabel('Damping factor');

Maximum_Damping = max(minDD1)
index = minDD1 == Maximum_Damping*ones(size(minDD1));
Opt_gain = index*D_1'

% Plot on disk
set term postscript
set output "damping.ps"
plot(D_1,minDD1); grid


 
