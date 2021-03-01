function make_sfun(system,sorter_on)
global mtt_environment

if nargin<2
    sorter_on = 1 ;
end

switch class(system)
case 'char',
    input = 'spec' ;
case 'struct',
    if isfield(system,'representation')
        input = system.representation ;
    end
end    

start_time = mttGetTime ;

abg = [] ;
cbg = [] ;
ese = [] ;

if strcmp(input,'spec')
 	mttWriteNewLine ;
    mttNotify('Making "abg" representation') ;
    mttWriteNewLine ;
    
    if isempty(mtt_environment)
        mttNotify('...WARNING: No "env" definition => all domain references will be ignored') ;
        mttWriteNewLine ;
        mttNotify('                                => paths will not be recognised') ;
        mttWriteNewLine ;
    end
    
    abg = mttCreateAcausalBondgraph(system) ;
    input = 'abg' ;
end

if strcmp(input,'abg')
    if isempty(abg)
        abg = system ;
    end
    
    mttWriteNewLine ;
    mttNotify('Transforming from "abg" to "cbg"') ;
    mttWriteNewLine ;
    cbg = mttCreateCausalBondgraph(abg) ;
    input = 'cbg' ;
end

if strcmp(input,'cbg')
    if isempty(cbg)
        cbg = system ;
    end
    
    mttWriteNewLine ;
    mttNotify('Transforming from "cbg" to "ese"') ;
    mttWriteNewLine ;
    ese = mttCreateElementaryEquations(cbg,sorter_on) ;
    input = 'ese' ;
end

mttAssert(strcmp(input,'ese'),'Input representation not recognised') ;

if isempty(ese)
    ese = system ;
end
mttWriteSystemEquations(ese) ;
mttWriteSystemDefinitions(ese) ;
mttWriteSystemInitialisation(ese) ;
mttWriteSystemMapping(ese) ;

ese = mttCreateApps(ese) ;
mttWriteSystemApps(ese) ;
mttWriteSystemSfun(ese) ;
    

elapsed_time = mttElapseTime(start_time) ;
cpu_utilisation = round(100*elapsed_time.cpu/elapsed_time.clock) ;

mttWriteNewLine ;    
mttNotify(['Completed in ',num2str(elapsed_time.clock),' seconds']) ;
mttNotify([' (',num2str(cpu_utilisation),'%% cpu)']) ;
mttWriteNewLine ;    
mttWriteNewLine ;
