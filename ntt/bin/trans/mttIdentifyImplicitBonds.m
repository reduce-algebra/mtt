function next_next = mttIdentifyImplicitBonds(model,branch,next)
    is_root_model = (nargin==1) ;
    
    if is_root_model
        mttNotify('...following bonds have no explicit domain allocation:') ;
        mttWriteNewLine ;
        
        branch = mttDetachText(model.source,'/') ;
        next = 0 ;
    end

    number_of_bonds = mttGetFieldLength(model,'bond') ;
    for i = 1:number_of_bonds
        if isempty(model.bond(i).domain)
            origin = model.bond(i).from.obj ;
            port = model.bond(i).from.interface ;
            
            if isfield(model.obj,origin)
                origin_class = getfield(model,'obj',origin,'class') ;
                
                switch origin_class
                case {'0','1'},
                    bond_origin = [origin_class,':',origin] ;
                otherwise,
                    origin_port = getfield(model,'obj',origin,'interface',{port},'name') ;
                    bond_origin = [origin_class,':',origin,'[',origin_port,']'] ;
                end
            else
                bond_origin = ['SS:',origin] ;
            end
            
            target = model.bond(i).to.obj ;
            port = model.bond(i).to.interface ;
            
            if isfield(model.obj,target)
                target_class = getfield(model,'obj',target,'class') ;
                
                switch target_class
                case {'0','1'},
                    bond_target = [target_class,':',target] ;
                otherwise,
                    target_port = getfield(model,'obj',target,'interface',{port},'name') ;
                    bond_target = [target_class,':',target,'[',target_port,']'] ;
                end
            else
                bond_target = ['SS:',target] ;
            end
            
            next = next + 1 ;
            descriptor = ['      ',num2str(next),': ',branch,'(',num2str(i),') from: ',...
                bond_origin,' to: ',bond_target] ;
            
            mttNotify(descriptor) ;
            mttWriteNewLine ;
        end
    end
    
    
    next_next = next ;
    
    object_names = mttGetFieldNames(model,'obj') ;
    number_of_objects = length(object_names) ;
    
    for i = 1:number_of_objects
        object_name = object_names{i} ;
        object = getfield(model,'obj',object_name) ;
        
        if isfield(object,'obj')
            next_branch = [branch,'/',object_name] ;
            next_next = mttIdentifyImplicitBonds(object,next_branch,next) ;
            next = next_next ;
        end
    end
    