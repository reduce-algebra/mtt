function model = mttFetchSpecification(filename)

model = [] ;

mttAssert(mttFileExists(filename),...
    ['File "',filename,'" not found']) ;

mttNotify(['   ...processing ',filename]) ;
mttWriteNewLine ;

model.specification = filename ;

model.source = mttCutText(filename,'_abg.txt') ;
model_name = mttDetachText(model.source,'/') ;

content = mttReadFile(filename) ;
statements = mttExtractStatements(content) ;

number_of_statements = length(statements) ;

abg_declared = 0 ;
next = 0 ;

parsing = 1 ;
while parsing
    next = next + 1 ;
    statement = statements{next} ;
    [keyword,line] = mttSeparateText(statement) ;
    
    switch keyword
    case 'abg',
        mttAssert(~abg_declared,...
            '"abg" declaration must be unique') ;
        abg_declared = 1 ;
        
        abg_name = mttCutText(line,'[') ;
        mttAssert(strcmp(abg_name,model_name),...
            ['Wrong name:[',abg_name,'] Expecting:[',model_name,']']) ;
        
        abg_parameter_list = mttExtractText(line,'[',']') ;
        [abg_parameters,abg_defaults] = mttGetParameters(abg_parameter_list) ;
        
        model.name = abg_name ;
        
        model.sympar = abg_parameters ;
        model.sympar_default = abg_defaults ;

        [abg,next] = fetch_abg(statements,next) ;
        
        model = mttAppendFields(model,abg) ;
        
    case '{',
        error('Unexpected "{" found') ;
    case '}',
        error('Unexpected "}" found') ;
    otherwise,
        error(['Unrecognised top-level keyword "',keyword,'"']) ;
    end
    
    if next==number_of_statements
        parsing = 0 ;
    end
end

mttCheckBondgraphDeclarations(model) ;



function [abg,next] = fetch_abg(statements,next)
global mtt_environment

    abg = [] ;
    unit_name = 'abg' ;
    
    user_defined_paths = mttGetFieldNames(mtt_environment,'path') ;
    
    number_of_statements = length(statements) ;
    
    bondgraph = [] ;
    use_declared = 0 ;
    open = 0 ;
    
	parsing = 1 ;
    while parsing
        next = next + 1 ;
        statement = statements{next} ;
        [keyword,line] = mttSeparateText(statement) ;
        
        switch keyword
        case 'use',
            mttAssert(open,...
                ['"use" declaration must be contained inside {...} in "',unit_name,'"']) ;
            mttAssert(~use_declared,...
                '"use" declaration must be unique') ;
            
            use_declared = 1 ;
            bondgraph = line ;
            
            abg.bondgraph = bondgraph ;
            
        case 'input',
            mttAssert(open,...
                ['"input" declarations must be contained inside {...} in "',unit_name,'"']) ;
            
            input_parameter_list = line ;
            [input_parameters,input_defaults] = mttGetParameters(input_parameter_list) ;
            
            abg = mttAppend(abg,'input',input_parameters) ;
            abg = mttAppend(abg,'input_default',input_defaults) ;
            
        case 'numpar',
            mttAssert(open,...
                ['"numpar" declarations must be contained inside {...} in "',unit_name,'"']) ;
            
            numerical_parameter_list = line ;
            [numerical_parameters,numerical_defaults] = mttGetParameters(numerical_parameter_list) ;
            
            abg = mttAppend(abg,'numpar',numerical_parameters) ;
            abg = mttAppend(abg,'numpar_default',numerical_defaults) ;
            
        case 'object',
            mttAssert(open,...
                ['"object" declarations must be contained inside {...} in "',unit_name,'"']) ;
            
            object_names = mttGetFieldNames(abg,'obj') ;
            
            [object_name,object_spec] = mttCutText(line,':=') ;
            mttAssert(~ismember(object_name,object_names),...
                ['Object "',object_name,'" already declared']) ;
            
            implementation = mttCutText(object_spec,'[') ;
            mttAssert(~isempty(implementation),...
                ['Incomplete specification:[',line,']']) ;
            
            object_parameter_list = mttExtractText(line,'[',']') ;
            object_parameters = mttGetInstanceParameters(object_parameter_list) ;
            
            [source,name.item] = mttCutText(implementation,'::') ;
            [name.class,name.path] = mttDetachText(source,'/') ;
            
            if isempty(name.class)
                name.class = source ;
                name.path = [] ;
            else
                mttAssert(~isempty(name.path),...
                    ['Empty path name in "',unit_name,'"']) ;
                if name.path(1)=='$'
                    [path_alias,path_branch] = mttCutText(name.path,'/') ;
                    path_alias(1) = [] ;
                    
                    mttAssert(ismember(path_alias,user_defined_paths),...
                        ['Path "',path_alias,'" not recognised']) ;
                    
                    path_root = getfield(mtt_environment,'path',path_alias) ;
                    if isempty(path_branch)
                        name.path = path_root ;
                    else
                        name.path = [path_root,'/',path_branch] ;
                    end
                end
            end
            
            abg = setfield(abg,'obj',object_name,'name',name) ;
            abg = setfield(abg,'obj',object_name,'parameter',object_parameters) ;
                    
        case '{',
            mttAssert(~open,['Unmatched "{" in "',unit_name,'"']) ;
            open = 1 ;
        case '}',
            mttAssert(open,['Unmatched "}" in "',unit_name,'"']) ;
			open = 0 ;
        otherwise,
            error(['Unrecognised_keyword "',keyword,'" in "',unit_name,'"']) ;
        end
        
        mttAssert(~(open & (next==number_of_statements)),...
            ['Missing "}" in "',unit_name,'"']) ;
        
        if (~open) | (next==number_of_statements)
			parsing = 0 ;
        end
    end
    
    abg = mttSetFieldDefault(abg,'input',[]) ;
    abg = mttSetFieldDefault(abg,'input_default',[]) ;
    abg = mttSetFieldDefault(abg,'numpar',[]) ;
    abg = mttSetFieldDefault(abg,'numpar_default',[]) ;
    abg = mttSetFieldDefault(abg,'bondgraph',[]) ;
    