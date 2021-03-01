function information = mttAppendFields(information,extra)
    if isstruct(information) & isstruct(extra)
        information_fields = fieldnames(information) ;
        extra_fields = fieldnames(extra) ;
        
        for i = 1:length(extra_fields)
            field_name = extra_fields{i} ;
            extra_field = getfield(extra,field_name) ;
            information = setfield(information,field_name,extra_field) ;
        end
    end            
