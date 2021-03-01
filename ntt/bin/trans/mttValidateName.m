function mttValidateName(name)
    mttAssert(~isempty(name),'Empty name') ;
    
    numbers = (name>=48 & name<=57) ;
    letters = (name>=65 & name<=90)|(name>=97 & name<=122) ;
    underscores = (name==95) ;
    
    is_alphanumeric = all(numbers|letters|underscores) ;
    starts_with_letter = isletter(name(1)) ;
    
    valid_name = is_alphanumeric & starts_with_letter ;
%    mtt_prefix = strncmp(name,'mtt_',4) ;
    mtt_delimiter = ~isempty(findstr(name,'__')) ;
    
%    mttAssert(~mtt_prefix,['"',name,'" must not contain "mtt_" prefix']) ;
    mttAssert(~mtt_delimiter,['"',name,'" must not contain contiguous "_" delimiters']) ;
    mttAssert(valid_name,['"',name,'" is not a valid name']) ;
    mttAssert(length(name)<32,['"',name,'" must be shortened to less than 32 characters']) ;
