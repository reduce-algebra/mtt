function model = mttFetchBondgraph(filename)

mttAssert(mttFileExists(filename),...
    ['File "',filename,'" not found']) ;

mttNotify(['   ...processing ',filename]) ;
mttWriteNewLine ;

model.bondgraph = filename ;
content = mttReadFile(filename) ;

L = length(content) ;    
N = 1 ;

processing = (N<=L) ;
while processing
    jump = 1 ;
    line = mttClipText(content{N}) ;
    
    if ~isempty(line)
        no_string_terminator = isempty(findstr('\001',line)) ;
        
        if no_string_terminator
            if mttIsNumericText(line)
                numbers = round(str2num(line)) ;    	% only interested in integer values
                
                if numbers(1)==2						% ... line definition
                    forward_arrow = numbers(14)~=0 ;
                    reverse_arrow = numbers(15)~=0 ;
                    arrow = (forward_arrow | reverse_arrow) ;
                    
                    depth = numbers(7) ;
                    is_visible = rem(depth,10)==0 ;
                    
                    if is_visible
                        mttAssert(~arrow,...
                            ['Line ',num2str(N),': Arrows are not recognised in bond graphs']) ;
                        
                        number_of_points = numbers(16) ;

                        coordinate_string = [] ;
                        M = 0 ;
                        
                        matching = 1 ;
                        while matching
                            M = M + 1 ;
                            if isempty(coordinate_string)
                                coordinate_string = content{N+M} ;
                            else
                                coordinate_string = [coordinate_string,' ',content{N+M}] ;
                            end
                            
                            mttAssert(mttIsNumericText(coordinate_string),...
                                ['Line ',num2str(N+M),': Coordinates not recognised']) ;
                            
                            coordinates = str2num(coordinate_string) ;
                            
                            matching = length(coordinates)<2*number_of_points ;
                        end
                        
                        mttAssert(length(coordinates)==2*number_of_points,...
                            ['Line ',num2str(N+1),': Wrong number of coordinates']) ;
                        
                        jump = jump + M ; 
                        
                        if number_of_points==2
                            model = create_line(model,coordinates) ;
                        elseif number_of_points>2
                            model = create_bond(model,coordinates) ;
                        end
                    else
                        jump = jump + forward_arrow + reverse_arrow ;
                    end
                end
            end
        else
            [last_word,first_part] = mttDetachText(line,' ') ;
            
            if mttIsNumericText(first_part)
                numbers = round(str2num(first_part)) ;    	% only interested in integer values
                if numbers(1)==4							% ... text definition
                    depth = numbers(4) ;
                    is_visible = rem(depth,10)==0 ;
                    
                    if is_visible
                        coordinates = numbers(12:13) ;
                        text = mttCompressText(mttCutText(last_word,'\001')) ;
                        
                        identifier = mttCutText(text,'[') ;
                        qualifier = mttExtractText(text,'[',']') ;
                        
                        name.label = [] ;
                        name.domain = [] ;
                        name.domain_item = [] ;
                        name.class = [] ;
                        name.object = [] ;
                        
                        if isempty(identifier)
                            name.label = qualifier ;
                            model = create_label(model,name,coordinates) ;
                        else
                            [name.domain,name.domain_item] = mttCutText(qualifier,'::') ;
                            [name.class,name.object] = mttCutText(identifier,':') ;
                            model = create_object(model,name,coordinates) ;
                        end
                    end
                end
            end
        end
    end
    
    N = N + jump ;
	processing = (N<=L) ;
end

model = incorporate_anonymous_objects(model) ;
model = identify_causal_assignments(model) ;
model = identify_object_binding(model) ;
model = identify_object_interfaces(model) ;
model = associate_external_domains(model) ;
model = tidy_up(model) ;



function model = create_line(model,coordinates)
    next = 1 + mttGetFieldLength(model,'line') ;
    model.line(next).xy1 = coordinates(1:2) ;
    model.line(next).xy2 = coordinates(3:4) ;
    model.line(next).mid = (coordinates(1:2)+coordinates(3:4))/2 ;
            
function model = create_bond(model,coordinates)
	next = 1 + mttGetFieldLength(model,'bond') ;
	
    N = length(coordinates) ;
    
    q1 = coordinates(N-1:N) ;	p1 = coordinates(1:2) ;		
    p2 = coordinates(3:4) ;		q2 = coordinates(N-3:N-2) ;
    p3 = coordinates(5:6) ;		q3 = coordinates(N-5:N-4) ;
    ps = norm(p2-p1) ;		    qs = norm(q2-q1) ;
    
    orientation = sign(ps-qs) ;
    
    switch orientation
    case 1,		% harpoon points forward
        xy1 = p1 ; xy2 = q2 ; v1 = p2-p1 ; v2 = q2-q3 ; harpoon = q1-q2 ;
    case -1,	% harpoon points backward
        xy1 = p2 ; xy2 = q1 ; v1 = q2-q1 ; v2 = p2-p3 ; harpoon = p1-p2 ;
    end
    
    harpoon_side = sign_cross_product(v2,harpoon) ;
    
    mttAssert(~(orientation==0 | harpoon_side==0),...
        ['Ambiguous bond orientation between[',num2str(xy1),'] and [',num2str(xy2),']']) ;
    
    model.bond(next).xy1 = xy1 ;
    model.bond(next).xy2 = xy2 ;
    model.bond(next).v1  = v1 ;
    model.bond(next).v2  = v2 ;
    model.bond(next).harpoon = harpoon ;
    model.bond(next).harpoon_side = harpoon_side ;
    
    model.bond(next).from.obj = [] ;
    model.bond(next).from.interface = [] ;
    model.bond(next).to.obj = [] ;
    model.bond(next).to.interface = [] ;
    model.bond(next).flow = [] ;
    model.bond(next).effort = [] ;
    model.bond(next).unicausal = [] ;
    model.bond(next).domain = [] ;
    model.bond(next).domain_item = [] ;
    
function model = create_label(model,name,coordinates)
	inner_name = mttExtractText(name.label,'<','>') ;
    if isempty(inner_name)
        label_name = name.label ;
        is_inline = 0 ;
    else
        label_name = inner_name ;
        is_inline = 1 ;
    end
    mttValidateName(label_name) ;

    next = 1 + mttGetFieldLength(model,'label') ;
    model.label(next).name = label_name ;
    model.label(next).is_inline = is_inline ;
    model.label(next).xy = coordinates ;

function model = create_object(model,name,coordinates)
global mtt_environment
    
    domain_names = mttGetFieldNames(mtt_environment,'domain') ;
    
    is_anonymous = 0 ;
    if isempty(name.object)
        switch name.class
        case {'0','1'},
            is_anonymous = 1 ;
        case 'SS',
            mttAssert(~isempty(name.object),...
                'Anonymous "SS" object') ;
        otherwise,
            name.object = name.class ;
        end
    end
    
    if is_anonymous
        next = 1 + mttGetFieldLength(model,'anonymous') ;
        model.anonymous(next).class = name.class ;
        model.anonymous(next).xy = coordinates ;
    else
        object_names = mttGetFieldNames(model,'obj') ;
        if ~isempty(object_names)
            mttAssert(~ismember(name.object,object_names),...
                ['Repeated object: "',name.object,'"']) ;
        end
        
        switch name.class
        case {'0','1'},
            mttValidateName(name.object) ;
            mttAssert(~ismember(name.object,{'in','out'}),...
                'Junctions cannot use reserved port names') ;
            
        case {'SS','Se','Sf','De','Df'},
            mttValidateName(name.object) ;
            
            if isempty(name.domain) | isempty(mtt_environment)
                model = setfield(model,'obj',name.object,'domain',[]) ;
                model = setfield(model,'obj',name.object,'domain_item',[]) ;
            else
                mttAssert(ismember(name.domain,domain_names),...
                    ['Unrecognised domain "',name.domain,'"']) ;
                dom = getfield(mtt_environment,'domain',name.domain,'dom') ;
                item = getfield(mtt_environment,'domain',name.domain,'item') ;
                
                if isempty(item)
                    public_domain = getfield(mtt_environment,'public_domain',{dom}) ;
                    item_names = mttGetFieldNames(public_domain,'item') ;
                    
                    mttAssert(ismember(name.domain_item,item_names),...
                        ['Item "',name.domain_item,'" not found in public domain "',name.domain,'"']) ;
                    item_name = name.domain_item ;
                else
                    mttAssert(isempty(name.domain_item),...
                        ['Item unspecified in public domain "',name.domain,'"']) ;
                    item_name = item ;
                end
                
                model = setfield(model,'obj',name.object,'domain',dom) ;
                model = setfield(model,'obj',name.object,'domain_item',item_name) ;
            end
                
        otherwise,
            mttValidateName(name.class) ;
            mttValidateName(name.object) ;
            
            mttAssert(~ismember(name.object,{'in','out'}),...
                'Objects cannot use reserved port names') ;
        end
        model = setfield(model,'obj',name.object,'class',name.class) ;
        model = setfield(model,'obj',name.object,'xy',coordinates) ;
    end

function model = incorporate_anonymous_objects(model)
    number_of_objects = mttGetFieldLength(model,'anonymous') ;

    last = length(num2str(number_of_objects)) ;
    for i = 1:last
        object_number(i) = '0' ;
    end
    
    for i = 1:number_of_objects
        anonymous_object = getfield(model,'anonymous',{i}) ;
        
        current_number = num2str(i) ;
        width = length(current_number) ;
        first = last-width+1 ;
        object_number(first:last) = current_number ;
        
        object_name = ['mtt_obj',object_number] ;
        model = setfield(model,'obj',object_name,model.anonymous(i)) ;
    end

function r = sign_cross_product(v1,v2)
    r = sign(v1(1)*v2(2) - v1(2)*v2(1)) ;
    
function model = identify_causal_assignments(model)
	L = mttGetFieldLength(model,'line') ;
    
    if L>0
        N = mttGetFieldLength(model,'bond') ;
        
        for j = 1:L 
            for i = 1:N
                s(i,j) = norm(model.line(j).mid - model.bond(i).xy1) ;
                f(i,j) = norm(model.line(j).mid - model.bond(i).xy2) ;
            end
        end
        
        [min_range_start,nearest_bond_start] = min(s) ;
        [min_range_finish,nearest_bond_finish] = min(f) ;
        
        equidistant = min_range_start==min_range_finish ;
        at_harpoon = min_range_start>min_range_finish ;
        
        for j = 1:L
            fulcrum = num2str(model.line(j).mid) ;
            
            mttAssert(~equidistant(j),...
                ['Ambiguous causal line at [',num2str(model.line(j).mid),']']) ;
            
            if at_harpoon(j)
                index = nearest_bond_finish(j) ;
                bond = model.bond(index) ;
                terminal = bond.xy2 ;
                terminal_vector = bond.v2 ;
            else
                index = nearest_bond_start(j) ;
                bond = model.bond(index) ;
                terminal = bond.xy1 ;
                terminal_vector = bond.v1 ;
            end
            
            to_lhs = norm(model.line(j).xy1 - terminal) ;
            to_mid = norm(model.line(j).mid - terminal) ;
            to_rhs = norm(model.line(j).xy2 - terminal) ;
            
            mttAssert(to_mid<norm(bond.harpoon),...
                ['Cannot assign causality at [',num2str(fulcrum),']']) ;
            
            causality_ok = 0 ;
            
            is_unicausal = to_mid<min(to_lhs,to_rhs) ;
            if is_unicausal
                [bond.flow,causality_ok] = mttAssign(bond.flow,at_harpoon(j)) ;
                [bond.effort,causality_ok] = mttAssign(bond.effort,at_harpoon(j)) ;
            else
                causal_vector = (right-left) * sign(to_mid>to_left) ;
                causal_assignment = sign_cross_product(terminal_vector,causal_vector) ;
                mttAssert(causal_assignment~=0,...
                    ['Cannot determine causality near [',num2str(fulcrum),']']) ;
                
                if causal_assignment==bond.harpoon_side
                    [bond.flow,causality_ok] = mttAssign(bond.flow,at_harpoon(j)) ;
                else
                    [bond.effort,causality_ok] = mttAssign(bond.effort,at_harpoon(j)) ;
                end
            end
            mttAssert(causality_ok,...            
                ['Ambiguous causal assignment near [',num2str(fulcrum),']']) ;
            
            bond.unicausal = mttCompare(bond.flow,bond.effort) ;
            
            model.bond(index) = bond ;
        end
    end
    
    
function model = identify_object_binding(model)
	object_names = mttGetFieldNames(model,'obj') ;
	number_of_objects = length(object_names) ;
	number_of_bonds = mttGetFieldLength(model,'bond') ;
    
    for j = 1:number_of_bonds
        bond = model.bond(j) ;
        for i = 1:number_of_objects
            object = getfield(model,'obj',object_names{i}) ;
        	origin_proximity(i) = norm(object.xy - bond.xy1) ;
            target_proximity(i) = norm(object.xy - bond.xy2) ;
        end
       	
        [range,index] = min(origin_proximity) ;
        origin_name = object_names{index} ;
        bond.from.obj = origin_name ;
        bond.from.interface = [] ;
        
        [range,index] = min(target_proximity) ;
        target_name = object_names{index} ;
        bond.to.obj = target_name ;
        bond.to.interface = [] ;
        
        model = setfield(model,'bond',{j},bond) ;
        
        origin = getfield(model,'obj',origin_name) ;
        next = 1 + mttGetFieldLength(origin,'bond') ;
        origin.bond(next).number = j ;
        origin.bond(next).is_inbond = 0 ;
        model = setfield(model,'obj',origin_name,origin) ;
        
        target = getfield(model,'obj',target_name) ;
        next = 1 + mttGetFieldLength(target,'bond') ;
        target.bond(next).number = j ;
        target.bond(next).is_inbond = 1 ;
        model = setfield(model,'obj',target_name,target) ;
    end
    
    
function model = identify_object_interfaces(model)
	object_names = mttGetFieldNames(model,'obj') ;
	number_of_objects = length(object_names) ;
	number_of_labels = mttGetFieldLength(model,'label') ;
	number_of_bonds = mttGetFieldLength(model,'bond') ;
    
    for j = 1:number_of_labels
        label = model.label(j) ;
        for i = 1:number_of_objects
            object_name = object_names{i} ;
            object = getfield(model,'obj',object_names{i}) ;
            proximity(i) = norm(object.xy - label.xy) ;
        end
        [range,index] = min(proximity) ;
        associated_object = object_names{index} ;
        object = getfield(model,'obj',associated_object) ;
        
        switch object.class
        case {'0','1'},
            mttAssert(~label.is_inline,...
                ['Inline ports not valid for "0" and "1" junctions']) ;
        end
        
        next = 1 + mttGetFieldLength(object,'interface') ;
        object = setfield(object,'interface',{next},'name',label.name) ;
        object = setfield(object,'interface',{next},'class',[]) ;
        object = setfield(object,'interface',{next},'is_inline',label.is_inline) ;
        object = setfield(object,'interface',{next},'xy',label.xy) ;
        object = setfield(object,'interface',{next},'in',[]) ;
        object = setfield(object,'interface',{next},'out',[]) ;
        object = setfield(object,'interface',{next},'map',[]) ;
        model = setfield(model,'obj',associated_object,object) ;
    end
    
    for j = 1:number_of_objects
        object_name = object_names{j} ;
        object = getfield(model,'obj',object_name) ;
        
        number_of_attached_bonds = mttGetFieldLength(object,'bond') ;
        number_of_interfaces = mttGetFieldLength(object,'interface') ;
        
        for k = 1:number_of_interfaces
            interface = object.interface(k) ;
            
            inbond_proximity = [] ;  inbond_counter = [] ;
            outbond_proximity = [] ; outbond_counter = [] ;
            
            in_counter = 0 ;
            out_counter = 0 ;
            
            for i = 1:number_of_attached_bonds
                bond_number = object.bond(i).number ; 
                bond = model.bond(bond_number) ;
                
                if object.bond(i).is_inbond
                    if isempty(bond.to.interface)
                        in_counter = in_counter + 1 ;
                        inbond_proximity(in_counter) = norm(interface.xy - bond.xy2) ;
                        inbond_counter(in_counter) = bond_number ;
                    end
                else
                    if isempty(bond.from.interface)
                        out_counter = out_counter + 1 ;
                        outbond_proximity(out_counter) = norm(interface.xy - bond.xy1) ;
                        outbond_counter(out_counter) = bond_number ;
                    end
                end
            end
            
            [in_range,inbond_index] = min(inbond_proximity) ;
            [out_range,outbond_index] = min(outbond_proximity) ;

            inbond = inbond_counter(inbond_index) ;
            outbond = outbond_counter(outbond_index) ;
            
            if interface.is_inline
                mttAssert(~isempty(inbond_proximity),...
                    ['No in-bond for interface "',object_name,'[',interface.name,']"']) ;
                mttAssert(~isempty(outbond_proximity),...
                    ['No out-bond for interface "',object_name,'[',interface.name,']"']) ;
                
            	interface.in = inbond ;
                interface.out = outbond ;
                
                model = setfield(model,'bond',{outbond},'from','interface',k) ;
                model = setfield(model,'bond',{inbond},'to','interface',k) ;
            else
                mttAssert(~(isempty(inbond_proximity) & isempty(outbond_proximity)),...
                    ['No bond for interface "',object_name,'[',interface.name,']"']) ;
                
                if isempty(inbond_proximity)
                    interface.out = outbond ;
                    model = setfield(model,'bond',{outbond},'from','interface',k) ;
                elseif isempty(outbond_proximity)
                    interface.in = inbond ;
                    model = setfield(model,'bond',{inbond},'to','interface',k) ;
                else
                    mttAssert(in_range~=out_range,...
                        ['Ambiguous interface "',object_name,'[',interface.name,']"']) ;
                    
                    if out_range<in_range
                        interface.out = outbond ;
	                    model = setfield(model,'bond',{outbond},'from','interface',k) ;
                    else
                        interface.in = inbond ;
	                    model = setfield(model,'bond',{inbond},'to','interface',k) ;
                    end
                end
            end
            object.interface(k) = interface ;
        end
        model = setfield(model,'obj',object_name,object) ;
    end
    
    
    for i = 1:number_of_objects
        object_name = object_names{i} ;
        object = getfield(model,'obj',object_name) ;
            
        number_of_interfaces = mttGetFieldLength(object,'interface') ;
        for k = 1:number_of_interfaces;
            interface = object.interface(k) ;
            
            if interface.is_inline
                mttAssert(~(isempty(interface.in) | isempty(interface.out)),...
                    ['Unbound interface: ',object_name,'[',interface.name,']']) ;
            else
                mttAssert(~(isempty(interface.in) & isempty(interface.out)),...
                    ['Unbound interface: ',object_name,'[',interface.name,']']) ;
            end
        end
    end
    
    objects_with_in = [] ;
    objects_with_out = [] ;
    
    for j = 1:number_of_bonds
        bond = model.bond(j) ;
        
        if isempty(bond.from.interface)
            object_name = bond.from.obj ;
            object = getfield(model,'obj',object_name) ;
            
            if ~ismember(object.class,{'0','1'})
                mttAssert(~ismember(object_name,objects_with_out),...
                    ['Object "',object_name,'" has more than one implicit out-bond']) ;
                if isempty(objects_with_out)
                    objects_with_out = {object_name} ;
                else
                    objects_with_out = [objects_with_out,{object_name}] ;
                end
            end
            
            next = 1 + mttGetFieldLength(object,'interface') ;
            model = setfield(model,'obj',object_name,'interface',{next},'name','out') ;
      		model = setfield(model,'obj',object_name,'interface',{next},'in',[]) ;
            model = setfield(model,'obj',object_name,'interface',{next},'out',j) ;
            model = setfield(model,'bond',{j},'from','interface',next) ;
        end
        
        if isempty(bond.to.interface)
            object_name = bond.to.obj ;
            object = getfield(model,'obj',object_name) ;
            
            if ~ismember(object.class,{'0','1'})
                mttAssert(~ismember(object_name,objects_with_in),...
                    ['Object "',object_name,'" has more than one implicit in-bond']) ;
                if isempty(objects_with_in)
                    objects_with_in = {object_name} ;
                else
                    objects_with_in = [objects_with_in,{object_name}] ;
                end
            end
            
            next = 1 + mttGetFieldLength(object,'interface') ;
            model = setfield(model,'obj',object_name,'interface',{next},'name','in') ;
            model = setfield(model,'obj',object_name,'interface',{next},'in',j) ;
         	model = setfield(model,'obj',object_name,'interface',{next},'out',[]) ;
            model = setfield(model,'bond',{j},'to','interface',next) ;
        end
    end
    
    
function model = associate_external_domains(model)

	object_names = mttGetFieldNames(model,'obj') ;
	number_of_objects = length(object_names) ;
    
	for i = 1:number_of_objects
        object_name = object_names{i} ;
        object = getfield(model,'obj',object_name) ;
        
        switch object.class
        case {'SS','Se','Sf','De','Df'},
            mttAssert(mttGetFieldLength(object,'interface')==1,...
                ['Object "',object_name,'" must have a unique bond interface']) ;
            
            bond_number = [] ;
            
            if ~isempty(object.interface.in)
                bond_number = object.interface.in ;
            end
            if ~isempty(object.interface.out)
                bond_number = object.interface.out ;
            end
            
            [model,ok] = mttUpdateBondDomain(model,bond_number,object.domain,object.domain_item) ;
            mttAssert(ok,['Domain conflict on bond connected to object "',object_name,'"']) ;
        end
    end
    
    
function model = tidy_up(model)
% remove temperory data and xfig geometry from model structure 

	object_names = mttGetFieldNames(model,'obj') ;
	number_of_objects = length(object_names) ;
    
	for i = 1:number_of_objects
        object_name = object_names{i} ;
        object = getfield(model,'obj',object_name) ;
        
        object = mttDeleteField(object,'bond') ;
        
        object_interfaces = getfield(object,'interface') ;
        object_interfaces = mttDeleteField(object_interfaces,'is_inline') ;
        object_interfaces = mttDeleteField(object_interfaces,'xy') ;
        object = setfield(object,'interface',object_interfaces) ;
        object = mttDeleteField(object,'xy') ;
        model = setfield(model,'obj',object_name,object) ;
    end
    
	all_bonds = getfield(model,'bond') ;
    all_bonds = mttDeleteField(all_bonds,'xy1') ;
    all_bonds = mttDeleteField(all_bonds,'xy2') ;
    all_bonds = mttDeleteField(all_bonds,'v1') ;
    all_bonds = mttDeleteField(all_bonds,'v2') ;
    all_bonds = mttDeleteField(all_bonds,'harpoon') ;
    all_bonds = mttDeleteField(all_bonds,'harpoon_side') ;
    model = setfield(model,'bond',all_bonds) ;
    
    model = mttDeleteField(model,'anonymous') ;
    model = mttDeleteField(model,'line') ;
    model = mttDeleteField(model,'label') ;
