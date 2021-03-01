function [register,ok] = mttAssign(register,new_value)
	if isempty(register)
        register = new_value ;
        ok = 1 ;
	else
    	ok = register==new_value ;
	end
