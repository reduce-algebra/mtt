function model = mttEmbedInterfaceDefinition(model,object_name,root)
	if nargin==2
    	root = model ;
    end
	
    here = [mttDetachText(model.source,'/'),'/',object_name] ;
    
	object = getfield(model,'obj',object_name) ;
    cr = root.cr(object.cr) ;
    cr_item_name = object.cr_item ;
    
    cr_item_names = mttGetFieldNames(cr,'item') ;
    mttAssert(ismember(cr_item_name,cr_item_names),...
        ['CR "',cr_item_name,'" not found']) ;
    
    cr_item = getfield(cr,'item',cr_item_name) ;
    
    cr_portnames = mttGetFieldNames(cr_item.interface,'port') ;
    
    for i = 1:mttGetFieldLength(object,'interface')
        interface_name = object.interface(i).name ;
        
        mttAssert(ismember(interface_name,cr_portnames),...
            ['Unrecognised interface "',interface_name,'" in object ',here]) ;
        
            interface = getfield(cr_item,'interface','port',interface_name) ;
            interface.in = object.interface(i).in ;
            interface.out = object.interface(i).out ;
            
            has_inbond = ~isempty(object.interface(i).in) ;
            has_outbond = ~isempty(object.interface(i).out) ;

            mttAssert(xor(has_inbond,has_outbond),...
                ['Mismatched interface "',interface_name,'" in object ',here]) ;
            
            cr_item = setfield(cr_item,'interface','port',interface_name,interface) ;
    end
    
    for i = 1:length(cr_portnames)
        port_name = cr_portnames{i} ;
        cr_item_port = getfield(cr_item,'interface','port',port_name) ;
        mttAssert(isfield(cr_item_port,'in')|isfield(cr_item_port,'out'),...
            ['Unmatched port ',here,':',port_name]) ;
    end
    
    object.sympar = cr_item.sympar ;
    object.sympar_default = cr_item.sympar_default ;
    
    cr_item = mttDeleteField(cr_item,'parameter') ;
    object.cr = cr_item ;
    
    declarations = length(object.sympar) ;
    values = length(object.parameter) ;
    
    mttAssert(declarations==values,...
        ['Mismatched parameters in object ',here]) ;
    
    object = mttDeleteField(object,'cr_item') ;
    model = setfield(model,'obj',object_name,object) ;

    
