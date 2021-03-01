function model = mttCreateApps(model)

apps_filename = [model.source,'_apps.txt'] ;
apps = mttFetchApps(apps_filename) ;

if isempty(apps)
    return ;
end

for i = 1:length(apps.app)
    app_source = apps.app{i} ;
    
    [rubbish,working_directory] = mttDetachText(model.source,'/') ;
    [name,path_spec] = mttDetachText(app_source,'/') ;
    
    if isempty(name)
        source_name = [working_directory,'/',domain_source] ;
    else
        directory = identify_directory(working_directory,path_spec,model) ;
        source_name = [directory,'/',name] ;
    end
    
    app_filename = [source_name,'_app.h'] ;
    model.app{i} = app_filename ;
end

    
function directory = identify_directory(working_directory,path_spec,model)
	path_names = mttGetFieldNames(model.env,'path') ;

    if isempty(path_spec)
		directory = [] ;
    else
        if path_spec(1)=='$'
            [path_alias,path_branch] = mttCutText(path_spec,'/') ;
            path_alias(1) = [] ;
            
            mttAssert(ismember(path_alias,path_names),...
                ['Path "',path_alias,'" not recognised']) ;
            
            path_root = getfield(model.env,'path',path_alias) ;
            
            if isempty(path_branch)
                directory = path_root ;
            else
                directory = [path_root,'/',path_branch] ;
            end
        else
            [name,local_directory] = mttDetachText(path_spec,'/') ;
            
            directory_located = 0 ;
            if strcmp(local_directory,'.')
                if isempty(name)
                    directory = working_directory ;
                    directory_located = 1 ;
                else
                    local_directory = name ;
                end
            else
                local_directory = path_spec ;
            end
            
            if ~directory_located
                directory = mttLocateDirectory(working_directory,local_directory) ;
            end
        end
    end
    




