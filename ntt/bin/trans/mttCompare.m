function comparison = mttCompare(left,right)
	if isempty(left) | isempty(right)
        comparison = [] ;
    else
        comparison = (left==right) ;
    end
    
