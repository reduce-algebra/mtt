function [detached_text,preceding_text] = mttDetachText(text,delimiter)
    if isempty(text)
        detached_text = [] ;
        preceding_text = [] ;
    else
	    where = max(findstr(text,delimiter)) ;
        if isempty(where)
            detached_text = [] ;
            preceding_text = mttClipText(text) ;
        else
            detached_text = mttClipText(text(where+length(delimiter):length(text))) ;
            preceding_text = mttClipText(text(1:where-1)) ;
        end
    end
