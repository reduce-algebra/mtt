function [effort_causality,flow_causality,uni_causality] = mttGetBondCausality(model,bond_number)
    if isempty(bond_number)
        effort_causality = [] ;
        flow_causality = [] ;
        uni_causality = [] ;
    else
        effort_causality = model.bond(bond_number).effort ;
        flow_causality = model.bond(bond_number).flow ;
        uni_causality = model.bond(bond_number).unicausal ;
    end
