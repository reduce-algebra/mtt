#! /bin/sh

set -e

#
# function definitions
#


set_debug ()
{
    debug=$1
    if [ $debug -eq 1 ]; then
	set -x
	make_debug='--debug=a'
    else
	set +x
	make_debug=''
    fi
}

exit_error ()
{
    message="$1"
    case $message in
	"Invalid Input"		) errno =  2 ;;
	"Unknown Template"	) errno =  3 ;;
	*			) errno = -1 ;;
    esac
    echo "#Error: " $message
    exit errno;
}       

check_for_valid_input ()
{
    args="$*"
    if [ $# -neq 4 ]; then
	exit_error "Invalid Input"
    fi
}

#
# file templates
#

# template_README      	compilation instructions
# template_mdk		simulink sub-system model

# template_mex_ae_c
# template_sfun_c
# template_sfun_debug_h
# template_sfun_input_c
# template_sfun_interface_c

write_template ()
{
    filename="$1"

    case $filename in

	README)

	    cat <<EOF
To build a Simulink funtion of the <mtt_model_name> model without using MTT:

mex <mtt_model_name>_sfun.c

The input block can be created with:

mex <mtt_model_name>_sfun_input.c

If numerical solution of algebraic equations is also required:

mex <mtt_model_name>_sfun_ae.c

The interface block can be created with

mex <mtt_model_name>_sfun_interface.c

EOF
	    ;;

	mdl)

	    cat <<EOF
Model {
  Name			  "<mtt_model_name>"
  Version		  4.00
  SampleTimeColors	  off
  LibraryLinkDisplay	  "all"
  WideLines		  off
  ShowLineDimensions	  on
  ShowPortDataTypes	  off
  ShowStorageClass	  off
  ExecutionOrder	  off
  RecordCoverage	  off
  CovPath		  "/"
  CovSaveName		  "covdata"
  CovMetricSettings	  "dw"
  CovNameIncrementing	  off
  CovHtmlReporting	  on
  BlockNameDataTip	  off
  BlockParametersDataTip  off
  BlockDescriptionStringDataTip	off
  ToolBar		  on
  StatusBar		  on
  BrowserShowLibraryLinks off
  BrowserLookUnderMasks	  off
  Created		  "Mon May 20 13:21:21 2002"
  Creator		  "geraint"
  UpdateHistory		  "UpdateHistoryNever"
  ModifiedByFormat	  "%<Auto>"
  LastModifiedBy	  "geraint"
  ModifiedDateFormat	  "%<Auto>"
  LastModifiedDate	  "Thu May 23 16:35:42 2002"
  ModelVersionFormat	  "1.%<AutoIncrement:13>"
  ConfigurationManager	  "None"
  SimParamPage		  "Solver"
  StartTime		  "0.0"
  StopTime		  "10.0"
  SolverMode		  "Auto"
  Solver		  "ode45"
  RelTol		  "1e-3"
  AbsTol		  "auto"
  Refine		  "1"
  MaxStep		  "auto"
  MinStep		  "auto"
  MaxNumMinSteps	  "-1"
  InitialStep		  "auto"
  FixedStep		  "auto"
  MaxOrder		  5
  OutputOption		  "RefineOutputTimes"
  OutputTimes		  "[]"
  LoadExternalInput	  off
  ExternalInput		  "[t, u]"
  SaveTime		  on
  TimeSaveName		  "tout"
  SaveState		  off
  StateSaveName		  "xout"
  SaveOutput		  on
  OutputSaveName	  "yout"
  LoadInitialState	  off
  InitialState		  "xInitial"
  SaveFinalState	  off
  FinalStateName	  "xFinal"
  SaveFormat		  "Array"
  LimitDataPoints	  on
  MaxDataPoints		  "1000"
  Decimation		  "1"
  AlgebraicLoopMsg	  "warning"
  MinStepSizeMsg	  "warning"
  UnconnectedInputMsg	  "warning"
  UnconnectedOutputMsg	  "warning"
  UnconnectedLineMsg	  "warning"
  InheritedTsInSrcMsg	  "warning"
  SingleTaskRateTransMsg  "none"
  MultiTaskRateTransMsg	  "error"
  IntegerOverflowMsg	  "warning"
  CheckForMatrixSingularity "none"
  UnnecessaryDatatypeConvMsg "none"
  Int32ToFloatConvMsg	  "warning"
  InvalidFcnCallConnMsg	  "error"
  SignalLabelMismatchMsg  "none"
  LinearizationMsg	  "none"
  VectorMatrixConversionMsg "none"
  SfunCompatibilityCheckMsg "none"
  BlockPriorityViolationMsg "warning"
  ArrayBoundsChecking	  "none"
  ConsistencyChecking	  "none"
  ZeroCross		  on
  Profile		  off
  SimulationMode	  "normal"
  RTWSystemTargetFile	  "grt.tlc"
  RTWInlineParameters	  off
  RTWRetainRTWFile	  off
  RTWTemplateMakefile	  "grt_default_tmf"
  RTWMakeCommand	  "make_rtw"
  RTWGenerateCodeOnly	  off
  TLCProfiler		  off
  TLCDebug		  off
  TLCCoverage		  off
  AccelSystemTargetFile	  "accel.tlc"
  AccelTemplateMakefile	  "accel_default_tmf"
  AccelMakeCommand	  "make_rtw"
  TryForcingSFcnDF	  off
  ExtModeMexFile	  "ext_comm"
  ExtModeBatchMode	  off
  ExtModeTrigType	  "manual"
  ExtModeTrigMode	  "normal"
  ExtModeTrigPort	  "1"
  ExtModeTrigElement	  "any"
  ExtModeTrigDuration	  1000
  ExtModeTrigHoldOff	  0
  ExtModeTrigDelay	  0
  ExtModeTrigDirection	  "rising"
  ExtModeTrigLevel	  0
  ExtModeArchiveMode	  "off"
  ExtModeAutoIncOneShot	  off
  ExtModeIncDirWhenArm	  off
  ExtModeAddSuffixToVar	  off
  ExtModeWriteAllDataToWs off
  ExtModeArmWhenConnect	  on
  ExtModeSkipDownloadWhenConnect off
  ExtModeLogAll		  on
  ExtModeAutoUpdateStatusClock off
  OptimizeBlockIOStorage  on
  BufferReuse		  on
  ParameterPooling	  on
  BlockReductionOpt	  on
  RTWExpressionDepthLimit 5
  BooleanDataType	  off
  BlockDefaults {
    Orientation		    "right"
    ForegroundColor	    "black"
    BackgroundColor	    "white"
    DropShadow		    off
    NamePlacement	    "normal"
    FontName		    "Helvetica"
    FontSize		    10
    FontWeight		    "normal"
    FontAngle		    "normal"
    ShowName		    on
  }
  AnnotationDefaults {
    HorizontalAlignment	    "center"
    VerticalAlignment	    "middle"
    ForegroundColor	    "black"
    BackgroundColor	    "white"
    DropShadow		    off
    FontName		    "Helvetica"
    FontSize		    10
    FontWeight		    "normal"
    FontAngle		    "normal"
  }
  LineDefaults {
    FontName		    "Helvetica"
    FontSize		    9
    FontWeight		    "normal"
    FontAngle		    "normal"
  }
  System {
    Name		    "<mtt_model_name>"
    Location		    [51, 441, 346, 574]
    Open		    on
    ModelBrowserVisibility  off
    ModelBrowserWidth	    200
    ScreenColor		    "white"
    PaperOrientation	    "landscape"
    PaperPositionMode	    "auto"
    PaperType		    "usletter"
    PaperUnits		    "inches"
    ZoomFactor		    "100"
    ReportName		    "simulink-default.rpt"
    Block {
      BlockType		      Inport
      Name		      "In1"
      Position		      [25, 43, 55, 57]
      Port		      "1"
      LatchInput	      off
      DataType		      "double"
      SignalType	      "real"
      Interpolate	      on
    }
    Block {
      BlockType		      SubSystem
      Name		      "MTT Model\n<mtt_model_name>"
      Ports		      [1, 1]
      Position		      [100, 20, 140, 80]
      ForegroundColor	      "blue"
      BackgroundColor	      "lightBlue"
      ShowPortLabels	      on
      TreatAsAtomicUnit	      off
      RTWSystemCode	      "Auto"
      RTWFcnNameOpts	      "Auto"
      RTWFileNameOpts	      "Auto"
      System {
	Name			"MTT Model\n<mtt_model_name>"
	Location		[45, 448, 1008, 720]
	Open			off
	ModelBrowserVisibility	off
	ModelBrowserWidth	200
	ScreenColor		"white"
	PaperOrientation	"landscape"
	PaperPositionMode	"auto"
	PaperType		"usletter"
	PaperUnits		"inches"
	ZoomFactor		"100"
	Block {
	  BlockType		  Inport
	  Name			  "In1"
	  Position		  [590, 203, 620, 217]
	  Port			  "1"
	  LatchInput		  off
	  DataType		  "double"
	  SignalType		  "real"
	  Interpolate		  on
	}
	Block {
	  BlockType		  "S-Function"
	  Name			  "MTT Model Inputs"
	  Ports			  [1, 1]
	  Position		  [390, 59, 565, 91]
	  BackgroundColor	  "lightBlue"
	  DropShadow		  on
	  FunctionName		  "<mtt_model_name>_sfun_input"
	  PortCounts		  "[]"
	  SFunctionModules	  "''"
	  Port {
	    PortNumber		    1
	    Name		    "MTT  Model Inputs: MTTU"
	    TestPoint		    off
	    LinearAnalysisOutput    off
	    LinearAnalysisInput	    off
	    RTWStorageClass	    "Auto"
	  }
	}
	Block {
	  BlockType		  "S-Function"
	  Name			  "MTT Plant Model"
	  Ports			  [1, 2]
	  Position		  [65, 61, 250, 199]
	  BackgroundColor	  "lightBlue"
	  DropShadow		  on
	  FunctionName		  "<mtt_model_name>_sfun"
	  PortCounts		  "[]"
	  SFunctionModules	  "''"
	  Port {
	    PortNumber		    1
	    Name		    "MTT Model States: MTTX"
	    TestPoint		    off
	    LinearAnalysisOutput    off
	    LinearAnalysisInput	    off
	    RTWStorageClass	    "Auto"
	  }
	  Port {
	    PortNumber		    2
	    Name		    "MTT Model Outputs: MTTY"
	    TestPoint		    off
	    LinearAnalysisOutput    off
	    LinearAnalysisInput	    off
	    RTWStorageClass	    "Auto"
	  }
	}
	Block {
	  BlockType		  "S-Function"
	  Name			  "S-Function"
	  Ports			  [4, 2]
	  Position		  [710, 47, 840, 238]
	  BackgroundColor	  "lightBlue"
	  DropShadow		  on
	  FunctionName		  "<mtt_model_name>_sfun_interface"
	  PortCounts		  "[]"
	  SFunctionModules	  "''"
	}
	Block {
	  BlockType		  Outport
	  Name			  "Out1"
	  Position		  [905, 183, 935, 197]
	  Port			  "1"
	  OutputWhenDisabled	  "held"
	  InitialOutput		  "[]"
	}
	Line {
	  Name			  "MTT Model States: MTTX"
	  Labels		  [2, 0]
	  SrcBlock		  "MTT Plant Model"
	  SrcPort		  1
	  Points		  [0, 0; 105, 0]
	  Branch {
	    Points		    [0, -20]
	    DstBlock		    "MTT Model Inputs"
	    DstPort		    1
	  }
	  Branch {
	    Points		    [0, 25]
	    DstBlock		    "S-Function"
	    DstPort		    2
	  }
	}
	Line {
	  Name			  "MTT Model Outputs: MTTY"
	  Labels		  [1, 0]
	  SrcBlock		  "MTT Plant Model"
	  SrcPort		  2
	  DstBlock		  "S-Function"
	  DstPort		  3
	}
	Line {
	  Name			  "MTT  Model Inputs: MTTU"
	  Labels		  [1, 0]
	  SrcBlock		  "MTT Model Inputs"
	  SrcPort		  1
	  DstBlock		  "S-Function"
	  DstPort		  1
	}
	Line {
	  SrcBlock		  "S-Function"
	  SrcPort		  1
	  Points		  [30, 0; 0, -70; -850, 0; 0, 105]
	  DstBlock		  "MTT Plant Model"
	  DstPort		  1
	}
	Line {
	  SrcBlock		  "In1"
	  SrcPort		  1
	  DstBlock		  "S-Function"
	  DstPort		  4
	}
	Line {
	  SrcBlock		  "S-Function"
	  SrcPort		  2
	  DstBlock		  "Out1"
	  DstPort		  1
	}
      }
    }
    Block {
      BlockType		      Outport
      Name		      "Out1"
      Position		      [185, 43, 215, 57]
      Port		      "1"
      OutputWhenDisabled      "held"
      InitialOutput	      "[]"
    }
    Line {
      SrcBlock		      "MTT Model\n<mtt_model_name>"
      SrcPort		      1
      DstBlock		      "Out1"
      DstPort		      1
    }
    Line {
      SrcBlock		      "In1"
      SrcPort		      1
      DstBlock		      "MTT Model\n<mtt_model_name>"
      DstPort		      1
    }
  }
}

EOF
	    ;;

	mex_ae.c)

	    cat <<EOF
/* -*-c-*-	Put emacs into c-mode
 * <mtt_model_name>_sfun_ae.c:
 * Matlab mex algebraic equations for <mtt_model_name>
 */

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <mex.h>
#include "sfun_debug.h"
#include "<mtt_model_name>_def.h"
#include "<mtt_model_name>_sympar.h"

/* utility procedures */

double *
array_of_double (size_t n)
{
  void *p = calloc (n, sizeof (double));
  if (! p) {
    fprintf (stderr, "*** Error: failed to allocate memory\n");
  }
  return (double *) p;
}

/* system equations */

static double *
<mtt_model_name>_ae (double *mttyz,
		     const double *mttx,
		     const double *mttu,
		     const double mttt,
		     const double *mttpar)
{
#include "<mtt_model_name>_ae.c"
  PRINT_LEAVE;
}

/* generic mex function */

#ifdef __cplusplus
extern "C" {
#endif

void
mexFunction (int nlhs, mxArray *plhs[],
	     int nrhs, const mxArray *prhs[])
{
  double *mttyz;		/* residuals */

  double *mttx;			/* states */
  double *mttu;			/* known + unknown inputs */
  double mttt;			/* time */
  double *mttpar;		/* parameters */

  unsigned int i;
  double *p;

  PRINT_ENTER;

  mttyz		= array_of_double (MTTNYZ);

  mttx		= array_of_double (MTTNX);
  mttu		= array_of_double (MTTNU + MTTNYZ);
  mttpar	= array_of_double (MTTNPAR);

  /* get trial values */
  p = mxGetPr (prhs[0]);
  for (i = 0; i < MTTNYZ; i++) {
    mttu[MTTNU + i] = p[i];
  }

  /* get states */
  p = mxGetPr (prhs[1]);
  for (i = 0; i < MTTNX; i++) {
    mttx[i] = p[i];
  }

  /* get known inputs */
  p = mxGetPr (prhs[2]);
  for (i = 0; i < MTTNU; i++) {
    mttu[i] = p[i];
  }

  /* get time */
  p = mxGetPr (prhs[3]);
  mttt = *p;

  /* get parameters */
  p = mxGetPr (prhs[4]);
  for (i = 0; i < MTTNPAR; i++) {
    mttpar[i] = p[i];
  }
  
  /* evaluate residuals */
  <mtt_model_name>_ae (mttyz, mttx, mttu, mttt, mttpar);
  
  /* return residuals */
  plhs[0] = mxCreateDoubleMatrix (MTTNYZ, 1, mxREAL);
  p = mxGetPr (plhs[0]);
  for (i = 0; i < MTTNYZ; i++) {
    p[i] = mttyz[i];
  }

  /* release memory */
  free (mttx);
  free (mttu);
  free (mttpar);
  free (mttyz);

  PRINT_LEAVE;
}

#ifdef __cplusplus
}
#endif

EOF
	    ;;

	sfun_c)

	    cat <<EOF
/* -*-c-*-	Put emacs into c-mode
 * <mtt_model_name>_sfun.c:
 * Matlab S-function simulation of <mtt_model_name>
 */

#define S_FUNCTION_NAME <mtt_model_name>_sfun
#define S_FUNCTION_LEVEL 2

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "simstruc.h"
#include "sfun_debug.h"
#include "<mtt_model_name>_def.h"
#include "<mtt_model_name>_sympar.h"

static double *mttdx;		/* pointer to rates */
static double *mttu;		/* pointer to inputs */
static double *mttpar;		/* pointer to parameters */
static double *mttx;		/* pointer to states */
static double *mtty;		/* pointer to outputs */
static double *mttyz;		/* pointer to residuals */
static double  mttt;		/* time */

static unsigned int i;		/* loop counter */

/* system equations */

static void
<mtt_model_name>_ae (void)
{
#include "<mtt_model_name>_ae.c"
  PRINT_LEAVE;
}

static void
<mtt_model_name>_numpar (void)
{
#include "<mtt_model_name>_numpar.c"
  PRINT_LEAVE;
}

static void
<mtt_model_name>_ode (void)
{
#include "<mtt_model_name>_ode.c"
  PRINT_LEAVE;
}

static void
<mtt_model_name>_odeo (void)
{
#include "<mtt_model_name>_odeo.c"
  PRINT_LEAVE;
}

static void
<mtt_model_name>_state (void)
{
#include "<mtt_model_name>_state.c"
  PRINT_LEAVE;
}

/* utility procedures */

static double *
array_of_double (size_t n)
{
  void *p = calloc (n, sizeof (double));
  if (! p) {
    fprintf (stderr, "*** Error: failed to allocate memory\n");
  }
  return (double *) p;
}

static void
initialise_arrays (void)
{
  PRINT_ENTER;

  mttdx		= array_of_double (MTTNX);
  mttpar	= array_of_double (MTTNPAR);
  mttu		= array_of_double (MTTNU + MTTNYZ);
  mttx		= array_of_double (MTTNX);
  mtty		= array_of_double (MTTNY);
  mttyz		= array_of_double (MTTNYZ);

  PRINT_LEAVE;
}

static void
update_states_from_simulink (SimStruct *S)
{
  PRINT_ENTER;
  for (i = 0; i < MTTNX; i++) {
    mttx[i] = ssGetContStates (S)[i];
  }
  PRINT_LEAVE;
}

static void
update_inputs_from_simulink (SimStruct *S)
{
  PRINT_ENTER;
  for (i = 0; i < MTTNU; i++) {
    mttu[i] = *ssGetInputPortRealSignalPtrs (S, 0)[i];
  }
  PRINT_LEAVE;
}

static void
update_inputs_from_solver (void)
{
  mxArray *MTT_MATLAB_P;
  mxArray *MTT_MATLAB_T;
  mxArray *MTT_MATLAB_U;
  mxArray *MTT_MATLAB_Ui;
  mxArray *MTT_MATLAB_X;

  double *p;

  PRINT_ENTER;

  /* starting value for solver - start with zero */
  MTT_MATLAB_Ui = mxCreateDoubleMatrix (MTTNYZ, 1, mxREAL);
  mxSetName (MTT_MATLAB_Ui, "MTT_Ui");
  p = mxGetPr (MTT_MATLAB_Ui);
  for (i = 0; i < MTTNYZ; i++) {
    p[i] = 0.0;
  }
  mexPutArray (MTT_MATLAB_Ui, "base");

  /* put states into matlab workspace */
  MTT_MATLAB_X = mxCreateDoubleMatrix (MTTNX, 1, mxREAL);
  mxSetName (MTT_MATLAB_X, "MTT_X");
  p = mxGetPr (MTT_MATLAB_X);
  for (i = 0; i < MTTNX; i++) {
    p[i] = mttx[i];
  }
  mexPutArray (MTT_MATLAB_X, "base");

  /* put known inputs into matlab workspace */
  MTT_MATLAB_U = mxCreateDoubleMatrix (MTTNU, 1, mxREAL);
  mxSetName (MTT_MATLAB_U, "MTT_U");
  p = mxGetPr (MTT_MATLAB_U);
  for (i = 0; i < MTTNU; i++) {
    p[i] = mttu[i];
  }
  mexPutArray (MTT_MATLAB_U, "base");

  /* put time into matlab workspace */
  MTT_MATLAB_T = mxCreateDoubleMatrix (1, 1, mxREAL);
  mxSetName (MTT_MATLAB_T, "MTT_T");
  *mxGetPr (MTT_MATLAB_T) = mttt;
  mexPutArray (MTT_MATLAB_T, "base");

  /* put parameters into matlab workspace */
  MTT_MATLAB_P = mxCreateDoubleMatrix (MTTNPAR, 1, mxREAL);
  mxSetName (MTT_MATLAB_P, "MTT_P");
  p = mxGetPr (MTT_MATLAB_P);
  for (i = 0; i < MTTNPAR; i++) {
    p[i] = mttpar[i];
  }
  mexPutArray (MTT_MATLAB_P, "base");

  /* call fsolve */
  mexEvalString ("MTT_Ui = fsolve (@<mtt_model_name>_sfun_ae, MTT_Ui, optimset('display','off'), MTT_X, MTT_U, MTT_T, MTT_P);");

  /* retrieve result */
  MTT_MATLAB_Ui = mexGetArray ("MTT_Ui", "base");
  p = mxGetPr (MTT_MATLAB_Ui);
  for (i = 0; i < MTTNYZ; i++) {
    mttu[MTTNU + i] = p[i];
  }

  /* free memory */
  mxDestroyArray (MTT_MATLAB_P);
  mxDestroyArray (MTT_MATLAB_T);
  mxDestroyArray (MTT_MATLAB_U);
  mxDestroyArray (MTT_MATLAB_Ui);
  mxDestroyArray (MTT_MATLAB_X);

  PRINT_LEAVE;
}

static void
update_simtime_from_simulink (SimStruct *S)
{
  PRINT_ENTER;
  mttt = ssGetT (S);
  PRINT_LEAVE;
}

/* S-function methods */

static void mdlInitializeSizes(SimStruct *S)
{
  PRINT_ENTER;

  ssSetNumSFcnParams(S, 0); 
  if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
    PRINT_LEAVE;
    return;
  }
  
  ssSetNumContStates(S, MTTNX);
  ssSetNumDiscStates(S, 0);
  
  if (!ssSetNumInputPorts(S, 1)) return;
  ssSetInputPortWidth(S, 0, MTTNU);
  ssSetInputPortDirectFeedThrough(S, 0, 1);

  if (!ssSetNumOutputPorts(S, 2)) return;
  ssSetOutputPortWidth(S, 0, MTTNX);
  ssSetOutputPortWidth(S, 1, MTTNY);
    
  ssSetNumSampleTimes(S, 1);
  ssSetNumRWork(S, 0);
  ssSetNumIWork(S, 0);
  ssSetNumPWork(S, 0);
  ssSetNumModes(S, 0);
  ssSetNumNonsampledZCs(S, 0);
  
  ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);
  
  initialise_arrays ();

  PRINT_LEAVE;
}

static void mdlInitializeSampleTimes(SimStruct *S)
{
  PRINT_ENTER;

  ssSetSampleTime(S, 0, CONTINUOUS_SAMPLE_TIME);
  ssSetOffsetTime(S, 0, 0.0);

  PRINT_LEAVE;
}

#define MDL_INITIALIZE_CONDITIONS
static void mdlInitializeConditions(SimStruct *S)
{
  PRINT_ENTER;

  <mtt_model_name>_numpar ();
  <mtt_model_name>_state ();

  for (i = 0; i < MTTNX; i++) {
    ssGetContStates (S)[i] = mttx[i];
  }

  PRINT_LEAVE;
}

static void mdlOutputs(SimStruct *S, int_T tid)
{
  PRINT_ENTER;

  update_states_from_simulink (S);
  update_inputs_from_simulink (S);
  if (MTTNYZ > 0) {
    update_inputs_from_solver ();
  }
  update_simtime_from_simulink (S);

  UNUSED_ARG(tid); /* not used in single tasking mode */

  <mtt_model_name>_odeo ();

  for (i = 0; i < MTTNX; i++) {
      ssGetOutputPortRealSignal (S, 0)[i] = mttx[i];
  }

  for (i = 0; i < MTTNY; i++) {
      ssGetOutputPortRealSignal (S, 1)[i] = mtty[i];
  }

  PRINT_LEAVE;
}

#define MDL_DERIVATIVES
static void mdlDerivatives(SimStruct *S)
{
  PRINT_ENTER;
    
  update_states_from_simulink (S);
  update_inputs_from_simulink (S);
  if (MTTNYZ > 0) {
    update_inputs_from_solver ();
  } 
  update_simtime_from_simulink (S);

  <mtt_model_name>_ode ();

  for (i = 0; i < MTTNX; i++) {
    ssGetdX (S)[i] = mttdx[i];
  }

  PRINT_LEAVE;
}

static void mdlTerminate(SimStruct *S)
{
  PRINT_ENTER;
  UNUSED_ARG(S);

  free (mttdx);
  free (mttpar);
  free (mttu);
  free (mttx);
  free (mtty);
  free (mttyz);

  PRINT_LEAVE;
}

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif

EOF
	    ;;

	sfun_debug.h)

	    cat <<EOF

#ifndef HAVE_SFUN_DEBUG_H
#define HAVE_SFUN_DEBUG_H


#if defined DEBUG && defined __GNUC__

#include <stdio.h>
#define PRINT_ENTER fprintf (stderr, "debug> Entered '%s'\n", __FUNCTION__);
#define PRINT_LEAVE fprintf (stderr, "debug> Leaving '%s'\n", __FUNCTION__);

#elif defined DEBUG && ! defined __GNUC__

#include <stdio.h>
#define PRINT_ENTER fprintf (stderr, "debug> Entered a function\n");
#define PRINT_LEAVE fprintf (stderr, "debug> Leaving a function\n");

#elif ! defined DEBUG

#define PRINT_ENTER
#define PRINT_LEAVE

#else

#error "Momentary lapse of logic : unreachable statement reached"

#endif


#endif /* HAVE_SFUN_DEBUG_H */

EOF
	    ;;

	sfun_input.c)

	    cat <<EOF
/* -*-c-*-	Put emacs into c-mode
 * <mtt_model_name>_sfun_input.c:
 * Matlab S-function inputs for <mtt_model_name>
 */

#define S_FUNCTION_NAME <mtt_model_name>_sfun_input
#define S_FUNCTION_LEVEL 2

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "simstruc.h"
#include "sfun_debug.h"
#include "<mtt_model_name>_def.h"
#include "<mtt_model_name>_sympar.h"

static double *mttu;		/* pointer to inputs */
static double *mttpar;		/* pointer to parameters */
static double *mttx;		/* pointer to states */
static double *mtty;		/* pointer to outputs */
static double  mttt;		/* time */

static unsigned int i;		/* loop counter */

/* system equations */

static void
<mtt_model_name>_input (void)
{
#include "<mtt_model_name>_input.c"
  PRINT_LEAVE;
}

static void
<mtt_model_name>_numpar (void)
{
#include "<mtt_model_name>_numpar.c"
  PRINT_LEAVE;
}

/* utility procedures */

static double *
array_of_double (size_t n)
{
  void *p = calloc (n, sizeof (double));
  if (! p) {
    fprintf (stderr, "*** Error: failed to allocate memory\n");
  }
  return (double *) p;
}

static void
initialise_arrays (void)
{
  PRINT_ENTER;

  mttpar	= array_of_double (MTTNPAR);
  mttu		= array_of_double (MTTNU + MTTNYZ);
  mttx		= array_of_double (MTTNX);
  mtty		= array_of_double (MTTNY);

  PRINT_LEAVE;
}

static void
update_inputs_from_simulink (SimStruct *S)
{
  PRINT_ENTER;
  for (i = 0; i < MTTNX; i++) {
    mttx[i] = *ssGetInputPortRealSignalPtrs (S, 0)[i];
  }
  PRINT_LEAVE;
}

static void
update_simtime_from_simulink (SimStruct *S)
{
  PRINT_ENTER;
  mttt = ssGetT (S);
  PRINT_LEAVE;
}

/* S-function methods */

static void mdlInitializeSizes(SimStruct *S)
{
  PRINT_ENTER;

  ssSetNumSFcnParams(S, 0); 
  if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
    PRINT_LEAVE;
    return;
  }
  
  ssSetNumContStates(S, 0);
  ssSetNumDiscStates(S, 0);
  
  if (!ssSetNumInputPorts(S, 1)) return;
  ssSetInputPortWidth(S, 0, MTTNX);
  ssSetInputPortDirectFeedThrough(S, 0, 1);
    
  if (!ssSetNumOutputPorts(S, 1)) return;
  ssSetOutputPortWidth(S, 0, MTTNU);
    
  ssSetNumSampleTimes(S, 1);
  ssSetNumRWork(S, 0);
  ssSetNumIWork(S, 0);
  ssSetNumPWork(S, 0);
  ssSetNumModes(S, 0);
  ssSetNumNonsampledZCs(S, 0);
  
  ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);
  
  initialise_arrays ();

  PRINT_LEAVE;
}

static void mdlInitializeSampleTimes(SimStruct *S)
{
  PRINT_ENTER;
  ssSetSampleTime(S, 0, CONTINUOUS_SAMPLE_TIME);
  ssSetOffsetTime(S, 0, 0.0);
  PRINT_LEAVE;
}

#define MDL_INITIALIZE_CONDITIONS
static void mdlInitializeConditions(SimStruct *S)
{
  PRINT_ENTER;
  <mtt_model_name>_numpar ();
  PRINT_LEAVE;
}

static void mdlOutputs(SimStruct *S, int_T tid)
{
  PRINT_ENTER;

  update_inputs_from_simulink (S);
  update_simtime_from_simulink (S);

  UNUSED_ARG(tid); /* not used in single tasking mode */

  <mtt_model_name>_input ();

  for (i = 0; i < MTTNU; i++) {
      ssGetOutputPortRealSignal (S, 0)[i] = mttu[i];
  }

  PRINT_LEAVE;
}

#define MDL_DERIVATIVES
static void mdlDerivatives(SimStruct *S)
{
  PRINT_ENTER;

  update_inputs_from_simulink (S);
  update_simtime_from_simulink (S);

  PRINT_LEAVE;
}

static void mdlTerminate(SimStruct *S)
{
  PRINT_ENTER;

  UNUSED_ARG(S);

  free (mttpar);
  free (mttu);
  free (mttx);
  free (mtty);

  PRINT_LEAVE;
}

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif

EOF
	    ;;

	sfun_interface.c)

	    cat <<EOF
/* -*-c-*-	Put emacs into c-mode
 * <mtt_model_name>_sfun_interface.c:
 * Matlab S-function to process inputs and outputs of <mtt_model_name>
 */


#define S_FUNCTION_NAME <mtt_model_name>_sfun_interface
#define S_FUNCTION_LEVEL 2

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "simstruc.h"
#include "sfun_debug.h"
#include "<mtt_model_name>_def.h"
#include "<mtt_model_name>_sympar.h"

static double *mttu;		/* pointer to inputs */
static double *mttpar;		/* pointer to parameters */
static double *mttx;		/* pointer to states */
static double *mtty;		/* pointer to outputs */
static double  mttt;		/* time */

static double *controller_inputs;
static double *controller_outputs;

static unsigned int i;		/* loop counter */

/* Start EDIT */
/* Edit this block to define the number of controller inputs, outputs and parameters */
const int NumberOfControllerInputs	= 1; /* inputs TO controller */
const int NumberOfControllerOutputs	= 1; /* outputs FROM controller */
/* End EDIT */

static void
<mtt_model_name>_process_inputs (void)
{
  /* insert <mtt_model_name>_struc.c */

  /* Start EDIT */
  /* Edit this block to process the model inputs and outputs */
  
  /* Remove the following line */
  fprintf (stderr, "*** Error: <mtt_model_name>_sfun_interface.c has not been customised!\n"); return;

  /* simple example follows */

  /* Get total of all outputs and input to controller */
  controller_inputs[0] = 0.0;
  for (i = 0; i < MTTNY; i++) {
    controller_inputs[0] += mtty[i];
  }

  /* overwrite first model input with output from controller */
  mttu[0] = controller_outputs[0];

  /* End EDIT */
}


/******************************************************************************
 *                DO NOT EDIT ANYTHING BELOW THIS LINE                        *
 ******************************************************************************/

/* system equations */

static void
<mtt_model_name>_numpar (void)
{
#include "<mtt_model_name>_numpar.c"
  PRINT_LEAVE;
}

/* utility procedures */

static double *
array_of_double (size_t n)
{
  void *p = calloc (n, sizeof (double));
  if (! p) {
    fprintf (stderr, "*** Error: failed to allocate memory\n");
  }
  return (double *) p;
}

static void
initialise_arrays (void)
{
  PRINT_ENTER;

  mttpar	= array_of_double (MTTNPAR);
  mttu		= array_of_double (MTTNU + MTTNYZ);
  mttx		= array_of_double (MTTNX);
  mtty		= array_of_double (MTTNY);

  controller_inputs	= array_of_double (NumberOfControllerInputs);
  controller_outputs	= array_of_double (NumberOfControllerOutputs);

  PRINT_LEAVE;
}

static void
update_inputs_from_simulink (SimStruct *S)
{
  PRINT_ENTER;
  for (i = 0; i < MTTNU; i++) {
    mttu[i] = *ssGetInputPortRealSignalPtrs (S, 0)[i];
  }
  for (i = 0; i < MTTNX; i++) {
    mttx[i] = *ssGetInputPortRealSignalPtrs (S, 1)[i];
  }
  for (i = 0; i < MTTNY; i++) {
    mtty[i] = *ssGetInputPortRealSignalPtrs (S, 2)[i];
  }
  for (i = 0; i < NumberOfControllerOutputs; i++) {
    controller_outputs[i] = *ssGetInputPortRealSignalPtrs (S, 3)[i];
  }
  PRINT_LEAVE;
}

static void
update_simtime_from_simulink (SimStruct *S)
{
  PRINT_ENTER;
  mttt = ssGetT (S);
  PRINT_LEAVE;
}

/* S-function methods */

static void mdlInitializeSizes(SimStruct *S)
{
  PRINT_ENTER;

  ssSetNumSFcnParams(S, 0); 
  if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
    PRINT_LEAVE;
    return;
  }
  
  ssSetNumContStates(S, 0);
  ssSetNumDiscStates(S, 0);
  
  if (!ssSetNumInputPorts(S, 4)) return;
  ssSetInputPortWidth(S, 0, MTTNU);
  ssSetInputPortWidth(S, 1, MTTNX);
  ssSetInputPortWidth(S, 2, MTTNY);
  ssSetInputPortWidth(S, 3, NumberOfControllerOutputs);	/* inputs from controller */
  ssSetInputPortDirectFeedThrough(S, 0, 1);
  ssSetInputPortDirectFeedThrough(S, 1, 1);
  ssSetInputPortDirectFeedThrough(S, 2, 1);
  ssSetInputPortDirectFeedThrough(S, 3, 1);
    
  if (!ssSetNumOutputPorts(S, 2)) return;
  ssSetOutputPortWidth(S, 0, MTTNU); /* altered inputs */
  ssSetOutputPortWidth(S, 1, NumberOfControllerInputs); /* outputs to controller */
    
  ssSetNumSampleTimes(S, 1);
  ssSetNumRWork(S, 0);
  ssSetNumIWork(S, 0);
  ssSetNumPWork(S, 0);
  ssSetNumModes(S, 0);
  ssSetNumNonsampledZCs(S, 0);
  
  ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);
  
  initialise_arrays ();

  PRINT_LEAVE;
}

static void mdlInitializeSampleTimes(SimStruct *S)
{
  PRINT_ENTER;
  ssSetSampleTime(S, 0, CONTINUOUS_SAMPLE_TIME);
  ssSetOffsetTime(S, 0, 0.0);
  PRINT_LEAVE;
}

#define MDL_INITIALIZE_CONDITIONS
static void mdlInitializeConditions(SimStruct *S)
{
  PRINT_ENTER;
  <mtt_model_name>_numpar ();
  PRINT_LEAVE;
}

static void mdlOutputs(SimStruct *S, int_T tid)
{
  PRINT_ENTER;

  update_inputs_from_simulink (S);
  update_simtime_from_simulink (S);

  <mtt_model_name>_process_inputs ();

  UNUSED_ARG(tid); /* not used in single tasking mode */

  for (i = 0; i < MTTNU; i++) {
    ssGetOutputPortRealSignal (S, 0)[i] = mttu[i];
  }
  
  for (i = 0; i < NumberOfControllerInputs; i++) {
    ssGetOutputPortRealSignal (S, 1)[i] = controller_inputs[i];
  }

  PRINT_LEAVE;
}

#define MDL_DERIVATIVES
static void mdlDerivatives(SimStruct *S)
{
  PRINT_ENTER;
  PRINT_LEAVE;
}

static void mdlTerminate(SimStruct *S)
{
  PRINT_ENTER;

  UNUSED_ARG(S);

  free (mttpar);
  free (mttu);
  free (mttx);
  free (mtty);

  free (controller_inputs);
  free (controller_outputs);

  PRINT_LEAVE;
}

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif

EOF
	    ;;

	*)
	    exit_error "Unknown Template";
	    ;;

    esac
}	    







### main program

set_debug 0
check_for_valid_input "$*"

OPTS="$1" SYS="$2" REP="$3" LANG="$4" make $make_debug -f ${MTT_REP}/sfun_rep/Makefile ${2}_${3}.${4}
exit 0