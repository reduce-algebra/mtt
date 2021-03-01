function clipped_text = mttClipText(text)
	if isempty(text)
        clipped_text = [] ;
    else
        index = 1:length(text) ;
        useful = index(~isspace(text)) ;
        clipped_text = text(min(useful):max(useful)) ;
    end
