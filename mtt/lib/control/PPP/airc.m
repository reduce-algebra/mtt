function [A,B,C,D] = airc
% System AIRC 
% This system is the aircraft example from the book:
% J.M Maciejowski: Multivariable Feedback Design  Addison-Wesley, 1989
% It has 5 states, 3 inputs and 3 outputs.

% P J Gawthrop Jan 1998

A = [    0         0    1.1320         0   -1.0000
         0   -0.0538   -0.1712         0    0.0705
         0         0         0    1.0000         0
         0    0.0485         0   -0.8556   -1.0130
         0   -0.2909         0    1.0532   -0.6859];

B = [    0         0         0
   -0.1200    1.0000         0
         0         0         0
    4.4190         0   -1.6650
    1.5750         0   -0.0732];

C = [1     0     0     0     0
     0     1     0     0     0
     0     0     1     0     0];

D = zeros(3,3);


