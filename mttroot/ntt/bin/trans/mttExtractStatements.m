function statements = mttExtractStatements(content)
	input = 1 ;
    output = 0 ;
    line = [] ;
    
    searching = 0 ;
    processing = 1 ;
    while processing
        line = [line,content{input}] ;
        line = mttCutText(line,'//') ;
        
        if ~isempty(line)
            semicolon = findstr(line,';') ;
            leftbrace = findstr(line,'{') ;
            rightbrace = findstr(line,'}') ;
            terminator = sort([semicolon,leftbrace,rightbrace]) ;
            
            if isempty(terminator)
                searching = 1 ;
            else
                first = 1 ;
                N = length(terminator) ;
                L = length(line) ;
                
                for i = 1:N
                    last = terminator(i) - 1 ;
                    if first<=last
                        output = output + 1 ;
                        statements{output} = mttClipText(line(first:last)) ;
                    end
                    
                    if ismember(line(terminator(i)),{'{','}'})
                        output = output + 1 ;
                        statements{output} = line(terminator(i)) ;
                    end
                    first = last + 2 ;
                end
                
                if terminator(N)==L
                    line = [] ;
                    searching = 0 ;
                else
                    line = mttClipText(line(terminator(N):L)) ;
                end
            end
        end
        input = input + 1 ;
        processing = input<=length(content) ;
        
        if searching
            mttAssert(input<=length(content),...
                'End of file found with an incomplete statement') ;
        end
    end
    