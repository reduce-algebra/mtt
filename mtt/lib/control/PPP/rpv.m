function [A,B,C,D] = rpv
% System RPV
% This system is the remotely-piloted vehicle example from the book:
% J.M Maciejowski: Multivariable Feedback Design  Addison-Wesley, 1989
% It has 6 states, 2 inputs and 2 outputs.

% P J Gawthrop Jan 1998

A = [-0.0257  -36.6170  -18.8970  -32.0900    3.2509   -0.7626
      0.0001   -1.8997    0.9831   -0.0007   -0.1780   -0.0050
      0.0123   11.7200   -2.6316    0.0009  -31.6040   22.3960
           0         0    1.0000         0         0         0
           0         0         0         0  -30.0000         0
           0         0         0         0         0  -30.0000];

B = [0     0
     0     0
     0     0
     0     0
    30     0
     0    30];

C = [0     1     0     0     0     0
     0     0     0     1     0     0];

D = zeros(2,2);


