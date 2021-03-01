function mttCheckStateDeclarations(model)
    for i = 1:length(model.sympar)
        mttAssert(~ismember(model.sympar{i},model.state),...
            ['Same name (',model.sympar{i},') used for "state" and "abg[...]" parameters']) ;   
    end
    
    for i = 1:length(model.numpar)
        mttAssert(~ismember(model.numpar{i},model.state),...
            ['Same name (',model.numpar{i},') used for "numpar" and "state" parameters']) ;   
    end
    
    for i = 1:length(model.input)
        mttAssert(~ismember(model.input{i},model.state),...
            ['Same name (',model.input{i},') used for "input" and "state" parameters']) ;   
    end
    
    for i = 1:length(model.state)
        mttAssert(~ismember(model.state{i},model.sympar),...
            ['Same name (',model.state{i},') used for "state" and "abg[...]" parameters']) ;   
        mttAssert(~ismember(model.state{i},model.numpar),...
            ['Same name (',model.state{i},') used for "state" and "numpar" parameters']) ;   
        mttAssert(~ismember(model.state{i},model.input),...
            ['Same name (',model.state{i},') used for "state" and "input" parameters']) ;   
    end
    
    all_parameters = [] ;
    
    if ~isempty(model.sympar)
        all_parameters = model.sympar ;
    end
    if ~isempty(model.numpar)
        if isempty(all_parameters)
            all_parameters = model.numpar ;
        else
            all_parameters = [all_parameters, model.numpar] ;
        end
    end
    if ~isempty(model.input)
        if isempty(all_parameters)
            all_parameters = model.input ;
        else
            all_parameters = [all_parameters, model.input] ;
        end
    end
    
    for j = 1:length(all_parameters)
        current_parameter = all_parameters{j} ;
        mttAssert(~ismember(current_parameter,model.state),...
            ['Repeated parameter/state name "',current_parameter,'"']) ;
    end
    
    for j = 1:length(model.state)
        current_state = model.state{j} ;
        mttAssert(~ismember(current_state,all_parameters),...
            ['Repeated parameter/state name "',current_state,'"']) ;
    end
    
