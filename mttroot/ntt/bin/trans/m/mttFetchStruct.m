function model = mttFetchStruct(filename)

model.representation = 'struct' ;

mttAssert(mttFileExists(filename),...
    ['File "',filename,'" not found']) ;

mttNotify(['   ...processing ',filename]) ;
mttWriteNewLine ;

model.source = mttCutText(filename,'_struct.txt') ;
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
    case {'struct','public_struct','private_struct'},
        struct_name = line ;
        mttValidateName(struct_name) ;
        
        [struct,next] = fetch_struct(statements,next,struct_name) ;
        model = setfield(model,'item',struct_name,struct) ;
        
        is_private = strcmp(keyword,'private_struct') ;
        model = setfield(model,'item',struct_name,'is_private',is_private) ;
        
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


function [struct,next] = fetch_struct(statements,next,struct_name)
    struct = [] ;
    unit_name = 'struct' ;
    
    number_of_statements = length(statements) ;
    
    counter = 0 ;
    open = 0 ;
    
	parsing = 1 ;
    while parsing
        next = next + 1 ;
        statement = statements{next} ;
        [keyword,line] = mttSeparateText(statement) ;
        
        switch keyword
        case 'var',
            mttAssert(open,...
                ['"var" declarations must be contained inside {...} in "',unit_name,'"']) ;
            mttAssert(~isempty(line),...
                ['Undefined "var" in "',unit_name,'"']) ;
            
            data_name = line ;
            mttValidateName(data_name) ;
            
            counter = counter + 1 ;
            struct.var(counter).name = data_name ;
            struct.var(counter).type = [] ;
            
        case '{',
            mttAssert(~open,['Unmatched "{" in "',unit_name,'"']) ;
            open = 1 ;
        case '}',
            mttAssert(open,['Unmatched "}" in "',unit_name,'"']) ;
			open = 0 ;
        otherwise,
            mttAssert(open,...
                ['Declarations must be contained inside {...} in "',unit_name,'"']) ;
            mttAssert(~isempty(line),...
                ['Empty declaration in "',unit_name,'"']) ;
            
            data_name = line ;
            mttValidateName(data_name) ;
            
            data_type = keyword ;
            mttValidateName(data_type) ;
            
            counter = counter + 1 ;
            struct.var(counter).name = data_name ;
            struct.var(counter).type = data_type ;
        end
        
        mttAssert(~(open & (next==number_of_statements)),...
            ['Missing "}" in "',unit_name,'"']) ;
        
        if (~open) | (next==number_of_statements)
			parsing = 0 ;
        end
    end
