%function [model,bond_not_failed,diagnostic] = mttUpdateBondCausality(...
%    model,bond_number,effort_causality,flow_causality,uni_causality)
function [model,bond_not_failed] = mttUpdateBondCausality(...
    model,bond_number,effort_causality,flow_causality,uni_causality)
    
    if isempty(bond_number)
        bond_not_failed = 1 ;
%        diagnostic = [] ;
    else
        [model.bond(bond_number).effort,effort_ok] = ...
            update_causality(model.bond(bond_number).effort,effort_causality) ;
        [model.bond(bond_number).flow,flow_ok] = ...
            update_causality(model.bond(bond_number).flow,flow_causality) ;
        [model.bond(bond_number).unicausal,unicausal_ok] = ...
            update_causality(model.bond(bond_number).unicausal,uni_causality) ;
        
        [model.bond(bond_number),unicausal_checked] = ...
            check_unicausal(model.bond(bond_number)) ;
        
        bond_not_failed = effort_ok & flow_ok & unicausal_ok & unicausal_checked ;
%        diagnostic = [effort_ok,flow_ok,unicausal_ok,unicausal_checked] ;
    end
    
    
function [value,ok] = update_causality(value,new_value)
    ok = 1 ;
    
    if ~isempty(new_value)
        if isempty(value)
            value = new_value ;
        else
            ok = value==new_value ;
        end
    end
    
function [bond,ok] = check_unicausal(bond)
    unicausal_defined = ~isempty(bond.unicausal) ;
    effort_defined = ~isempty(bond.effort) ;
    flow_defined = ~isempty(bond.flow) ;
    
    ok = 1 ;
    
    if unicausal_defined
        switch bond.unicausal
        case 0,
            if effort_defined & flow_defined
                ok = bond.effort==~bond.flow ;
            elseif effort_defined & ~flow_defined
                bond.flow = ~bond.effort ;
            elseif flow_defined & ~effort_defined
                bond.effort = ~bond.flow ;
            end
        case 1,
            if effort_defined & flow_defined
                ok = bond.effort==bond.flow ;
            elseif effort_defined & ~flow_defined
                bond.flow = bond.effort ;
            elseif flow_defined & ~effort_defined
                bond.effort = bond.flow ;
            end
        end
    end        
     