function mttWriteSystemSfun(model)

model_name = mttDetachText(model.source,'/') ;

working_directory  = pwd ;
working_directory = strrep(working_directory,'\','/') ;

filename = [working_directory,'/',model_name,'_sfun.cpp'] ;
fid = fopen(filename,'w') ;

mttNotify(['...creating ',filename]) ;
mttWriteNewLine ;

model_name = mttDetachText(model.source,'/') ;

fprintf(fid,['// Simulation Code for "',model_name,'"\n']) ;
fprintf(fid,'\n') ;
fprintf(fid,['// file: ',filename             ,'\n']) ;
fprintf(fid,['// written by MTT on ',datestr(now),'\n']) ;
fprintf(fid,'\n') ;

write_sfun(fid,model) ;

fclose(fid) ;


function write_sfun(fid,model)
    model_name = mttDetachText(model.source,'/') ;
    counter = mttCountSystemMapping(model) ;

    fprintf(fid,['#define S_FUNCTION_NAME ',model_name,'_sfun'                     ,'\n']) ;
    fprintf(fid,['#define S_FUNCTION_LEVEL 2'                                      ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,['#include "',model_name,'_include_def.h"'                         ,'\n']) ;
    
    if isfield(model,'app')
        if ~isempty(model.app)
            fprintf(fid,['#include "',model_name,'_include_apps.h"'                ,'\n']) ;
        end
    end
    
    fprintf(fid,['#include "simstruc.h"'                                           ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ; 
    fprintf(fid,['static double *_mttInput ;'                                      ,'\n']) ;
    fprintf(fid,['static double *_mttState ;'                                      ,'\n']) ;
    fprintf(fid,['static double *_mttDerivative ;'                                 ,'\n']) ;
    fprintf(fid,['static double *_mttOutput ;'                                     ,'\n']) ;
    fprintf(fid,['static double  _mttTime ;'                                       ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ; 
    fprintf(fid,['static unsigned int _mttIndex ;'                                 ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ; 
    fprintf(fid,['const int _mttNumInputs  = ',num2str(counter.input),' ;'         ,'\n']) ;
    fprintf(fid,['const int _mttNumOutputs = ',num2str(counter.output),' ;'        ,'\n']) ;
    fprintf(fid,['const int _mttNumStates  = ',num2str(counter.state),' ;'         ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ; 
    fprintf(fid,[''                                                                ,'\n']) ; 
    
    fprintf(fid,['// system equations'                                             ,'\n']) ; 
    fprintf(fid,[''                                                                ,'\n']) ; 
    fprintf(fid,['static void ',model_name,'_set_numpar (void) {'                  ,'\n']) ; 
    fprintf(fid,['#include "',model_name,'_include_set_numpar.h"'                  ,'\n']) ; 
    fprintf(fid,['}'                                                               ,'\n']) ; 
    fprintf(fid,[''                                                                ,'\n']) ; 
    fprintf(fid,['static void ',model_name,'_set_input (void) {'                   ,'\n']) ; 
    fprintf(fid,['#include "',model_name,'_include_set_input.h"'                   ,'\n']) ; 
    fprintf(fid,['}'                                                               ,'\n']) ; 
    fprintf(fid,[''                                                                ,'\n']) ; 
    fprintf(fid,['static void ',model_name,'_set_state (void) {'                   ,'\n']) ; 
    fprintf(fid,['#include "',model_name,'_include_set_state.h"'                   ,'\n']) ; 
    fprintf(fid,['}'                                                               ,'\n']) ; 
    fprintf(fid,[''                                                                ,'\n']) ; 
    fprintf(fid,['static void ',model_name,'_get_input (void) {'                   ,'\n']) ; 
    fprintf(fid,['#include "',model_name,'_include_get_input.h"'                   ,'\n']) ; 
    fprintf(fid,['}'                                                               ,'\n']) ; 
    fprintf(fid,[''                                                                ,'\n']) ; 
    fprintf(fid,['static void ',model_name,'_get_state (void) {'                   ,'\n']) ; 
    fprintf(fid,['#include "',model_name,'_include_get_state.h"'                   ,'\n']) ; 
    fprintf(fid,['}'                                                               ,'\n']) ; 
    fprintf(fid,[''                                                                ,'\n']) ; 
    fprintf(fid,['static void ',model_name,'_put_state (void) {'                   ,'\n']) ; 
    fprintf(fid,['#include "',model_name,'_include_put_state.h"'                   ,'\n']) ; 
    fprintf(fid,['}'                                                               ,'\n']) ; 
    fprintf(fid,[''                                                                ,'\n']) ; 
    fprintf(fid,['static void ',model_name,'_put_derivative (void) {'              ,'\n']) ; 
    fprintf(fid,['#include "',model_name,'_include_put_derivative.h"'              ,'\n']) ; 
    fprintf(fid,['}'                                                               ,'\n']) ; 
    fprintf(fid,[''                                                                ,'\n']) ; 
    fprintf(fid,['static void ',model_name,'_put_output (void) {'                  ,'\n']) ; 
    fprintf(fid,['#include "',model_name,'_include_put_output.h"'                  ,'\n']) ; 
    fprintf(fid,['}'                                                               ,'\n']) ; 
    fprintf(fid,[''                                                                ,'\n']) ; 
    fprintf(fid,['static void ',model_name,'_ode (void) {'                         ,'\n']) ; 
    fprintf(fid,['#include "',model_name,'_include_ode.h"'                         ,'\n']) ; 
    fprintf(fid,['}'                                                               ,'\n']) ; 
    fprintf(fid,[''                                                                ,'\n']) ; 
    fprintf(fid,[''                                                                ,'\n']) ; 

    fprintf(fid,['// utility procedures'                                           ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,['static double *array_of_double (size_t n)'                       ,'\n']) ;
    fprintf(fid,['{'                                                               ,'\n']) ;
    fprintf(fid,['  void *p = calloc (n, sizeof (double)) ;'                       ,'\n']) ;
    fprintf(fid,['  if (! p) fprintf (stderr, "*** ERROR: failed to allocate memory") ;','\n']) ;
    fprintf(fid,['  return (double *) p ;'                                         ,'\n']) ;
    fprintf(fid,['}'                                                               ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,['static void initialise_arrays (void)'                            ,'\n']) ;
    fprintf(fid,['{'                                                               ,'\n']) ;
    fprintf(fid,['  _mttInput	 = array_of_double(_mttNumInputs) ;'               ,'\n']) ;
    fprintf(fid,['  _mttOutput	 = array_of_double(_mttNumOutputs) ;'              ,'\n']) ;
    fprintf(fid,['  _mttState	 = array_of_double(_mttNumStates) ;'               ,'\n']) ;
    fprintf(fid,['  _mttDerivative = array_of_double(_mttNumStates) ;'             ,'\n']) ;
    fprintf(fid,['}'                                                               ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,['static void check_finite(SimStruct *S, double *array, unsigned int index)','\n']) ;
    fprintf(fid,['{'                                                               ,'\n']) ;
    fprintf(fid,['  const char *array_name ;'                                      ,'\n']) ;
    fprintf(fid,['  char warning[128] ;'                                           ,'\n']) ;
    fprintf(fid,['  if ((array[index] <= 0.0) || (array[index] >= 0.0)) {'         ,'\n']) ;
    fprintf(fid,['    ; // ...no problem'                                          ,'\n']) ;
    fprintf(fid,['  } else {'                                                      ,'\n']) ;
    fprintf(fid,['    if (array == _mttInput) {'                                   ,'\n']) ;
    fprintf(fid,['      array_name = "_mttInput" ;'                                ,'\n']) ;
    fprintf(fid,['    } else if (array == _mttState) {'                            ,'\n']) ;
    fprintf(fid,['      array_name = "_mttState" ;'                                ,'\n']) ;
    fprintf(fid,['    } else if (array == _mttOutput) {'                           ,'\n']) ;
    fprintf(fid,['      array_name = "_mttOutput" ;'                               ,'\n']) ;
    fprintf(fid,['    } else if (array == _mttDerivative) {'                       ,'\n']) ;
    fprintf(fid,['      array_name = "_mttDerivative" ;'                           ,'\n']) ;
    fprintf(fid,['    } else {'                                                    ,'\n']) ;
    fprintf(fid,['      array_name = "unknown_array" ;'                            ,'\n']) ;
    fprintf(fid,['    }'                                                           ,'\n']) ;
    fprintf(fid,['    sprintf(warning,"(time %%f) Non-finite array element: %%s[%%d]",_mttTime,array_name,index) ;','\n']) ;
    fprintf(fid,['    ssWarning(S,warning) ;'                                      ,'\n']) ;
    fprintf(fid,['  }'                                                             ,'\n']) ;
    fprintf(fid,['}'                                                               ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;

    fprintf(fid,['// S-function methods'                                           ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,['static void mdlInitializeSizes(SimStruct *S)'                    ,'\n']) ;
    fprintf(fid,['{'                                                               ,'\n']) ;
    fprintf(fid,['  ssSetNumSFcnParams(S,0) ;'                                     ,'\n']) ; 
    fprintf(fid,['  if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) return ;','\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,['  ssSetNumContStates(S,_mttNumStates) ;'                         ,'\n']) ;
    fprintf(fid,['  ssSetNumDiscStates(S,0) ;'                                     ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,['  if (!ssSetNumInputPorts(S,1)) return ;'                        ,'\n']) ;
    fprintf(fid,['  ssSetInputPortWidth(S,0,_mttNumInputs) ;'                      ,'\n']) ;
    fprintf(fid,['  ssSetInputPortDirectFeedThrough(S,0,1) ;'                      ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,['  if (!ssSetNumOutputPorts(S,1)) return ;'                       ,'\n']) ;
    fprintf(fid,['  ssSetOutputPortWidth(S,0,_mttNumOutputs) ;'                    ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,['  ssSetNumSampleTimes(S,1) ;'                                    ,'\n']) ;
    fprintf(fid,['  ssSetNumRWork(S,0) ;'                                          ,'\n']) ;
    fprintf(fid,['  ssSetNumIWork(S,0) ;'                                          ,'\n']) ;
    fprintf(fid,['  ssSetNumPWork(S,0) ;'                                          ,'\n']) ;
    fprintf(fid,['  ssSetNumModes(S,0) ;'                                          ,'\n']) ;
    fprintf(fid,['  ssSetNumNonsampledZCs(S,0) ;'                                  ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,['  ssSetOptions(S,SS_OPTION_EXCEPTION_FREE_CODE) ;'               ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,['  initialise_arrays() ;'                                         ,'\n']) ;
    fprintf(fid,['}'                                                               ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,['static void mdlInitializeSampleTimes(SimStruct *S)'              ,'\n']) ;
    fprintf(fid,['{'                                                               ,'\n']) ;
    fprintf(fid,['  ssSetSampleTime(S,0,CONTINUOUS_SAMPLE_TIME) ;'                 ,'\n']) ;
    fprintf(fid,['  ssSetOffsetTime(S,0,0.0) ;'                                    ,'\n']) ;
    fprintf(fid,['}'                                                               ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,['#define MDL_INITIALIZE_CONDITIONS'                               ,'\n']) ;
    fprintf(fid,['static void mdlInitializeConditions(SimStruct *S)'               ,'\n']) ;
    fprintf(fid,['{'                                                               ,'\n']) ;
    fprintf(fid,['  ',model_name,'_set_numpar() ;'                                 ,'\n']) ;
    fprintf(fid,['  ',model_name,'_set_state() ;'                                  ,'\n']) ;
    fprintf(fid,['  ',model_name,'_put_state() ;'                                  ,'\n']) ;
    fprintf(fid,['  for (_mttIndex=0; _mttIndex<_mttNumStates; _mttIndex++) ssGetContStates(S)[_mttIndex] = _mttState[_mttIndex] ;','\n']) ;
    fprintf(fid,['}'                                                               ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,['static void mdlOutputs(SimStruct *S,int_T tid)'                  ,'\n']) ;
    fprintf(fid,['{'                                                               ,'\n']) ;
    fprintf(fid,['  UNUSED_ARG(tid) ;'                                             ,'\n']) ;
    fprintf(fid,['  for (_mttIndex=0; _mttIndex<_mttNumStates; _mttIndex++) {'     ,'\n']) ;
    fprintf(fid,['    _mttState[_mttIndex] = ssGetContStates(S)[_mttIndex] ;'      ,'\n']) ;
    fprintf(fid,['    check_finite(S,_mttState,_mttIndex) ;'                       ,'\n']) ;
    fprintf(fid,['  }'                                                             ,'\n']) ;
    fprintf(fid,['  for (_mttIndex=0; _mttIndex<_mttNumInputs; _mttIndex++) {'     ,'\n']) ;
    fprintf(fid,['    _mttInput[_mttIndex] = *ssGetInputPortRealSignalPtrs(S,0)[_mttIndex] ;','\n']) ;
    fprintf(fid,['    check_finite(S,_mttInput,_mttIndex) ;'                       ,'\n']) ;
    fprintf(fid,['  }'                                                             ,'\n']) ;
    fprintf(fid,['  _mttTime = ssGetT(S) ;'                                        ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,['  ',model_name,'_get_input() ;'                                  ,'\n']) ;
    fprintf(fid,['  ',model_name,'_get_state() ;'                                  ,'\n']) ;
    fprintf(fid,['  ',model_name,'_ode() ;'                                        ,'\n']) ;
    fprintf(fid,['  ',model_name,'_put_output() ;'                                 ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,['  for(_mttIndex=0; _mttIndex<_mttNumOutputs; _mttIndex++) {'     ,'\n']) ;
    fprintf(fid,['    check_finite(S,_mttOutput,_mttIndex) ;'                      ,'\n']) ;
    fprintf(fid,['    ssGetOutputPortRealSignal(S,0)[_mttIndex] = _mttOutput[_mttIndex] ;','\n']) ;
    fprintf(fid,['  }'                                                             ,'\n']) ;
    fprintf(fid,['}'                                                               ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,['#define MDL_DERIVATIVES'                                         ,'\n']) ;
    fprintf(fid,['static void mdlDerivatives(SimStruct *S)'                        ,'\n']) ;
    fprintf(fid,['{'                                                               ,'\n']) ;
    fprintf(fid,['  for (_mttIndex=0; _mttIndex<_mttNumStates; _mttIndex++) {'     ,'\n']) ;
    fprintf(fid,['    _mttState[_mttIndex] = ssGetContStates(S)[_mttIndex] ;'      ,'\n']) ;
    fprintf(fid,['    check_finite(S,_mttState,_mttIndex) ;'                       ,'\n']) ;
    fprintf(fid,['  }'                                                             ,'\n']) ;
    fprintf(fid,['  for (_mttIndex=0; _mttIndex<_mttNumInputs; _mttIndex++) {'     ,'\n']) ;
    fprintf(fid,['    _mttInput[_mttIndex] = *ssGetInputPortRealSignalPtrs(S,0)[_mttIndex] ;','\n']) ;
    fprintf(fid,['    check_finite(S,_mttInput,_mttIndex) ;'                       ,'\n']) ;
    fprintf(fid,['  }'                                                             ,'\n']) ;
    fprintf(fid,['  _mttTime = ssGetT(S) ;'                                        ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,['  ',model_name,'_get_input() ;'                                  ,'\n']) ;
    fprintf(fid,['  ',model_name,'_get_state() ;'                                  ,'\n']) ;
    fprintf(fid,['  ',model_name,'_ode() ;'                                        ,'\n']) ;
    fprintf(fid,['  ',model_name,'_put_derivative() ;'                             ,'\n']) ;
    fprintf(fid,['  '                                                              ,'\n']) ;
    fprintf(fid,['  if (_mttTime==0)'                                              ,'\n']) ;
    fprintf(fid,['    for(_mttIndex=0; _mttIndex<_mttNumStates; _mttIndex++) ssGetdX(S)[_mttIndex] = 0.0 ;','\n']) ;
    fprintf(fid,['  else'                                                          ,'\n']) ;
    fprintf(fid,['    for(_mttIndex=0; _mttIndex<_mttNumStates; _mttIndex++) {'    ,'\n']) ;
    fprintf(fid,['      check_finite(S,_mttDerivative,_mttIndex) ;'                ,'\n']) ;
    fprintf(fid,['      ssGetdX(S)[_mttIndex] = _mttDerivative[_mttIndex] ;'       ,'\n']) ;
    fprintf(fid,['    }'                                                           ,'\n']) ;
    fprintf(fid,['}'                                                               ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,['static void mdlTerminate(SimStruct *S)'                          ,'\n']) ;
    fprintf(fid,['{'                                                               ,'\n']) ;
    fprintf(fid,['  UNUSED_ARG(S);'                                                ,'\n']) ;
    fprintf(fid,['  free (_mttInput) ;'                                            ,'\n']) ;
    fprintf(fid,['  free (_mttOutput) ;'                                           ,'\n']) ;
    fprintf(fid,['  free (_mttState) ;'                                            ,'\n']) ;
    fprintf(fid,['  free (_mttDerivative) ;'                                       ,'\n']) ;
    fprintf(fid,['}'                                                               ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    fprintf(fid,[''                                                                ,'\n']) ;
    
    fprintf(fid,['#ifdef  MATLAB_MEX_FILE'                                         ,'\n']) ;
    fprintf(fid,['#include "simulink.c"'                                           ,'\n']) ;
    fprintf(fid,['#else'                                                           ,'\n']) ;
    fprintf(fid,['#include "cg_sfun.h"'                                            ,'\n']) ;
    fprintf(fid,['#endif'                                                          ,'\n']) ;