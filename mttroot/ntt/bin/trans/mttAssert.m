function mttAssert(rule,msg)
    if ~isempty(rule)
        if ~rule
            error(['MTT: ',msg]) ;
        end
    end

