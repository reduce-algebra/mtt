function mttCheckInterfaceDeclarations(model)

    for i = 1:length(model.sympar)
        mttAssert(~ismember(model.sympar{i},model.numpar),...
            ['Same name (',model.sympar{i},') used for "numpar" and "abg[...]" parameters']) ;   
        mttAssert(~ismember(model.sympar{i},model.input),...
            ['Same name (',model.sympar{i},') used for "input" and "abg[...]" parameters']) ;   
    end
    
    for i = 1:length(model.numpar)
        mttAssert(~ismember(model.numpar{i},model.input),...
            ['Same name (',model.numpar{i},') used for "numpar" and "input" parameters']) ;   
        mttAssert(~ismember(model.numpar{i},model.sympar),...
            ['Same name (',model.numpar{i},') used for "numpar" and "abg[...]" parameters']) ;   
    end
    
    for i = 1:length(model.input)
        mttAssert(~ismember(model.input{i},model.sympar),...
            ['Same name (',model.input{i},') used for "input" and "abg[...]" parameters']) ;   
        mttAssert(~ismember(model.input{i},model.numpar),...
            ['Same name (',model.input{i},') used for "numpar" and "input" parameters']) ;   
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
    
    object_names = mttGetFieldNames(model,'obj') ;
    
    if ~isempty(all_parameters)
        for i = 1:length(object_names)
            object_name = object_names{i} ;
            object = getfield(model,'obj',object_name) ;
            
            for j = 1:length(object.parameter)
                object_parameter = object.parameter{j} ;
                if ~isnumeric(object_parameter)
                    mttAssert(ismember(object_parameter,all_parameters),...
                        ['Object parameter "',object.parameter{j},'" not previously declared']) ;
                end
            end
        end
        
        for j = 1:length(all_parameters)
            current_parameter = all_parameters{j} ;
            other_parameters = all_parameters ;
            other_parameters(j) = [] ;
            
            mttAssert(~ismember(current_parameter,other_parameters),...
                ['Repeated parameter/input name "',current_parameter,'"']) ;
        end
    end
    
