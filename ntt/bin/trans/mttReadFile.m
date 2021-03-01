function content = mttReadFile(filename)

file_exists = exist(filename)==2 ;
if file_exists
    fid = fopen(filename,'r') ;
    reading = 1 ;
    
    counter = 0 ;
    while reading
        line = fgetl(fid) ;
        if ~isempty(line)
            if line==-1
                reading = 0 ;
            else
                counter = counter + 1 ;
                content{counter} = line ;
            end
        end
    end    
    fclose(fid) ;
else
    error(['file_not_found[',filename,']'])
end
