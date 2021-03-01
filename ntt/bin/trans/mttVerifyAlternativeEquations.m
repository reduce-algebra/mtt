function delta = mttVerifyEquations(primary,secondary)
    searching = 1 ;
    
    length_primary = length(primary) ;
    length_secondary = length(secondary) ;
    
    i = 1 ;
    j = 1 ;
    k = 1 ;
    fprintf('k=%i: i=%i j=%i L=%i\n',k,i,j,length_secondary) ;            

    while searching
        k = k + 1 ;
        if strcmp(primary(i),secondary(j))
            secondary(j) = [] ;
            length_secondary = length_secondary - 1 ;
            fprintf('k=%i: i=%i j=%i L=%i\n',k,i,j,length_secondary) ;            
            
            i = i + 1;
            j = 1 ;
        else
            j = j + 1 ;
        end
        
        if length_secondary<1
            searching = 0 ;
        elseif j>length_secondary
            i = i + 1 ;
            j = 1 ;
        end
        
        if i>length_primary
            searching = 0 ;
        end
    end
            
    delta = secondary ;

    fprintf('Verification complete after %i iterations\n',k) ;            
    fprintf('...%i new records found\n',length(delta)) ;
    
