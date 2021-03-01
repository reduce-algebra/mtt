function abg = make_abg(system)
global mtt_environment

start_time = mttGetTime ;

input = [] ;
abg = [] ;


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

mttAssert(strcmp(input,'abg'),'Input representation not recognised') ;

if isempty(abg)
    mttWriteNewLine ;
    mttNotify('Copying "abg" representation') ;
    mttWriteNewLine ;
    
    mttNotify('...INFO: Input already defined as a "abg": copying to Output') ;
    mttWriteNewLine ;
    mttWriteNewLine ;
    abg = system ;
end


elapsed_time = mttElapseTime(start_time) ;
cpu_utilisation = round(100*elapsed_time.cpu/elapsed_time.clock) ;

mttWriteNewLine ;    
mttNotify(['Completed in ',num2str(elapsed_time.clock),' seconds']) ;
mttNotify([' (',num2str(cpu_utilisation),'%% cpu)']) ;
mttWriteNewLine ;    
mttWriteNewLine ;
