function [left,right] = mttSeparateText(text)
    if isempty(text)
	    left = [] ;
        right = [] ;
    else
		whitespace = min(find(isspace(text))) ;
        if isempty(whitespace)
            left = text ;
            right = [] ;
        else
            left = text(1:whitespace-1) ;
            right = mttClipText(text(whitespace+1:length(text))) ;
        end
    end
