function [varlist,location] = mttFindEquationVariables(line)
	line = mttClipText(line) ;

	if isempty(line)
        namelist = [] ;
        location = [] ;
    else
        numbers = (line>=48 & line<=57) ;
        letters = (line>=65 & line<=90)|(line>=97 & line<=122) ;
        underscores = (line==95) ;
        dots = (line==46) ;
        apostrophes = (line==39) ;
        
        mask = (numbers|letters|underscores|dots|apostrophes) ;
        
        buffer = line ;
        buffer(~mask) = char(32*ones(1,sum(~mask))) ;
        
        next = 1 ;
        last = length(buffer) ;
        
        counter = 0 ;
        
        finding = any(mask) ;
        while finding
            i = min(find(~isspace(buffer(next:last))))+next-1 ;
            
            if isempty(i)
                finding = 0 ;
            else
                if i>last
                    finding = 0 ;
                else
                    if i==last
                        j = last ;
                    else
                        j = min(find(isspace(buffer(i+1:last))))+i ;
                        
                        if isempty(j)
                            j = last ;
                        else
                            j = j - 1 ;
                        end
                    end
                    
                    if ~mttIsNumericText(buffer(i:j))
                        var_found = 1 ;
                        
                        if j<last
                            jj = min(find(~isspace(line(j+1:last))))+j ;
                            if line(jj)=='('
                                var_found = 0 ;
                            end
                        end
                        if var_found
                            counter = counter + 1 ;
                            varlist{counter} = buffer(i:j) ;
                            location(counter) = i ;
                        end
                    end
                    next = j + 1 ;
                    finding = (next<last) & ~isempty(i) ;
                end
            end
        end
    end
     
