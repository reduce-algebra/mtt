function directory = mttLocateDirectory(working_directory,local_directory)
	if isempty(local_directory)
        directory = working_directory ;
    else
        backslash = findstr(working_directory,'\') ;
        working_directory(backslash) = '/' ;
        
        [working_drive,working_path] = mttCutText(working_directory,':') ;
        if isempty(working_path)
            working_path = working_directory ;
            working_drive = [] ;
        end
        
        [local_drive,local_path] = mttCutText(local_directory,':') ;
        if isempty(local_path)
            local_path = local_directory ;
            local_drive = [] ;
        end
        
        
        if isempty(local_drive)
            if local_path(1)=='/'
                if isempty(working_drive)
                    directory = local_path ;
                else
                    directory = [working_drive,':',local_path] ;
                end
            else
                directory = [working_directory,'/',local_directory] ;
            end
        else
            mttAssert(all(isletter(local_drive)),...
                ['"',local_drive,'" is an invalid drive specifier']) ;
            directory = local_directory ;
        end
        mttAssert(exist(directory,'dir')==7,...
            ['Directory "',directory,'" not found']) ;
        
        locating = 1 ;
        while locating
            [left,right] = mttCutText(directory,'//') ;
            if isempty(right)
                locating = 0 ;
            else
                directory = [left,'/',right] ;
            end
        end
        
        locating = 1 ;
        while locating
            backtrack = findstr(directory,'/..') ;
            if isempty(backtrack)
                locating = 0 ;
            else
                [left,right] = mttCutText(directory,'/..') ;
                if isempty(right)
                    [cancelled,left] = mttDetachText(left,'/') ;
                    directory = left ;
                else
                    [cancelled,left] = mttDetachText(left,'/') ;
                    directory = [left,right] ;
                end
            end
        end
    end
    
