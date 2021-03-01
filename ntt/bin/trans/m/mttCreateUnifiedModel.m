function model = mttCreateUnifiedModel(model,bondgraph,specification)

	model.source = mttCutText(specification.specification,'_abg.txt') ;
    model.bondgraph = mttCutText(bondgraph.bondgraph,'_abg.fig') ;
    
    model.obj = bondgraph.obj ;
    model.bond = bondgraph.bond ;
	
    object_names = mttGetFieldNames(model,'obj') ;
    specified_object_names = mttGetFieldNames(specification,'obj') ;
    
    for n = 1:length(object_names)
        object_name = object_names{n} ;
        object = getfield(model,'obj',object_name) ;
        
        if ~mttIsPassiveClass(object.class)
            mttAssert(ismember(object_name,specified_object_names),...
                ['Object name "',object_name,'" does not appear in specification']) ;
        end
    end
    
    for n = 1:length(specified_object_names)
        specified_object_name = specified_object_names{n} ;
        mttAssert(ismember(specified_object_name,object_names),...
            ['Specified object name "',specified_object_name,...
                '" does not appear in bond graph']) ;
        
        specified_object = getfield(specification,'obj',specified_object_name) ;
        object = getfield(model,'obj',specified_object_name) ;

        if strcmp(specified_object.name.class,object.class)
            mttAssert(~mttIsFoundationClass(object.class),...
                'Cannot redefine MTT foundation class') ;
            is_abg = 1 ;
        else
            mttAssert(~mttIsPassiveClass(object.class),...
                'Cannot modify MTT junctions or ports') ;
            is_abg = 0 ;
        end

        object.is_abg = is_abg ;        
        object.name = specified_object.name ;
        object.parameter = specified_object.parameter ;
        
        model = setfield(model,'obj',specified_object_name,object) ;
    end
    
    model.sympar = specification.sympar ;
    model.numpar = specification.numpar ;
    model.input = specification.input ;

    model.sympar_default = specification.sympar_default ;
    model.numpar_default = specification.numpar_default ;
    model.input_default = specification.input_default ;

    for n = 1:length(object_names)
        object_name = object_names{n} ;
        object = getfield(model,'obj',object_name) ;
        
        if mttIsPortClass(object.class)
            mttAssert(mttGetFieldLength(object,'interface')==1,...
                ['Port components must have one and only one interface']) ;
            
            switch object.class
            case {'Se','Sf'},
                mttAssert(~isempty(object.interface.out),...
                    'Each source port must have an outward bond') ;
            case {'De','Df'},
                mttAssert(~isempty(object.interface.in),...
                    'Each detector port must have an inward bond') ;
            end
        end
        
        if ~ismember(object_name,specified_object_names)
            object.name.item = [] ;
            object.name.class = object.class ;
            object.name.path = [] ;
            object.parameter = [] ;
            object.is_abg = 1 ;
        end
        
        [rubbish,working_directory] = mttDetachText(model.source,'/') ;
        local_directory = object.name.path ;
        directory = mttLocateDirectory(working_directory,local_directory) ;
        
        source = [directory,'/',object.name.class] ;
		
        current_leaf = model.leaf ;
        
		if object.is_abg
            if mttIsPassiveClass(object.name.class)
                object.abg = [] ;
            else
                current_branch = model.branch ;
                mttAssert(~ismember(source,current_branch),...
                    ['Recursive definition of "',source,'"']) ;

                if isempty(model.abgs)
                    existing_abg = [] ;
                else
                    existing_abg = strmatch(source,model.abgs,'exact') ;
                end
                
                if isempty(existing_abg) 
                    if isempty(current_branch)
                        next_branch = {source} ;
                        next_leaf = object_name ;
                    else
                        next_branch = [current_branch,{source}] ;
                        next_leaf = [current_leaf,'/',object_name] ;
                    end
                    model.branch = next_branch ;
                    model.leaf = next_leaf ;
                    
                    class_model = mttCreateAcausalBondgraph(source,model) ;
                    
                    model.leaf = current_leaf ;
                    model.branch = current_branch ;
                    
                    next_abg = 1 + mttGetFieldLength(model,'abg') ;
                    for i = 1:mttGetFieldLength(class_model,'abg')
                        model.abg(next_abg) = class_model.abg(i) ;
                        model.abgs = class_model.abgs ;
                        next_abg = next_abg + 1 ;
                    end
                    class_model = mttDeleteField(class_model,'abg') ;
                    
                    model.crs = class_model.crs ;
                    class_model = mttDeleteField(class_model,'crs') ;
                    
                    model.cr_usage = class_model.cr_usage ;
                    class_model = mttDeleteField(class_model,'cr_usage') ;
                    
                    model.abg(next_abg) = class_model ;
                    model = mttAppend(model,'abgs',{source}) ;
                    
                    index = length(model.abgs) ;
                    mttNotify(['   ...made "#',num2str(index),':',object.name.class,'" definition']) ;
                    mttWriteNewLine ;
                end
				object.abg = strmatch(source,model.abgs,'exact') ;
            end
            object.cr = [] ;
            object.cr_item = [] ;
        else
            if isempty(model.crs)
                existing_cr = [] ;
            else
                existing_cr = strmatch(source,model.crs,'exact') ;
            end
            
            if isempty(current_leaf)
                cr_user = object_name ;
            else
                cr_user = [current_leaf,'/',object_name] ;
            end
            
            if isempty(existing_cr)
                model = mttAppend(model,'crs',{source}) ;
                
                N = length(model.crs) ;
                model.cr_usage(N).obj{1} = cr_user ;
            else
                N = 1+length(model.cr_usage(existing_cr).obj) ;
                model.cr_usage(existing_cr).obj{N} = cr_user ;
            end
            
            object.abg = [] ;
            object.cr = strmatch(source,model.crs,'exact') ;

            if isempty(object.name.item)
                object.cr_item = mttDetachText(model.crs{object.cr},'/') ;
            else
                object.cr_item = object.name.item ;
            end
        end
        
        object = mttDeleteField(object,'name') ;
        object = mttDeleteField(object,'is_abg') ;
        
        model = setfield(model,'obj',object_name,object) ;
    end
