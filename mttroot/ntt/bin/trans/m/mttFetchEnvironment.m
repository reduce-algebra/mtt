function model = mttFetchEnvironment(filename)

model.representation = 'env' ;

mttAssert(mttFileExists(filename),...
    ['File "',filename,'" not found']) ;

mttNotify(['   ...processing ',filename]) ;
mttWriteNewLine ;

model.source = mttCutText(filename,'_env.txt') ;
model_name = mttDetachText(model.source,'/') ;

content = mttReadFile(filename) ;
statements = mttExtractStatements(content) ;

number_of_statements = length(statements) ;

env_declared = 0 ;
next = 0 ;

parsing = 1 ;
while parsing
    next = next + 1 ;
    statement = statements{next} ;
    [keyword,line] = mttSeparateText(statement) ;
    
    switch keyword
    case 'env',
        mttAssert(~env_declared,...
            '"env" declaration must be unique') ;
        env_declared = 1 ;
        
        env_name = line ;
        mttAssert(strcmp(env_name,model_name),...
            ['Wrong name:[',env_name,'] Expecting:[',model_name,']']) ;
        
        [env,next] = fetch_env(statements,next) ;
        model = mttAppendFields(model,env) ;
        
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




function [env,next] = fetch_env(statements,next)
    env = [] ;
    unit_name = 'env' ;
    
    number_of_statements = length(statements) ;
    
    open = 0 ;
    
	parsing = 1 ;
    while parsing
        next = next + 1 ;
        statement = statements{next} ;
        [keyword,line] = mttSeparateText(statement) ;
        
        switch keyword
        case 'path',
            mttAssert(open,...
                ['"path" declarations must be contained inside {...} in "',unit_name,'"']) ;
            
            path_names = mttGetFieldNames(env,'path') ;
            
            [path_name,path_spec] = mttCutText(line,':=') ;
            mttAssert(~ismember(path_name,path_names),...
                ['Path "',path_name,'" already declared']) ;
            mttAssert(path_name(1)=='$',...
                ['Path "',path_name,'" must be prefixed with "$"']) ;
            
            path_name(1) = [] ;
            env = setfield(env,'path',path_name,path_spec) ;
            
        case 'domain',
            mttAssert(open,...
                ['"domain" declarations must be contained inside {...} in "',unit_name,'"']) ;
            
            domain_names = mttGetFieldNames(env,'domain') ;
            
            [domain_name,domain_spec] = mttCutText(line,':=') ;
            mttAssert(~ismember(domain_name,domain_names),...
                ['Domain "',domain_name,'" already declared']) ;
            
            env = setfield(env,'domain',domain_name,domain_spec) ;
                    
        case 'struct',
            mttAssert(open,...
                ['"struct" declarations must be contained inside {...} in "',unit_name,'"']) ;
            
            struct_names = mttGetFieldNames(env,'struct') ;
            
            [struct_name,struct_spec] = mttCutText(line,':=') ;
            mttAssert(~ismember(struct_name,struct_names),...
                ['Struct "',struct_name,'" already declared']) ;
            mttAssert(~isempty(struct_spec),...
                ['Undefined datatype within struct "',struct_name,'"']) ;
            
            env = setfield(env,'struct',struct_name,struct_spec) ;
                    
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
    
    env = mttSetFieldDefault(env,'path',[]) ;
    env = mttSetFieldDefault(env,'domain',[]) ;
    env = mttSetFieldDefault(env,'struct',[]) ;
    