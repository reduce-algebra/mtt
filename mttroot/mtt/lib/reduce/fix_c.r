%% Fixes for c-code generation

ON ROUNDED$ % No integer output

%% Changes x^y to pow(x,y)
 OPERATOR pow$
 FOR ALL x,y LET x^y = pow(x,y)$ % Use the pow function
 
 %% Derivatives
 FOR ALL f,g,x LET df(pow(f,g),x)=
 	   pow(f,g-1) * (df(f,x)*g + df(g,x)*f*log(f))$

 %% Special cases
 FOR ALL x LET pow(x,0) = 1$
 FOR ALL x LET pow(x,1) = x$

OPERATOR fabs$
FOR ALL x let abs(x) = fabs(x)$

END$
