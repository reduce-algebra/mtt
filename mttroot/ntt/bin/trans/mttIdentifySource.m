function [directory,file] = mttIdentifySource(local_filename)
local_filename
    filename = which(local_filename) 
    backslash = findstr(filename,'\') ;
    filename(backslash) = '/' ;
    
    [file,directory] = mttDetachText(filename,'/') ;
