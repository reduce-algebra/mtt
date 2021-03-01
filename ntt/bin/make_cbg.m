function cbg = make_cbg(system)
global mtt_environment

start_time = mttGetTime ;

input = [] ;
abg = [] ;
cbg = [] ;


switch class(system)
case 'char',
    input = 'spec' ;
case 'struct',
    if isfield(system,'representation')
        input = system.representation ;
    end
end    


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

mttAssert(strcmp(input,'cbg'),'Input representation not recognised') ;

if isempty(cbg)
    mttWriteNewLine ;
    mttNotify('Copying "cbg" representation') ;
    mttWriteNewLine ;

    mttNotify('...INFO: Input already defined as a "cbg": copying to Output') ;
    mttWriteNewLine ;
    mttWriteNewLine ;
    cbg = system ;
end


elapsed_time = mttElapseTime(start_time) ;
cpu_utilisation = round(100*elapsed_time.cpu/elapsed_time.clock) ;

mttWriteNewLine ;    
mttNotify(['Completed in ',num2str(elapsed_time.clock),' seconds']) ;
mttNotify([' (',num2str(cpu_utilisation),'%% cpu)']) ;
mttWriteNewLine ;    
mttWriteNewLine ;
