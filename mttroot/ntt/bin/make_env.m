function make_env(system)
global mtt_environment

start_time = mttGetTime ;

input = [] ;
env = [] ;


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
    mttNotify('Making "env" representation') ;
    mttWriteNewLine ;

    env = mttCreateEnvironment(system) ;
    input = 'env' ;
end

mttAssert(strcmp(input,'env'),'Input representation not recognised') ;

if isempty(env)
    mttWriteNewLine ;
    mttNotify('Copying "env" representation') ;
    mttWriteNewLine ;

    mttNotify('...INFO: Input already defined as a "env": copying to Output') ;
    mttWriteNewLine ;
    mttWriteNewLine ;
    env = system ;
end


elapsed_time = mttElapseTime(start_time) ;
cpu_utilisation = round(100*elapsed_time.cpu/elapsed_time.clock) ;

mttWriteNewLine ;    
mttNotify(['Completed in ',num2str(elapsed_time.clock),' seconds']) ;
mttNotify([' (',num2str(cpu_utilisation),'%% cpu)']) ;
mttWriteNewLine ;    
mttWriteNewLine ;


mtt_environment = env ;