function [left,right] = mttCutText(text,delimiter)
    if isempty(text)
	    left = [] ;
    	right = [] ;
    else
	    where = min(findstr(text,delimiter)) ;
        if isempty(where)
            left = mttClipText(text) ;
            right = [] ;
        else
            left = mttClipText(text(1:where-1)) ;
            right = mttClipText(text(where+length(delimiter):length(text))) ;
        end
    end
