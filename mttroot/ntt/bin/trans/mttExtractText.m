function extracted_text = mttExtractText(text,left,right)
    if isempty(text)
	    extracted_text = [] ;
    else
	    where_left = min(findstr(text,left)) ;
    	where_right = min(findstr(text,right)) ;
    
        if ~isempty(where_left) & ~isempty(where_right)
            extracted_text = mttClipText(text(where_left+length(left):where_right-1)) ;
        else
            extracted_text = [] ;
        end
    end
