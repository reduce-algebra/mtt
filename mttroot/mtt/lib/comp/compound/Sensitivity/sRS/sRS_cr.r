%% CR file for sFMR
%% Just for flow input definition of r, ie must use with flow,r;k_s

in "$MTT_CRS/r/slin.cr"; %% make sure CR slin is there

OPERATOR sRS;

% Ordinary RS port
% R component
FOR ALL gain_cause,r,rs,out_cause,inp,sinp,in_cause,temp,stemp
LET sRS(gain_cause,r,rs,out_cause,1,
	inp,in_cause,1,
	temp,effort,2,
	sinp,in_cause,3,
	stemp,effort,4
	) 
        = lin(gain_cause,r,temp_cause,1,
               inp,in_cause,1);
% Entropy flow 
FOR ALL gain_cause,r,rs,out_cause,inp,sinp,in_cause,temp,stemp
LET sRS(gain_cause,r,rs,out_cause,2,
	inp,in_cause,1,
	temp,effort,2,
	sinp,in_cause,3,
	stemp,effort,4
	) 
        = lin(gain_cause,r,temp_cause,1,
               inp,in_cause,1)/temp;

% Sensitivity ports
FOR ALL gain_cause,r,rs,out_cause,inp,sinp,in_cause,temp,stemp
LET sRS(gain_cause,r,rs,out_cause,3,
	inp,in_cause,1,
	temp,effort,2,
	sinp,in_cause,3,
	stemp,effort,4
	) 
        = slin(gain_cause,r,rs,temp_cause,2,
               inp,in_cause,1,
               sinp,in_cause,2
        );

%% Sensitivity entropy flow
%% - flow in
FOR ALL gain_cause,r,rs,out_cause,inp,sinp,in_cause,temp,stemp
LET sRS(gain_cause,r,rs,out_cause,4,
	inp,flow,1,
	temp,effort,2,
	sinp,flow,3,
	stemp,effort,4
	) 
        = 2*inp*sinp*r/temp
        + (inp^2)*rs/temp
        - (inp^2)*r*temps/(temp^2);

%% - effort in
FOR ALL gain_cause,r,rs,out_cause,inp,sinp,in_cause,temp,stemp
LET sRS(gain_cause,r,rs,out_cause,4,
	inp,effort,1,
	temp,effort,2,
	sinp,effort,3,
	stemp,effort,4
	) 
        = 2*inp*sinp/(r*temp)
        - (inp^2)*rs/((r^2)*temp)
        - (inp^2)*stemp/(r*temp^2);

END;
