function model = mttCreateAcausalBondgraph(system,root)
global mtt_environment


switch nargin
case 0,
    model = [] ; return ;
case 1,
    root = [] ;
    is_root_model = 1 ;
otherwise,
    is_root_model = 0 ;
end

if is_root_model
    model = intialise_model(system) ;
    
    directory_name = identify_directory_name(system) ;
    source_name = identify_source_name(system,directory_name) ;
    
    mttNotify('...acquiring "abg" source definitions') ;
    mttWriteNewLine ;
else
    model = propagate_root_data(root) ;
    source_name = system ;
end

specification_filename = [source_name,'_abg.txt'] ;
specification = mttFetchSpecification(specification_filename) ;
specification = mttSetFieldDefault(specification,'bondgraph',system) ;
    
[local_system_name,rubbish] = mttDetachText(system,'/') ;
if isempty(local_system_name)
    local_system_name = system ;
end


if is_root_model
    source_name = identify_source_name(specification.bondgraph,directory_name) ;
else
    source_name = specification.bondgraph ;
end
source_name = mttCutText(source_name,'_abg.fig') ;

bondgraph_filename = [source_name,'_abg.fig'] ;
bondgraph = mttFetchBondgraph(bondgraph_filename) ;

model = mttCreateUnifiedModel(model,bondgraph,specification) ;
model = mttDeleteField(model,'branch') ;
model = mttDeleteField(model,'leaf') ;


if is_root_model
    mttWriteNewLine ;
    mttNotify('...acquiring "cr" source definitions') ;
    mttWriteNewLine ;
    
    for n = 1:length(model.crs)
        source_name = model.crs{n} ;
        cr_filename = [source_name,'_cr.txt'] ;
        
        if ~mttFileExists(cr_filename)
            cr_short_name = mttDetachText(source_name,'/') ;
            
            mttNotify(['   ...ERROR: "',cr_short_name,'_cr" source does not exist']) ;
            mttWriteNewLine ;
            mttNotify(['   ...finding dependencies for ',source_name,':']) ;
            mttWriteNewLine ;
            
            prefix = mttDetachText(system,'/') ;
            if isempty(prefix)
                prefix = system ;
            end
            
            cr_user = model.cr_usage(n).obj ;
            for i = 1:length(cr_user)
                mttNotify(['         ',prefix,'/',cr_user{i}]) ;
                mttWriteNewLine ;
            end
        end
        
        model.cr(n) = mttFetchInterfaceDefinition(cr_filename) ;
    end
    
    model = mttDeleteField(model,'cr_usage') ;
    model = mttDeleteField(model,'crs') ;
    model = mttDeleteField(model,'abgs') ;
end

model.env = mtt_environment ;



function model = intialise_model(system)
    model.representation = 'abg' ;
    model.abgs = [] ;
    model.crs = [] ;
    model.cr_usage = [] ;
    model.branch = [] ;
    model.leaf = [] ;
    
function model = propagate_root_data(root)
    model.abgs = root.abgs ;
    model.crs = root.crs ;
    model.cr_usage = root.cr_usage ;
    model.branch = root.branch ;
    model.leaf = root.leaf ;

function directory = identify_directory_name(system)
    mttAssert(ischar(system),'System must be specified by name') ;
    working_directory  = pwd ;
    working_directory = strrep(working_directory,'\','/') ;
    
    [system_name,local_directory] = mttDetachText(system,'/') ;
    if isempty(system_name)
        local_directory = [] ;
    end
    
    if isempty(local_directory)
        directory = working_directory ;
    else
        directory = mttLocateDirectory(working_directory,local_directory) ;
    end
    
function source = identify_source_name(system,directory)
    [system_name,local_directory] = mttDetachText(system,'/') ;
    if isempty(system_name)
        system_name = system ;
        local_directory = [] ;
    end
    source = [directory,'/',system_name] ;
