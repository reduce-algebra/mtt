function [A,B,C,D]=autm
% System AUTM
% This system is the automotive gas turbine example from the book:
% Y.S. Hung and A.G.J. Macfarlane: "Multivariable Feedback. A
% quasi-classical approach."  Springer 1982
% It has 12 states, 2 inputs and 2 outputs.

% P J Gawthrop Jan 1998

%A-matrix
A = zeros(12,12);
A(1,2) 	= 1;
A(2,1) 	= -0.202; A(2,2) = -1.150;
A(3,4) 	= 1;
A(4,5) 	= 1;
A(5,3) 	= -2.360; A(5,4) = -13.60; A(5,5) = -12.80;
A(6,7) 	= 1;
A(7,8) 	= 1;
A(8,6) 	= -1.620; A(8,7) = -9.400; A(8,8) = -9.150;
A(9,10) = 1;
A(10,11) = 1;
A(11,12) = 1;
A(12,9) = -188.0; A(12,10) = -111.6; A(12,11) = -116.4; A(12,12) = -20.8;

%B-matrix
B = zeros(12,2);
B(2,1)   =  1.0439; B(2,2)   = 4.1486;
B(5,1)   = -1.794;  B(5,2)   = 2.6775;
B(8,1)   =  1.0439; B(8,2)   = 4.1486;
B(12,1)  = -1.794;  B(12,2)  = 2.6775;

%C-matrix
C = zeros(2,12);
C(1,1)  = 0.2640; C(1,2)  = 0.8060; C(1,3) = -1.420; C(2,4) = -15.00; 
C(2,6)  = 4.9000; C(2,7)  = 2.1200; C(2,8) = 1.9500; C(2,9) = 9.3500;
C(2,10) = 25.800; C(2,11) = 7.1400;

%D-matrix
D = zeros(2,2);

