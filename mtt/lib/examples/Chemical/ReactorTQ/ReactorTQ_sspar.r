%% Reduce steady-state parameter file (ReactorTQ_sspar.r)
%% as siso_sspar ecxept that inputs/states have different meaning
%% Steady state for constant c_a, c_b and t=t_s and f=f_s

%% Unit volume ReactorTQ:
v_r := 1;

%% Do the inputs first -- this avoids problems with reduce not
%% recognising that complicated expressions are zero

%% The exponentials.
e_1 := e^(-q_1/t_s);
e_2 := e^(-q_2/t_s);
e_3 := e^(-q_3/t_s);

%Steady-state input q needed to achieve steady-state t_s
q_s := -( 
        + (t_0-t_s)*f_s
        + e_1*h_1*k_1*x1
        + e_2*h_2*k_2*x2
        + e_3*h_3*k_3*x1^2
       );

%% The input at steady-state
MTTu1 := f_s;

%States (masses)
x1 := c_a*v_r;
x2 := c_b*v_r;

%Load up the vectors
MTTx1 := x1;
MTTx2 := x2;

MTTy1 := c_b;

%% Finally, solve for the steady-state concentrations
%% Solve for ca - a quadratic.
a 	:= k_3*e_3;	%ca^2 
b 	:= k_1*e_1 + f_s;	%ca^1 
c 	:= -c_0*f_s;

c_a	:= (-b + sqrt(b^2 - 4*a*c))/(2*a);

%% solve for c_b
c_b 	:= c_a*k_1*e_1/(f_s+k_2*e_2);


END;


