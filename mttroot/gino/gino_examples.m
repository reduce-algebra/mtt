## Simple example of creating an octave polynomial symbolically
P = g2o_pol("s^2*(s+a)*(s+b)^3") # Create symbolic polynomial in octave form
a = 1; b = 2;			# Give a and b numerical values
p = eval(P)			# Create numerical polynomial
roots(p)			# Use p in any appropriate octave
				# function

## More complicated example of symbolic linearisation

## ODE dx/dt = f(x,u); y = g(x,u)
f_1 = "x_2 - beta*tanh(u_1)";
f_2 = "-x_1 + x_2^2 + u_1";
g_1   = "x_1";
f = go_list(f_1,f_2)
g = go_list(g_1)

## Linearise via symbolic differentiation
[A,B,C,D] = go_lin(f,g)

## Find the transfer function

I = "[[1,0],[0,1]]";		# Unit matrix
## Create G as a string: C(sI-A)^-1B + D
G_str = sprintf("%s*((s*%s-%s)^(-1))*%s + %s", C,I,A,B,D)

## Find G itself
G = g_evalm(G_str);		

## Substitute steady-state values
G = g_subs(G, "{u_1,x_1,x_2}", "{0,0,0}")

## Extract the (only) matrix element
G = g_op(G,"0")

## Find numerator and denominator
a = g2o_pol(g_denom(G))
b = g2o_pol(g_numer(G))

## Evaluate numerically
beta = 0.5;
b = eval(b)
a = eval(a)
