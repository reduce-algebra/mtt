function model = mttCountObjects(model)

    object_names = mttGetFieldNames(model,'obj') ;
    number_of_objects = length(object_names) ;
    
    model.count.obj = number_of_objects ;
    model.count.cr = 0 ;
    
    for i = 1:number_of_objects
        object_name = object_names{i} ;
        object = getfield(model,'obj',object_name) ;
        
        if ~isempty(object.cr)
            model.count.cr = model.count.cr + 1 ;
        end
        
        if isfield(object,'obj')
            next = mttCountObjects(object) ;
            model.count.obj = model.count.obj + next.count.obj ;
            model.count.cr = model.count.cr + next.count.cr ;
        end
    end
            