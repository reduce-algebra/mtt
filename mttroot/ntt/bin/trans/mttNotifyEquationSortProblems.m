function mttNotifyEquationSortProblems(name_known,namelist)
    fprintf('   ...undetermined interface_variables are:\n') ;
	for i = 2:length(namelist)
        if ~name_known(i)
            fprintf(['         ',namelist{i},'\n']) ;
        end
    end
