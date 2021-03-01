function model = mttFetchDomain(filename)

model.representation = 'domain' ;

mttAssert(mttFileExists(filename),...
    ['File "',filename,'" not found']) ;

mttNotify(['   ...processing ',filename]) ;
mttWriteNewLine ;

model.source = mttCutText(filename,'_domain.txt') ;
content = mttReadFile(filename) ;
statements = mttExtractStatements(content) ;

number_of_statements = length(statements) ;

next = 0 ;

parsing = 1 ;
while parsing
    next = next + 1 ;
    statement = statements{next} ;
    [keyword,line] = mttSeparateText(statement) ;
    
    switch keyword
    case {'domain','public_domain','private_domain'},
        domain_name = line ;
        mttValidateName(domain_name) ;
        
        [domain,next] = fetch_domain(statements,next,domain_name) ;
        model = setfield(model,'item',domain_name,domain) ;
        
        is_private = strcmp(keyword,'private_domain') ;
        model = setfield(model,'item',domain_name,'is_private',is_private) ;
        
    case {'multi_domain','public_multi_domain','private_multi_domain'},
        domain_name = line ;
        mttValidateName(domain_name) ;
        
        [domain,next] = fetch_multi_domain(statements,next,domain_name) ;
        model = setfield(model,'item',domain_name,domain) ;

        is_private = strcmp(keyword,'private_multi_domain') ;
        model = setfield(model,'item',domain_name,'is_private',is_private) ;
        
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


function [domain,next] = fetch_domain(statements,next,domain_name)
    domain = [] ;
    unit_name = 'domain' ;
    
    number_of_statements = length(statements) ;
    
    effort_declared = 0 ;
    flow_declared = 0 ;
    
    open = 0 ;
    
	parsing = 1 ;
    while parsing
        next = next + 1 ;
        statement = statements{next} ;
        [keyword,line] = mttSeparateText(statement) ;
        
        switch keyword
        case 'effort',
            mttAssert(open,...
                ['"effort" declarations must be contained inside {...} in "',unit_name,'"']) ;
            mttAssert(~effort_declared,...
                ['"effort" declarations must be unique in "',unit_name,'"']) ;
            mttAssert(~isempty(line),...
                ['Undefined "effort" in "',unit_name,'"']) ;
            
            [covar,default] = mttCutText(line,'=') ;
            
            mttValidateName(covar) ;
            domain.covar.effort = covar ;
            domain.covar.effort_default = default ;
            effort_declared = 1 ;
            
        case 'flow',
            mttAssert(open,...
                ['"flow" declarations must be contained inside {...} in "',unit_name,'"']) ;
            mttAssert(~flow_declared,...
                ['"flow" declarations must be unique in "',unit_name,'"']) ;
            mttAssert(~isempty(line),...
                ['Undefined "flow" in "',unit_name,'"']) ;
            
            [covar,default] = mttCutText(line,'=') ;
            
            mttValidateName(covar) ;
            domain.covar.flow = covar ;
            domain.covar.flow_default = default ;
            flow_declared = 1 ;
            
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
    
    
function [domain,next] = fetch_multi_domain(statements,next,domain_name)
    domain = [] ;
    unit_name = 'domain' ;
    
    number_of_statements = length(statements) ;
    
    counter = 0 ;
    open = 0 ;
    
	parsing = 1 ;
    while parsing
        next = next + 1 ;
        statement = statements{next} ;
        [keyword,line] = mttSeparateText(statement) ;
        
        switch keyword
        case 'bond',
            mttAssert(open,...
                ['"bond" declarations must be contained inside {...} in "',unit_name,'"']) ;
            mttAssert(~isempty(line),...
                ['Undefined "bond" in "',unit_name,'"']) ;
            
            [bond_name,bond_domain] = mttCutText(line,'[') ;
            [bond_domain,rubbish] = mttCutText(bond_domain,']') ;
            
            mttAssert(isempty(rubbish),...
                ['Unexpected text after "]" in "',unit_name,'"']) ;
            
            if ~isempty(bond_name)
                mttValidateName(bond_name) ;
            end
            
            counter = counter + 1 ;
            domain.bond(counter).name = bond_name ;
            domain.bond(counter).domain = bond_domain ;
            
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
