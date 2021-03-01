%% CR file for sFP

OPERATOR sFP;

% Entropy flow in

% Ordinary FP port
% Temperature
FOR ALL Entropy,Temperature,sEntropy,sTemperature
LET sFP(effort,1,
	Entropy,flow,1,
	Temperature,effort,2,
	sEntropy,flow,3,
	sTemperature,effort,4
	) 
        = Temperature;

% Heat
FOR ALL Entropy,Temperature,sEntropy,sTemperature
LET sFP(flow,2,
	Entropy,flow,1,
	Temperature,effort,2,
	sEntropy,flow,3,
	sTemperature,effort,4
	)
        = Entropy*Temperature;

% Temperature sensitivity
% Sensitivity  FP port
FOR ALL Entropy,Temperature,sEntropy,sTemperature
LET sFP(effort,3,
	Entropy,flow,1,
	Temperature,effort,2,
	sEntropy,flow,3,
	sTemperature,effort,4
	) 
        = sTemperature;

% Heat sensitivity
FOR ALL Entropy,Temperature,sEntropy,sTemperature
LET sFP(flow,4,
	Entropy,flow,1,
	Temperature,effort,2,
	sEntropy,flow,3,
	sTemperature,effort,4
	) 
        = (Entropy*sTemperature + sEntropy*Temperature);

% Heat flow in

% Ordinary FP port
% Temperature
FOR ALL Heat,Temperature,sHeat,sTemperature
LET sFP(effort,2,
	Temperature,effort,1,
	Heat,flow,2,
	sTemperature,effort,3,
	sHeat,flow,4
	) 
        = Temperature;

% Heat
FOR ALL Heat,Temperature,sHeat,sTemperature
LET sFP(flow,1,
	Temperature,effort,1,
	Heat,flow,2,
	sTemperature,effort,3,
	sHeat,flow,4
	) 
        = Heat/Temperature;

% Temperature sensitivity
% Sensitivity  FP port
FOR ALL Heat,Temperature,sHeat,sTemperature
LET sFP(effort,4,
	Temperature,effort,1,
	Heat,flow,2,
	sTemperature,effort,3,
	sHeat,flow,4
	) 
        = sTemperature;

% Heat sensitivity
FOR ALL Heat,Temperature,sHeat,sTemperature
LET sFP(flow,3,
	Temperature,effort,1,
	Heat,flow,2,
	sTemperature,effort,3,
	sHeat,flow,4
	) 
        = (sHeat*Temperature - Heat*sTemperature)/Temperature^2;
END;
