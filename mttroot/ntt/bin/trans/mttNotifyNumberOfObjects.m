function mttNotifyOfObjects(model)
    
	number_of_objects = model.count.obj ;
    number_of_crs = model.count.cr ; 
    fprintf('   ...model has %i active objects (%i implemented by CRs)',number_of_objects,number_of_crs) ;
