%SUMMARY RG	CR for 2 port gas dymanics R: isentropic nozzle


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % $Id$
% % $Log$
% % Revision 1.1  1998/03/04 15:37:48  peterg
% % Initial revision
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



OPERATOR RG;

% Port 1 : Enthalpy flow
FOR ALL COMP, gamma,R,A,T_u,P_u,T_d,P_d
LET RG(COMP, gamma,R,A, flow, 1,
		T_u,effort,1,
		P_u,effort,2,
		T_d,effort,3,
		P_d,effort,4)
	 = A*( P_u/sqrt(T_u) )
           *sqrt( (2*gamma)/(R*(gamma-1)) )
           *sqrt( (P_d/P_u)^(2/gamma) - (P_d/P_u)^((1+gamma)/gamma) )
           *(gamma/(gamma-1))*R*T_u;

% Port 2 : Mass flow
FOR ALL COMP, gamma,R,A,T_u,P_u,T_d,P_d
LET RG(COMP, gamma,R,A, flow, 2,
		T_u,effort,1,
		P_u,effort,2,
		T_d,effort,3,
		P_d,effort,4)
	 = A*( P_u/sqrt(T_u) )
           *sqrt( (2*gamma)/(R*(gamma-1)) )
           *sqrt( (P_d/P_u)^(2/gamma) - (P_d/P_u)^((1+gamma)/gamma) );

% Port 3 : Enthalpy flow
FOR ALL COMP, gamma,R,A,T_u,P_u,T_d,P_d
LET RG(COMP, gamma,R,A, flow, 3,
		T_u,effort,1,
		P_u,effort,2,
		T_d,effort,3,
		P_d,effort,4)
	 = A*( P_u/sqrt(T_u) )
           *sqrt( (2*gamma)/(R*(gamma-1)) )
           *sqrt( (P_d/P_u)^(2/gamma) - (P_d/P_u)^((1+gamma)/gamma) )
           *(gamma/(gamma-1))*R*T_u;

% Port 4 : Mass flow
FOR ALL COMP, gamma,R,A,T_u,P_u,T_d,P_d
LET RG(COMP, gamma,R,A, flow, 4,
		T_u,effort,1,
		P_u,effort,2,
		T_d,effort,3,
		P_d,effort,4)
	 = A*( P_u/sqrt(T_u) )
           *sqrt( (2*gamma)/(R*(gamma-1)) )
           *sqrt( (P_d/P_u)^(2/gamma) - (P_d/P_u)^((1+gamma)/gamma) );


END;;

