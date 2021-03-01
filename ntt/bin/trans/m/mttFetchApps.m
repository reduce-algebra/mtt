function model = mttFetchApps(filename)

if ~mttFileExists(filename)
    model = [] ;
    return ;
end

model.representation = 'apps' ;

mttNotify(['...processing ',filename]) ;
mttWriteNewLine ;

model.source = mttCutText(filename,'_apps.txt') ;
model_name = mttDetachText(model.source,'/') ;

content = mttReadFile(filename) ;
statements = mttExtractStatements(content) ;

number_of_statements = length(statements) ;

apps_declared = 0 ;
next = 0 ;

parsing = 1 ;
while parsing
    next = next + 1 ;
    statement = statements{next} ;
    [keyword,line] = mttSeparateText(statement) ;
    
    switch keyword
    case 'apps',
        mttAssert(~apps_declared,...
            '"apps" declaration must be unique') ;
        apps_declared = 1 ;
        
        apps_name = line ;
        mttAssert(strcmp(apps_name,model_name),...
            ['Wrong name:[',apps_name,'] Expecting:[',model_name,']']) ;
        
        [apps,next] = fetch_apps(statements,next) ;
        model = mttAppendFields(model,apps) ;
        
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




function [apps,next] = fetch_apps(statements,next)
    apps = [] ;
    unit_name = 'apps' ;
    
    number_of_statements = length(statements) ;
    
    open = 0 ;
    counter = 0 ;
    
	parsing = 1 ;
    while parsing
        next = next + 1 ;
        statement = statements{next} ;
        [keyword,line] = mttSeparateText(statement) ;
        
        switch keyword
        case 'app',
            mttAssert(open,...
                ['"app" declarations must be contained inside {...} in "',unit_name,'"']) ;
            
            app_name = line ;
            
            counter = counter + 1 ;
            apps.app{counter} = app_name ;
            
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
    
    apps = mttSetFieldDefault(apps,'app',[]) ;
    