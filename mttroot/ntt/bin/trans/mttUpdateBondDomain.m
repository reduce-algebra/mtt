function [model,bond_not_failed] = mttUpdateBondDomain(...
    model,bond_number,imposed_domain,imposed_domain_item)
    
    if isempty(bond_number)
        bond_not_failed = 1 ;
    else
        [model.bond(bond_number).domain,domain_ok] = ...
            update_domain(model.bond(bond_number).domain,imposed_domain) ;
        if domain_ok
            [model.bond(bond_number).domain_item,domain_item_ok] = ...
                update_domain_item(model.bond(bond_number).domain_item,imposed_domain_item) ;
        else
            domain_item_ok = 0 ;
        end
        
        bond_not_failed = domain_ok & domain_item_ok ;
    end
    
    
function [value,ok] = update_domain(value,new_value)
    ok = 1 ;
    
    if ~isempty(new_value)
        if isempty(value)
            value = new_value ;
        else
            ok = value==new_value ;
        end
    end
    
function [value,ok] = update_domain_item(value,new_value)
    ok = 1 ;
    
    if ~isempty(new_value)
        if isempty(value)
            value = new_value ;
        else
            ok = strcmp(value,new_value) ;
        end
    end
    