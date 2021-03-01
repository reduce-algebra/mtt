%SUMMARY reed Nonlinear 2-port R for musical reed component


%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     %%%%% Model Transformation Tools %%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linear constitutive relationship.

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Version control history
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% $Id$
% %% $Log$
% %% Revision 1.1  1996/11/02 10:21:19  peterg
% %% Initial revision
% %%
% %% Revision 1.1  1996/09/12 11:18:26  peter
% %% Initial revision
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Linear Constitutive Relationship for reed - unicausal case with 
% pressure output.
OPERATOR reed,abs,sign;

% Port 1 - the modulated R
FOR ALL D,q,H,airflow,displacement
LET reed(D,q,H, effort, 1, 
		airflow,flow,1,
		displacement, effort,2)
	 = (D*sign(airflow)*(airflow)^q)/((H-displacement)^2);

% Port 2 - zero flow
FOR ALL D,q,H,airflow,displacement
LET reed(D,q, flow, 2, 
		airflow,flow,1,
		displacement, effort,2)
	 =0;

