function result = mttIsEqual(left,right)
	if ~isempty(left) & ~isempty(right)
        result = left==right ;
    else
        result = [] ;
    end
    
