function compressed_text = mttCompressText(text)
	if isempty(text)
    	compressed_text = [] ;
    else
        compressed_text = text(~isspace(text)) ;
    end
