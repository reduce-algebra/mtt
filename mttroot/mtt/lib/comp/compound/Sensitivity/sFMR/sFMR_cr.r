%% CR file for sFMR
%% Just for flow input definition of r, ie must use with flow,r;k_s
in "$MTT_CRS/r/slin.cr";

OPERATOR sFMR;

% Ordinary FMR port
FOR ALL gain_cause,r,k_s,out_cause,in,sin,in_cause,modu,smodu
LET sFMR(gain_cause,r,k_s,out_cause,1,
	in,in_cause,1,
	sin,in_cause,2,
	modu,flow,3,
	smodu,flow,4
	) 
        = slin(gain_cause,r*modu,k_s,out_cause,1,
               in,in_cause,1,
               sin,in_cause,2);

% Sensitivity FMR port - effort input
FOR ALL r,k_s,out_cause,inp,sinp,inp_cause,modu,smodu
LET sFMR(flow,r,k_s,out_cause,2,
	inp,effort,1,
	sinp,effort,2,
	modu,flow,3,
	smodu,flow,4
	)
        = (
          slin(flow,r,k_s,out_cause,2,
               inp/modu,effort,1,
               sinp/modu,effort,2)
        - smodu*(1/(r*(modu^2))) 
        );

% Sensitivity FMR port - flow input
FOR ALL r,k_s,out_cause,inp,sinp,inp_cause,modu,smodu
LET sFMR(flow,r,k_s,out_cause,2,
	inp,flow,1,
	sinp,flow,2,
	modu,flow,3,
	smodu,flow,4
	) 
	= (
          slin(flow,r,k_s,out_cause,2,
               inp*modu,flow,1,
               sinp*modu,flow,2)
        + r*inp*smodu
        );

% Modulation port
FOR ALL gain_cause,r,k_s,out_cause,inp,sinp,inp_cause,modu,smodu
LET sFMR(gain_cause,r,k_s,out_cause,3,
	inp,inp_cause,1,
	sinp,inp_cause,2,
	modu,flow,3,
	smodu,flow,4
	) 
        = 0;

% Sensitivity modulation port
FOR ALL gain_cause,r,k_s,out_cause,inp,sinp,inp_cause,modu,smodu
LET sFMR(gain_cause,r,k_s,out_cause,4,
	inp,inp_cause,1,
	sinp,inp_cause,2,
	modu,flow,3,
	smodu,flow,4
	) 
        = 0;
END;
