function [domain,domain_item] = mttGetBondDomain(model,bond_number)
    if isempty(bond_number)
        domain = [] ;
        domain_item = [] ;
    else
        domain = model.bond(bond_number).domain ;
        domain_item = model.bond(bond_number).domain_item ;
    end
