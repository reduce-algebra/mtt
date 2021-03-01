function boolean = mttIsEmptyCellArray(cell_array)
    boolean = [] ;
    if iscell(cell_array)
        boolean = 1 ;
        for i = 1:length(cell_array)
            if ~isempty(cell_array{i})
                boolean = 0 ;
            end
        end
    end
