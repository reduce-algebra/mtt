function compound_item = mttIdentifyStructVariables(item,struct,model)
	structs = mttGetFieldNames(model,'struct') ;
	
	struct_name = struct.source ;
    struct_shortname = mttDetachText(struct_name,'/') ;
    
    item_names = mttGetFieldNames(struct,'item') ;
	
    number_of_vars = mttGetFieldLength(item,'var') ;
    
    counter = 0 ;
    for k = 1:number_of_vars
        var = item.var(k) ;
        
        next_item = var.type ;
        if isempty(next_item)
            counter = counter + 1 ;
            compound_var{counter} = var.name ;
        else
            mttAssert(ismember(next_item,item_names),...
                ['Unrecognised reference "',next_item,'" in struct ',struct_shortname]) ;
            
            dependent_item = getfield(struct,'item',next_item) ;
            compound_struct = mttIdentifyStructVariables(dependent_item,struct,model) ;
            
            for i = 1:length(compound_struct.var)
                counter = counter + 1 ;
                compound_var{counter} = [var.name,'.',compound_struct.var{i}] ;
            end
        end
        
        variables = length(compound_var) ;
        for n = 1:variables-1 ;
            mttAssert(~ismember(compound_var{n},{compound_var{n+1:variables}}),...
                ['Repeated variable "',compound_var{n},'" in struct ',struct_shortname]) ;
        end
        
		compound_item.var = compound_var ;
    end
	
